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

struct ContentView: View {
    @ObservedObject var realmManager = RealmManager()
    @ObservedObject var app: RealmSwift.App

    var body: some View {
        // This observes changes on the App, and will trigger if the user state changes
        // during the app cycle of the App.
        // This is needed at least once in the app cycle. Realm will persist the current user
        // after logged in and will be able to access the user's realm, even if offline, later on.
        switch app.currentUser?.state {
        case .loggedIn:
            if let user = app.currentUser {
                if let realm = realmManager.realm {
                    BookLibraryView(user: user)
                        .environment(\.realmConfiguration, realm.configuration)
                } else {
                    ProgressView()
                        .onAppear {
                            Task {
                                do {
                                    // Opens the realm asynchronously, only syncing the first time.
                                    // If the device is offline, this will open the realm without
                                    // syncing any initial data.
                                    try await realmManager.openRealmWithUser(user)
                                } catch {
                                    print("Error while opening realm \(error)")
                                }
                            }
                        }
                }
            }
        case .loggedOut, .removed, .none:
            LoginView()
                .padding()
                .onAppear {
                    realmManager.reset()
                }
        default: EmptyView() // Unreachable
        }
    }
}

// Login/Sign Up View.
struct LoginView: View {
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
                        .textInputAutocapitalization(.never)
                    VStack {
                        Button("Log In") {
                            Task {
                                let credentials = Credentials.emailPassword(email: username, password: password)
                                await appAuthManager.login(credentials: credentials)
                            }
                        }
                        .disabled(username.isEmpty || password.isEmpty)
                        .padding(5)
                        Button("Sign Up") {
                            Task {
                                await appAuthManager.register(username: username, password: password)
                            }
                        }
                        .disabled(username.isEmpty || password.isEmpty)
                        .padding(5)
                        // Anonymous login will allow you to see public books shared by other users.
                        Button("Log In Anonymously") {
                            Task {
                                await appAuthManager.login(credentials: .anonymous)
                            }
                        }
                        .padding(5)
                    }
                }
                Spacer()
                VStack {
                    Text(appAuthManager.signUpMessage)
                        .foregroundStyle(.green)
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

struct BookLibraryView: View {
    var user: User
    @ObservedResults(Book.self) var books

    @State private var text: String = ""
    @State private var showingAlert = false
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                List(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                              .foregroundColor(.white)
                              .background((book.isPublic ? Color.green : Color.red))
                              .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(book.title)
                                Text(book.author)
                                    .foregroundStyle(.blue)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(book.releaseDate, format: .dateTime.year())
                            }
                        }
                        .frame(height: 50)
                    }
                }
                .navigationDestination(for: Book.self) { book in
                    BookEditView(book: book)
                }
            }
            .navigationTitle("My List")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Log Out") {

                        realmApp.currentUser?.logOut { _ in }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Add Book") {
                        showingAlert.toggle()
                    }
                    .alert("Book title", isPresented: $showingAlert) {
                        TextField("Book's title", text: $text)
                        Button("Create", action: addNewBook)
                    } message: {
                        Text("Title of the book.")
                    }
                }
            }
        }
    }

    func addNewBook() {
        let newBook = Book()
        newBook.title = text
        newBook.userId = user.id
        newBook.isPublic = false
        $books.append(newBook)
        text = ""
    }
}

struct BookEditView: View {
    @ObservedRealmObject var book: Book

    var body: some View {
        Form {
            Section {
                TextField("Book title", text: $book.title)
                TextField("Author", text: $book.author)
                DatePicker("Release Date", selection: $book.releaseDate, displayedComponents: .date)
            }
            Section {
                TextField("Country", text: $book.country)
                TextField("Language", text: $book.language)
            }
            Section {
                Toggle("Is Public", isOn: $book.isPublic)
            }
            Section {
                TextField("Review", text: $book.review, axis: .vertical)
                    .lineLimit(5...200)
            }
        }
        .navigationBarTitle(book.title)
    }
}
