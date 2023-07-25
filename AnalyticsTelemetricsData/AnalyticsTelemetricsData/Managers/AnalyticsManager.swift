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
import AppTrackingTransparency
import AdSupport

/**
 `RealmAnalytics` wraps all the functionality for logging data..
 */
@available(macOS 11.0, tvOS 14.0, iOS 14.0, *)
public class AnalyticsManager {
    // Shared
    public static var shared = AnalyticsManager()

    private var appId = "<ANALYTICS_APP_ID>"
    private var apiKey = "<ANALYTICS_API_KEY>"

    // Event queues
    private var eventQueue: [AnalyticsEvent] = []

    private var currentSession: AnalyticsSession?

    private init() {}

    /**
     Configures your App to be used with this manager. Without this step we cannot log any events.
     */
    public func configure() async throws {
        try await self.setUpApp()
    }

    /**
     Logs an event which will be synced to Atlas.

     - parameter type: The event type `AnalyticsType` you want to track.
     - parameter label: The label that uniquely identifies your event. This could be the name of the screen or
                        the name of the event you want to track.
     - parameter info: Extra info you want to add to your event. This info can help to categorize or provide specific
                       info which can be used later for reporting.
     */
    public func logEvent(_ type: AnalyticsType, label: String, info: [String: String]? = nil) {
        let event = AnalyticsEvent()
        event._id = ObjectId.generate()
        event.type = type
        event.label = label
        let map = Map<String, String>()
        info?.forEach { map[$0.key]  = $0.value }
        event.info = map
        event.date = Date()
        do {
            try logEvent(event)
        } catch {
            print("Analytics Log Error: \(error)")
        }
    }
}

enum AnalyticsError: Error {
    case trackingDisabled
}

extension AnalyticsManager {
    private func setUpApp() async throws {
        let app = App(id: appId)
        let user = try await app.login(credentials: .userAPIKey(apiKey))

        guard let identifier = await requestDeviceUniqueId() else {
            throw AnalyticsError.trackingDisabled
        }

        var configuration = user.flexibleSyncConfiguration()
        configuration.objectTypes = [AnalyticsEvent.self,
                                     AnalyticsSession.self,
                                     AnalyticsMetadataInfo.self]
        try initSession(identifier)

        // Log any events before Analytics Setup
        if eventQueue.count > 0 {
            for event in eventQueue {
                try logEvent(event)
            }
            eventQueue = []
        }
    }

    private func initSession(_ identifier: UUID) throws {
        let session = AnalyticsSession()
        session.startDate = Date()
        session.deviceId = identifier

        let metadata = AnalyticsMetadataInfo()
        metadata.platformVersion = getPlatformVersion()
        metadata.platform = getPlatform()
        metadata.location = Locale.current.language.region?.identifier ?? ""
        metadata.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        session.metadata = metadata
        self.currentSession = session
        logEvent(.sessionStart, label: "session_start")
    }

    private func logEvent(_ event: AnalyticsEvent) throws {
        if let currentUser = App(id: appId).currentUser,
           let session = currentSession {
            var configuration = currentUser.flexibleSyncConfiguration()
            configuration.objectTypes = [AnalyticsEvent.self,
                                         AnalyticsSession.self,
                                         AnalyticsMetadataInfo.self]
            let realm = try Realm(configuration: configuration)
            try realm.write {
                realm.create(AnalyticsEvent.self, value: ["_id": event._id,
                                                          "session": session,
                                                          "type": event.type,
                                                          "label": event.label,
                                                          "info": event.info,
                                                          "date": event.date] as [String: Any])
            }
        } else {
            eventQueue.append(event)
        }
    }

    // Device Information
    private func requestDeviceUniqueId() async -> UUID? {
        // To be able to access the device unique identifier you need to authorize the App
        // Check https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager
        // for more info.
        let status = await ATTrackingManager.requestTrackingAuthorization()
        switch status {
        case .authorized:
            print("Authorized")
            // `advertisingIdentifier` is a unique identifier specific to the users device.
            // Check https://developer.apple.com/documentation/adsupport/asidentifiermanager
            // for more info.
            return ASIdentifierManager.shared().advertisingIdentifier
        default:
            print("Unknown")
            return nil
        }
    }

    // Device Information
    private func getPlatform() -> String {
        let platform: String
#if os(watchOS)
        platform = "watchos"
#elseif os(iOS)
        platform = "iphone"
#elseif os(tvOS)
        platform = "tvos"
#else
        platform = "macos"
#endif
        return platform
    }

    // Device Information
    private func getPlatformVersion() -> String {
        return ProcessInfo.processInfo.operatingSystemVersionString
    }
}

// Swift UI Helpers
struct AnalyticsClickEvent: ViewModifier {
    var label: String
    var info: [String: String]?

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
    func body(content: Content) -> some View {
        content
            .buttonStyle(ClickButtonStyle(label: label, info: info))
    }
}

struct ClickButtonStyle: ButtonStyle {
    var label: String
    var info: [String: String]?
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1)  // << press effect
            .onChange(of: configuration.isPressed) { _ in
                AnalyticsManager.shared.logEvent(.click, label: label, info: info)
            }
    }
}

struct AnalyticsScreenView: ViewModifier {
    var label: String
    var info: [String: String]?

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
    func body(content: Content) -> some View {
        content
            .onAppear {
                AnalyticsManager.shared.logEvent(.screenView, label: label, info: info)
            }
    }
}

struct AnalyticsScreenEvent: ViewModifier {
    var label: String
    var info: [String: String]?

    @available(iOS 14.0, macOS 11.0, tvOS 14.0, *)
    func body(content: Content) -> some View {
        content
            .onAppear {
                AnalyticsManager.shared.logEvent(.event, label: label, info: info)
            }
    }
}

/// Helpers for logging events from SwiftUI.
extension View {
    /**
     Append this to your `Button` view to log a click event when the button is clicked.

     - parameter label: The label that uniquely identifies your click action.
     - parameter info: Extra info you want to add to your event. This info can help to categorize or provide specific
                       info which can be used later for reporting.
     */
    public func logClick(_ label: String, info: [String: String]? = nil) -> some View {
        modifier(AnalyticsClickEvent(label: label, info: info))
    }

    /**
     Append this to your view to log a screen view.

     - parameter label: The label that uniquely identifies your screen view.
     - parameter info: Extra info you want to add to your event. This info can help to categorize or provide specific
                       info which can be used later for reporting.
     */
    public func logScreen(_ label: String, info: [String: String]? = nil) -> some View {
        modifier(AnalyticsScreenView(label: label, info: info))
    }

    /**
     Append this to any view to log an event when this view appears.

     - parameter label: The label that uniquely identifies your event.
     - parameter info: Extra info you want to add to your event. This info can help to categorize or provide specific
                       info which can be used later for reporting.
     */
    public func logEvent(_ label: String, info: [String: String]? = nil) -> some View {
        modifier(AnalyticsScreenEvent(label: label, info: info))
    }
}
