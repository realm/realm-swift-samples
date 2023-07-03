////////////////////////////////////////////////////////////////////////////
//
// Copyright 2023 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import SwiftUI
import RealmSwift

// Entry Point
struct InitialView: View {
    @ObservedObject var realmManager = RealmManager()
    @ObservedObject var app: RealmSwift.App
    @State var isLogged: Bool = false

    var body: some View {
        // This observes changes on the App, which includes User State changes,
        // and will trigger if the user state changes during the app cycle of the App.
        switch app.currentUser?.state {
        case .loggedIn:
            if let user = app.currentUser {
                if let realm = realmManager.realm {
                    KioskView(user: user)
                        .environment(\.realmConfiguration, realm.configuration)
                        .toolbar {
                            ToolbarItemGroup(placement: .bottomBar) {
                                Text("\(realmManager.sessionState?.literal ?? "")")
                                Text("\(realmManager.connectionState?.literal ?? "")")
                            }
                        }
                } else {
                    ProgressView()
                        .onAppear {
                            Task {
                                do {
                                    // Opens the realm asynchronously, and waits for the data to be downloaded.
                                    try await realmManager.openRealmWithUser(user)
                                } catch {
                                    print("Error while opening realm \(error)")
                                }
                            }
                        }
                }

            }
        case .loggedOut, .removed, .none:
            LoginView(isLogged: isLogged)
                .padding()
        default: EmptyView() // Unreachable
        }
    }
}

// Login/Sign Up View.
struct LoginView: View {
    @State var isLogged: Bool

    @ObservedObject var appAuthManager = AppAuthManager()

    @State var username: String = "john@doe.com"
    @State var password: String = "123456"

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack {
                    TextField("Username/Email", text: $username)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.none)
                    SecureField("Password", text: $password)
                        .textInputAutocapitalization(.none)
                    Button("Login") {
                        Task {
                            await appAuthManager.login(username: username, password: password)
                            isLogged = true
                        }
                    }
                    .disabled(username.isEmpty || password.isEmpty)
                    Button("Sign Up") {
                        Task {
                            await appAuthManager.register(username: username, password: password)
                        }
                    }
                    .disabled(username.isEmpty || password.isEmpty)
                }
                Spacer()
                VStack {
                    Text(appAuthManager.signUpMessage)
                        .foregroundStyle(.blue)
                    Text(appAuthManager.errorMessage)
                        .foregroundStyle(.red)
                }
                Spacer()
            }

            if appAuthManager.isLoading {
                ProgressView()
            }
        }
    }
}

// Kiosks List View, shows all kiosk associated to the logged user.
struct KioskView: View {
    var user: User

    @Environment(\.realm) var realm
    @ObservedResults(Kiosk.self) var kiosks

    @State private var name: String = ""
    @State private var showingAlert = false
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                List(kiosks) { kiosk in
                    NavigationLink(value: kiosk) {
                        HStack {
                            Text(kiosk.name)
                        }
                    }
                }
                .navigationDestination(for: Kiosk.self) { kiosk in
                    ProductsView(kiosk: kiosk)
                        .onAppear {
                            Task {
                                do {
                                    try await addSubscriptionForKioskId(kiosk._id)
                                    isLoading = false
                                } catch {
                                    print("Error during subscription")
                                    isLoading = true
                                }
                            }
                        }
                }
            }
            .navigationTitle("Kiosks List")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("LogOut") {
                        realmApp.currentUser?.logOut { _ in }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showingAlert.toggle()
                    }
                    .alert("Kiosk Name", isPresented: $showingAlert) {
                        TextField("Kiosk's Name", text: $name)
                        Button("OK", action: createNewKiosk)
                    } message: {
                        Text("Introduce Kiosk's name.")
                    }
                }
            }
        }
    }

    func createNewKiosk() {
        let newKiosk = Kiosk()
        newKiosk.name = name
        newKiosk.userId = realmApp.currentUser?.id ?? ""
        $kiosks.append(newKiosk)
    }

    // Adds a new subscription every time you disclose a kiosk's products
    func addSubscriptionForKioskId(_ id: ObjectId) async throws {
        isLoading = true
        let subs = realm.subscriptions
        try await subs.update {
            subs.removeAll(ofType: Product.self)
            subs.append(QuerySubscription<Product> { $0.storeId == id })
        }
    }
}

// Products view, show a list of all the products and prices associated
// to the selected kiosk.
struct ProductsView: View {
    @ObservedRealmObject var kiosk: Kiosk

    @Environment(\.realm) var realm
    @ObservedResults(Product.self) var products

    var body: some View {
        ZStack {
            List(products) { product in
                NavigationLink(value: product) {
                    HStack {
                        Text(product.title)
                        Spacer()
                        Text("$\(String(format: "%.2f", product.price))")
                    }
                }
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .toolbar {
                Button("New") {
                    addNewProduct()
                }
            }
        }
        .navigationTitle(kiosk.name)
        .onAppear {
            $products.where = { $0.storeId == kiosk._id }
        }
    }

    func addNewProduct() {
        let newProduct = Product()
        newProduct.title = ""
        newProduct.storeId = kiosk._id
        $products.append(newProduct)
        $kiosk.products.append(newProduct)
    }

    // Removes subscription for the kiosk products when the view is unloaded,
    // this will remove the data associated to the subscription from the realm.
    func removeSubscription() async throws {
        let subs = realm.subscriptions
        try await subs.update {
            subs.remove(named: "kiosks_products")
        }
    }
}

// Edit your product details
struct ProductDetailView: View {
    @ObservedRealmObject var product: Product

    var body: some View {
        Form {
            TextField("Title", text: $product.title)
            TextField("Price", value: $product.price, format: .currency(code: "USD"))
            Picker("In Stock", selection: $product.numInStock) {
                ForEach(0..<100) {
                    Text("\($0)")
                }
            }

        }
        .navigationBarTitle(product.title)
    }
}
