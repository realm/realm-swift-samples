//
//  AccountView.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 02/10/2023.
//

import SwiftUI
import RealmSwift

struct AccountView: View {

    var body: some View {
        NavigationView {
            List {
                Text("Logout")
                    .onTapGesture {
                        Task {
                            if let user = realmApp.currentUser {
                                let result = await AuthenticationManager.shared.logoutUser(user)

                                switch result {
                                case .success:
                                    print("Successful logout")
                                    /*
                                     No need to handle the navigation to LoginView,
                                     this is handled by ContentView functionality
                                    */
                                case .failure(let error):
                                    print("Error in logout: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
            }
            .navigationTitle("My Account")
        }
    }
}

#Preview {
    AccountView()
}
