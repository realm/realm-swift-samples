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

struct TelemetricView: View {
    var body: some View {
        TrackDataView()
            .onAppear {
                Task {
                    await TelemetricManager.shared.configure()
                }
            }
    }
}

enum Sensor: String, CaseIterable, Identifiable {
    case sensor1
    case sensor2
    case sensor3
    case sensor4

    public var id: Self { self }
}
struct TrackDataView: View {
    @State var sensor: Sensor = .sensor1
    @State var temperature: Int = 0
    @State var isCelsius: Bool = false

    var body: some View {
        VStack {
            VStack {

                Form {
                    Section {
                        Picker("Sensor", selection: $sensor) {
                            ForEach(Sensor.allCases) {
                                Text("\($0.rawValue)")
                            }
                        }
                        if isCelsius {
                            Picker("Temperature", selection: $temperature) {
                                ForEach(0..<50) {
                                    Text("\($0) ºC")
                                }
                            }
                        } else {
                            Picker("Temperature", selection: $temperature) {
                                ForEach(32..<122) {
                                    Text("\($0) ºF")
                                }
                            }
                        }
                        Toggle("ºF/ºC", isOn: $isCelsius)
                    }
                    Section {
                        HStack {
                            Spacer()
                            Button("Track Temperature") {
                                // Log an analytics event
                                TelemetricManager.shared.logData(sensor.rawValue,
                                                                 info: ["temperature": "\(temperature)"])
                            }
                            .buttonStyle(.bordered)
                            .cornerRadius(4)
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Telemetric Data View")
    }

    func resetData() {
        sensor = .sensor1
        temperature = 0
    }
}
