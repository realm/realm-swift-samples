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

class AppAuthManager: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var signUpMessage: String = ""

    init() {
        // We set a timeout for the app, so if there is no internet connection, opening the realm
        // can throw.
        realmApp.syncManager.timeoutOptions = SyncTimeoutOptions(connectTimeout: 5)
    }

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

    // Function to login a user with email and password. This will return the user if the login
    // is successful or will update the error message on the UI in case of an error otherwise.
    // Access tokens are created once a user logs in. These tokens are refreshed
    // automatically by the SDK when needed. Manually refreshing the token is only
    // required if requests are sent outside of the SDK. If that's the case, see:
    // https://www.mongodb.com/docs/realm/sdk/swift/users/authenticate-users/#get-a-user-access-token

    // By default, refresh tokens expire 60 days after they are issued. You can configure this
    // time for your App's refresh tokens to be anywhere between 30 minutes and 180 days. See:
    // https://www.mongodb.com/docs/atlas/app-services/users/sessions/#configure-refresh-token-expiration
    // When the refresh token expires, the user must login again, and an error is throw in the
    // sync manager's `errorHandler`.
    @MainActor
    func login(credentials: Credentials) async {
        cleanMessages()
        isLoading = true
        do {
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
