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

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    @Published var realm: Realm?
    @Published var configuration: Realm.Configuration?

    @MainActor // Property wrapper that makes sure this gets executed on main thread
    func initializeRealm(user: User) async throws {

        // Configuration of subscription options
        let configuration = user.flexibleSyncConfiguration(initialSubscriptions: { subscription in
            if subscription.first(named: "all-recipes") == nil {
                subscription.append(QuerySubscription<Recipe>(name: "all-recipes"))
            }

            if subscription.first(named: "all-purchases") == nil {
                subscription.append(QuerySubscription<Purchase>(name: "all-purchases"))
            }
        })

        do {
            _ = try await Realm(configuration: configuration, downloadBeforeOpen: .once)
        } catch {
            print("There was an error opening the realm: \(error.localizedDescription)")
        }
    }

    func reset() {
        realm = nil
    }
}
