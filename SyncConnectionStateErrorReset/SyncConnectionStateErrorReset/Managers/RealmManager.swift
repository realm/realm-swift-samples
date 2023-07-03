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
    @Published var connectionState: SyncSession.ConnectionState?
    @Published var sessionState: SyncSession.State?
    // We need to maintain the realm allocated to check the connection status.
    @Published var realm: Realm?

    private var sessionToken: NSKeyValueObservation?
    private var connectionToken: NSKeyValueObservation?

    // Set the flexible sync configuration for the realm, adding options for
    // client reset and `initialSubscription`.
    func openRealmWithUser(_ user: User) async throws {
        // Setting the configuration with a client reset mode and an initial subscription.
        let configuration = user.flexibleSyncConfiguration(clientResetMode:
                // In case of a client reset this will trigger the following blocks
                // during the client reset process.
                .recoverOrDiscardUnsyncedChanges(beforeReset: { beforeRealm in
                    print("Client reset before block with \(String(describing: beforeRealm.configuration.fileURL))")
                }, afterReset: { beforeRealm, afterRealm in
                    print("Client reset after block old realm \(String(describing: beforeRealm.configuration.fileURL))")
                    print("Client reset after block new realm \(String(describing: afterRealm.configuration.fileURL))")
                    // Initial subscriptions are synced the first time the realm opens.
                }), initialSubscriptions: { subs in
                    subs.append(QuerySubscription<Kiosk> { $0.userId == user.id })
                })

        let realm = try await Realm(configuration: configuration, downloadBeforeOpen: .always)
        try initConnectionListeners(realm: realm)
        self.realm = realm
    }

    // Initialise the connection listeners (Session state and Session connection state).
    func initConnectionListeners(realm: Realm) throws {
        connectionToken = realm.syncSession?.observe(\SyncSession.connectionState, options: [.initial]) { session, _ in
            self.connectionState = session.connectionState
            // Session state is not KVO Compliant, but we are checking and updating their
            // value when there is an update on the connection state.
            self.sessionState = session.state
        }
    }
}

extension SyncSession.ConnectionState {
    var literal: String {
        switch self {
        case .connected:
            return "Connected"
        case .connecting:
            return "Connecting"
        case .disconnected:
            return "Disconnected"
        @unknown default:
            return "unknown"
        }
    }
}

extension SyncSession.State {
    var literal: String {
        switch self {
        case .active:
            return "Active"
        case .inactive:
            return "Inactive"
        case .invalid:
            return "Invalid"
        @unknown default:
            return "unknown"
        }
    }
}
