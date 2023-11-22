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

struct AccountView: View {

    var body: some View {
        NavigationView {
            List {
                Text("Logout")
                    .onTapGesture {
                        Task {
                            if let user = realmApp.currentUser {
                                let result = await AuthenticationManager().logoutUser(user)

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
