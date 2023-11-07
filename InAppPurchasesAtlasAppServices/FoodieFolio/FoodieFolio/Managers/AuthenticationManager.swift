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

let realmApp = RealmSwift.App(id: "YOUR_APP_ID")

class AuthenticationManager: ObservableObject {

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
