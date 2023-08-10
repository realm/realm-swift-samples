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

    // Set the flexible sync configuration for the realm.
    @MainActor
    func openRealmWithUser(_ user: User) async throws {
        // Setting the configuration with `cancelAsyncOpenOnNonFatalErrors` and an initial subscription.
        let configuration = user.flexibleSyncConfiguration(cancelAsyncOpenOnNonFatalErrors: true,
                                                           initialSubscriptions: { subs in
            // Setting the subscription to all public Books and the book associated to the userId
            subs.append(QuerySubscription<Book> { $0.isPublic || $0.userId == user.id })
        })

        // Setting the download configuration to `.always` will wait to sync data on every realm open.
        do {
            // If you want to sync your Device Sync data only the very first time the realm
            // is opened, change to `.once`.
            self.realm = try await Realm(configuration: configuration, downloadBeforeOpen: .always)
            return
            // If there is no internet connection, we continue to try to open the realm without syncing.
        } catch {}

        do {
            // If there is an issue on the first sync, we will try to open the realm without
            // syncing any data even on the first open.
            // This will throw if the error is related to the configuration.
            self.realm = try await Realm(configuration: configuration, downloadBeforeOpen: .never)
        } catch {
            // If there is a different error which doesn't allow us to open the realm even without syncing,
            // we print the error.
            print("There was an error opening the realm: \(error.localizedDescription)")
        }
    }

    func reset() {
        realm = nil
    }
}
