# Analytics/Telemetrics for RealmSwift

A skeleton app to be used as a reference for how to use the [Realm Swift SDK](https://www.mongodb.com/docs/realm/sdk/swift/).
On the following project you see an example of the following use cases
* Use asymmetric sync to track analytics events.
    * Log any event on an App life cycle.
    * Log screen views in SwiftUI.
    * Log button clicks in SwiftUI.
    * Log views appearing events in SwiftUI.
* Use asymmetric sync to send telemetric data.
* Use Atlas charts to display/showcase the synced data.

## Relevant Files

```
├── AnalyticsTelemetricsData
│   ├── Managers                                (Managers for Atlas App)
│   │   ├── AnalyticsManager.swift              (Manager to track analytics events)
│   │   ├── TelemetricManager.swift             (Manager to track telemetric data)
│   ├── Views                                   (Apps Views)
│   │   ├── AnalyticsView.swift                 (Analytics sample View)
│   │   ├── TelemetricVIew.swift                (Telemetric data sample view)
│   ├── AnalyticsTelemetricsDataApp.swift       (App Entry)
│   ├── AnalyticsTelemetricsDataView.swift      (Example Views)
└── other configuration files..
```

## Scope

The app addresses the following points:
* Use asymmetric sync to be able to send data uni-directionally to MongoDB Atlas.
* Configure an App to be able to send asymmetric data.
* Be able to send events/data easily/fast during the app life cycle.
* Track easily events/screen views/clicks on a SwiftUI context.
* Model data to be displayable in MongoDB Charts.

* Setting the default logger to `.all`, showing all the sync and realm access logs.

**Realm Details:**
* RealmSwift v10.41.0
* Device Sync type: Flexible

## Version Support

* XCode: 14.3.1
* iOS: 16.0

## Getting Started

### Set up an Atlas App Services App

To sync Realm data you must first:

1. [Create an App Services App](https://www.mongodb.com/docs/atlas/app-services/manage-apps/create/create-with-ui/)
2. Enable [ApiKey](https://www.mongodb.com/docs/atlas/app-services/authentication/api-key/)
3. [Enable Flexible Sync](https://www.mongodb.com/docs/atlas/app-services/sync/configure/enable-sync/) with **Development Mode** on.
    * When Development Mode is enabled, schema will be added automatically when the 
      app is running.

After running the client and seeing the available collections in Atlas, [set read/write permissions](https://www.mongodb.com/docs/atlas/app-services/rules/roles/#with-device-sync) for all collections.

### Run the AnalyticsTelemetricsData project (AnalyticsTelemetricsData.xcodeproj)

#### Analytics Example App

1. Copy your [Atlas App ID](https://www.mongodb.com/docs/atlas/app-services/reference/find-your-project-or-app-id/#std-label-find-your-app-id) from the App Services UI.
2. Paste the copied ID as the value of the existing variable `ATLAS_APP_ID` to `AnalyticsManager`.
3. Get the `APIKey` from the App Services UI and paste it into `ANALYTICS_API_KEY` on `AnalyticsManager`.
4. Run the example.
5. Choose the Analytics Example on the initial view.
6. Build a [Atlas Charts](https://www.mongodb.com/docs/charts/), this 
   [charts template] (https://charts.mongodb.com/charts-test-project-lcynv/public/dashboards/04e0c200-5002-4d21-b9d1-f2cc34e5f01a) 
   can be used as a template.
   
#### Telemetric Example App

1. Copy your [Atlas App ID](https://www.mongodb.com/docs/atlas/app-services/reference/find-your-project-or-app-id/#std-label-find-your-app-id) from the App Services UI.
2. Paste the copied ID as the value of the existing variable `ATLAS_APP_ID` to `TelemetricManager`.
3. Get the `APIKey` from the App Services UI and paste it into `ANALYTICS_API_KEY` on `TelemetricManager`.
4. Run the example.
5. Choose the Telemetric Example on the initial view.
5. Build a [Atlas Charts](https://www.mongodb.com/docs/charts/), this 
   [charts template] (https://charts.mongodb.com/charts-test-project-lcynv/public/dashboards/64a49b6e-ff17-45a4-8c5b-8aa39e5ac1cd) 
   can be used as a template.

