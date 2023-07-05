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
struct AnalyticsTelemetricsDataApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            OptionsView()
                .onAppear {
                    // Setting the default logger to `.all`.
                    configureLogger()
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

enum Navigation {
    case telemetric
    case analytics
}

struct OptionsView: View {
    @State var navigationPath = [Navigation]()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Spacer()
                Button("Analytics Sample") {
                    navigationPath.append(Navigation.analytics)
                }
                Spacer()
                Button("Telemetric Sample") {
                    navigationPath.append(Navigation.telemetric)
                }
                Spacer()
            }
            .padding()
            .navigationDestination(for: Navigation.self) { navigation in
                switch navigation {
                case .analytics:
                    AnalyticsView()
                case .telemetric:
                    TelemetricView()
                }
            }
        }
    }
}
