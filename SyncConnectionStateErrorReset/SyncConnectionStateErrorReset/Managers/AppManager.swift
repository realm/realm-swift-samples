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

let applicationServiceId = "flexiblesyncapp-mgbxq"
let realmApp = RealmSwift.App(id: applicationServiceId)

class AppErrorManager: ObservableObject {
    var error: String?
    @Published var showingError = false

    // This will initialize the (sync/app services) error handler, which will trigger
    // an alert at any moment of the App cycle.
    func initErrorHandler() {
        realmApp.syncManager.errorHandler = { (error, _) in
            // Check https://www.mongodb.com/docs/realm-sdks/objc/latest/Enums/RLMSyncError.html
            // for extra info about each error code.
            let syncError = error as NSError
            var message = ""
            if syncError.code == SyncError.clientInternalError.rawValue {
                message = "Internal client error: \(error.localizedDescription)"
            } else if syncError.code == SyncError.clientSessionError.rawValue {
                message = "Session level error: \(error.localizedDescription)"
            // Compensating writes error
            } else if syncError.code == SyncError.writeRejected.rawValue {
                message = "Session level error: \(error.localizedDescription)"
            // Invalid flexible sync subscription
            } else if syncError.code == SyncError.invalidFlexibleSyncSubscriptions.rawValue {
                    message = "Session level error: \(error.localizedDescription)"
            // This should not be reachable if there is a clientReset block
            } else if syncError.code == SyncError.clientUserError.rawValue {
                message = "User error: \(error.localizedDescription)"
            } else {
                // Other errors
                message = "Unexpected error: \(error.localizedDescription)"
            }
            self.error = message
            self.showingError = true
        }
    }
}

class AppAuthManager: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var signUpMessage: String = ""

    // Function to register a user with email and password, this will return if the registration
    // is successful or will update the error message on the UI in case of an error otherwise.
    // For this simplified example, the app is configured via the Atlas App Services UI
    // to automatically confirm users' emails.
    @MainActor
    func register(username: String, password: String) async {
        cleanMessages()
        isLoading = true
        do {
            try await realmApp.emailPasswordAuth.registerUser(email: username, password: password)
            signUpMessage = "Registration successful"
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // Function to login a user with email and password, this will return the user if the login
    // is successful or will update the error message on the UI in case of an error otherwise.
    // Access tokens are created once a user logs in. These tokens are refreshed
    // automatically by the SDK when needed. Manually refreshing the token is only
    // required if requests are sent outside of the SDK. If that's the case, see:
    // https://www.mongodb.com/docs/realm/sdk/swift/users/authenticate-users/#get-a-user-access-token

    // By default, refresh tokens expire 60 days after they are issued. You can configure this
    // time for your App's refresh tokens to be anywhere between 30 minutes and 180 days. See:
    // https://www.mongodb.com/docs/atlas/app-services/users/sessions/#configure-refresh-token-expiration
    @MainActor
    func login(username: String, password: String) async {
        cleanMessages()
        isLoading = true
        do {
            let credentials = Credentials.emailPassword(email: username, password: password)
            _ = try await realmApp.login(credentials: credentials)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func cleanMessages() {
        errorMessage = ""
        signUpMessage = ""
    }
}
