//
//  RealmManager.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 09/08/2023.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    @Published var realm: Realm?
    @Published var configuration: Realm.Configuration?

    @MainActor // Property wrapper that makes sure this gets executed on main thread
    func initializeRealm(user: User) async throws {

        // Configuration of subscription options
        let configuration = user.flexibleSyncConfiguration(initialSubscriptions: { subscription in
            if subscription.first(named: "all-recipes") != nil && subscription.first(named: "all-purchases") != nil {
                return
            } else {
                if subscription.first(named: "all-recipes") == nil {
                    subscription.append(QuerySubscription<Recipe>(name: "all-recipes"))
                }
                if subscription.first(named: "all-purchases") == nil {
                    subscription.append(QuerySubscription<Purchase>(name: "all-purchases"))
                }
            }
        }, rerunOnOpen: true)

        do {
            self.realm = try await Realm(configuration: configuration, downloadBeforeOpen: .once)
        } catch {
            print("There was an error opening the realm: \(error.localizedDescription)")
        }
    }

    func reset() {
        realm = nil
    }
}
