//
//  AuthenticationManager.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 26/09/2023.
//

import Foundation
import RealmSwift

let realmApp = RealmSwift.App(id: "foodie-folio-ojvso")

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()

    // MARK: - User Authentication
    func loginUser(email: String, password: String) async -> Result<User, Error> {
        do {
            let user = try await realmApp.login(credentials: .emailPassword(email: email, password: password))
            return .success(user)
        } catch {
            return .failure(error)
        }
    }

    func registerUser(email: String, password: String) async -> Result<User, Error> {
        do {
            try await realmApp.emailPasswordAuth.registerUser(email: email, password: password)

            let user = try await realmApp.login(credentials: .emailPassword(email: email, password: password))
            return .success(user)
        } catch {
            return .failure(error)
        }
    }

    func logoutUser(_ user: User) async -> Result<Void, Error> {
        do {
            try await realmApp.currentUser?.logOut()
            return .success(())
        } catch {
            return .failure(error)
        }
    }

}
