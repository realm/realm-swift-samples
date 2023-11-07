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

struct ContentView: View {
    @ObservedObject var realmManager = RealmManager()
    @ObservedObject var app: RealmSwift.App

    var body: some View {
        switch app.currentUser?.state {
        case .loggedIn:
            if let user = app.currentUser {
                if let realm = realmManager.realm {
                    RecipesListView()
                        .environment(\.realmConfiguration, realm.configuration)
                } else {
                    ProgressView()
                        .onAppear {
                            Task {
                                do {
                                    try await realmManager.initializeRealm(user: user)
                                } catch {
                                    print("Error while opening realm \(error)")
                                }
                            }
                        }
                }
            }
        case .loggedOut, .removed, .none:
            LoginView()
                .onAppear {
                    realmManager.reset()
                }
        default:
            EmptyView()
        }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
