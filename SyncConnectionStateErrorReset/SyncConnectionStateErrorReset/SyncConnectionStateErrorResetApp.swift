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

@main
struct SyncConnectionStateErrorResetApp: SwiftUI.App {
    @ObservedObject var appErrorManager = AppErrorManager()

    var body: some Scene {
        WindowGroup {
            InitialView(app: realmApp)
                .onAppear {
                    // Setting the default logger to `.all`.
                    configureLogger()
                    // Setting the error handler at the root of the app,
                    // this will trigger an alert when there is a sync error.
                    appErrorManager.initErrorHandler()
                }
                .alert(isPresented: $appErrorManager.showingError) {
                    Alert(title: Text("Error"), message: Text(appErrorManager.error ?? ""), dismissButton: .cancel())
                }
        }
    }

    func configureLogger() {
        /**
        Using log level 'all', 'trace', or 'debug' is good for debugging during developing, not for production.
        - see: https://www.mongodb.com/docs/realm/sdk/swift/logging/
         */
        Logger.shared.level = .all
    }
}
