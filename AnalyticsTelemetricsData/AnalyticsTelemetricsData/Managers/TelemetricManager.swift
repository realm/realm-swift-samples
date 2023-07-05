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

import RealmSwift
import SwiftUI

/**
 `TelemetricManager` wraps all the functionality for tracking data and send .
 */
public class TelemetricManager {
    // Shared
    public static var shared = TelemetricManager()

    private var appId = "<TELEMETRIC_APP_ID>"
    private var apiKey = "<TELEMETRIC_API_KEY>"

    // Event queues
    private var eventQueue: [TelemetricData] = []

    private init() {}

    /**
     Configures your App to be used with this manager, without this step we cannot log any data.
     */
    public func configure() async {
        do {
            try await self.setUpApp()
        } catch {
            print("Telemetric Log Error: \(error)")
        }
    }

    /**
     Logs an event which will dispatched to be synced.

     - parameter label: The label that uniquely identifies you data.
     - parameter info: Extra info you want to add to your event, this info can help to categorise or provide specific
                       info which can be used later for reporting.
     */
    public func logData(_ label: String, info: [String: String]? = nil) {
        let event = TelemetricData()
        event._id = ObjectId.generate()
        event.label = label
        event.location = Locale.current.language.region?.identifier ?? ""
        let map = Map<String, String>()
        info?.forEach { map[$0.key]  = $0.value }
        event.info = map
        event.date = Date()
        do {
            try logData(event)
        } catch {
            print("Analytics Log Error: \(error)")
        }
    }
}

extension TelemetricManager {
    private func setUpApp() async throws {
        let app = App(id: appId)
        let user = try await app.login(credentials: .userAPIKey(apiKey))

        var configuration = user.flexibleSyncConfiguration()
        configuration.objectTypes = [TelemetricData.self]

        // Log any data before Telemetric Setup
        if eventQueue.count > 0 {
            for event in eventQueue {
                try logData(event)
            }
            eventQueue = []
        }
    }

    private func logData(_ data: TelemetricData) throws {
        if let currentUser = App(id: appId).currentUser {
            var configuration = currentUser.flexibleSyncConfiguration()
            configuration.objectTypes = [TelemetricData.self]
            let realm = try Realm(configuration: configuration)
            try realm.write {
                realm.create(TelemetricData.self, value: ["_id": data._id,
                                                          "label": data.label,
                                                          "info": data.info,
                                                          "location": data.location,
                                                          "date": data.date] as [String: Any])
            }
        } else {
            eventQueue.append(data)
        }
    }
}

class TelemetricData: AsymmetricObject {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var label: String
    @Persisted var info: Map<String, String>
    @Persisted var date: Date
    @Persisted var location: String
}
