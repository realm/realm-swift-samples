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

/// An enum representing different types of events that can be logged.
public enum AnalyticsType: String, PersistableEnum, CaseIterable, Identifiable {
    /// To be used when tracking a screen view.
    case screenView = "screen_view"
    /// To be used every time the user opens the app.  This is done automatically by `Analytics Manager`.
    case sessionStart = "session_start"
    /// To be used when tracking a click event over a UI element.
    case click = "click"
    /// To be used when tracking login to any service.
    case login = "login"
    /// To be used when tracking any other event.
    case event = "event"

    public var id: Self { self }
}

class AnalyticsEvent: AsymmetricObject {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var session: AnalyticsSession?
    @Persisted var type: AnalyticsType
    @Persisted var label: String
    @Persisted var info: Map<String, String>
    @Persisted var date: Date
}

class AnalyticsSession: EmbeddedObject {
    @Persisted var deviceId: UUID
    @Persisted var startDate: Date
    @Persisted var metadata: AnalyticsMetadataInfo?
}

class AnalyticsMetadataInfo: EmbeddedObject {
    @Persisted var appVersion: String
    @Persisted var platform: String
    @Persisted var platformVersion: String
    @Persisted var location: String
}
