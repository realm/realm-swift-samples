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

struct AnalyticsView: View {
    @State var errorMessage: String = ""
    var body: some View {
        VStack {
            TrackEventView()
                .onAppear {
                    Task {
                        do {
                            try await AnalyticsManager.shared.configure()
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                }
            Text("Error \(errorMessage)")
                .foregroundStyle(.red)
        }
    }
}

// Struct for temporary storing current session events tracked
struct EventListEvent: Hashable {
    var id = UUID()
    var label = ""
    var eventType: AnalyticsType
}

struct TrackEventView: View {
    @State var events: [EventListEvent] = []

    @State var label: String = ""
    @State var info: String = ""
    @State var category: AnalyticsType = .event

    var body: some View {
        VStack {
            VStack {
                Form {
                    Section {
                        TextField("Event Label", text: $label)
                        TextField("Extra Info", text: $info)
                        Picker("Event Type", selection: $category) {
                            ForEach(AnalyticsType.allCases) {
                                Text("\($0.rawValue)")
                            }
                        }
                    }
                    Section {
                        HStack {
                            Spacer()
                            Button("Track") {
                                // Log an analytics event
                                AnalyticsManager.shared.logEvent(category, label: label, info: ["extra": info])
                                events.append(EventListEvent(label: label, eventType: category))
                                label = ""
                                info = ""
                                category = .event
                            }
                            .buttonStyle(.bordered)
                            .cornerRadius(4)
                            // Log a click event in SwiftUI
                            .logClick("track_click")
                            Spacer()
                        }
                    }
                }
                Spacer()
                VStack {
                    Text("Current tracked events")
                    // This shows only the events added filling the form and clicking the `Track`button.
                    List(events, id: \.self) { event in
                        HStack {
                            Text(event.label)
                            Spacer()
                            Text(event.eventType.rawValue)
                        }
                    }
                    // Log an event associated to a SwiftUI element appearing
                    .logEvent("list_appear")
                }
            }
        }
        .navigationBarTitle("Track Event View")
        .logScreen("track_event_view")
        // Log a screen appearing in SwiftUI
    }
}
