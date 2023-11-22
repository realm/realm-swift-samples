<picture>
     <source srcset="./media/logo-dark.svg" media="(prefers-color-scheme: dark)" alt="realm by MongoDB">
     <img src="./media/logo.svg" alt="realm by MongoDB">
</picture>

[![License](https://img.shields.io/badge/License-Apache-blue.svg)](LICENSE)

# Realm Swift Samples

This repo contains Swift Samples that demonstrate the usage of [Realm Swift SDK](https://github.com/realm/realm-swift).

Realm Swift documentation can be found [here](https://www.mongodb.com/docs/realm/sdk/swift/) and API reference [here](https://www.mongodb.com/docs/realm-sdks/swift/latest/).

To install Realm Swift SDK you can consult our [Installation documentation](https://www.mongodb.com/docs/realm/sdk/swift/install/) or our [Get Started](https://github.com/realm/realm-swift#getting-started) on our repository.
You may find the [Quick Start - Realm Swift]( https://www.mongodb.com/docs/realm/sdk/swift/quick-start/) helpful if you are using Realm for the first time as well.

To learn more about using Realm with Atlas App Services, refer to the [Atlas Device Sync](https://www.mongodb.com/docs/realm/sdk/swift/sync/) and [connecting to Atlas App Services](https://www.mongodb.com/docs/realm/sdk/swift/app-services/) documentation.

# Samples list
* [`Sync connection state changes, Error handling, and Client reset Sample App`](https://github.com/realm/realm-swift-samples/tree/main/SyncConnectionStateErrorReset) - This project implements a simple example App which showcases the following use cases: 
  * Listening for user state changes (logged in, logged out, or removed).
  * Listening if the underlying sync session state, is active, inactive or invalid.
  * Listening if the underlying sync session connection state is connecting, connected, disconnected.
  * Listening for sync errors using sync's error handler.
  * Listening for pre and post client resets blocks with `.recoverOrDiscardUnsyncedChanges` mode.
  
* [`Analytics/Telemetric Data`](https://github.com/realm/realm-swift-samples/tree/main/AnalyticsTelemetricsData) - The app addresses the following points:
  * Use asymmetric sync to be able to send data uni-directionally to MongoDB Atlas.
  * Configure an App to be able to send asymmetric data.
  * Be able to send events/data easily/fast during the app life cycle.
  * Track easily events/screen views/clicks on a SwiftUI context.
  * Model data to be displayable in MongoDB Charts.
  
* [`Offline Login/Realm Access`](https://github.com/realm/realm-swift-samples/tree/main/OfflineLoginRealmAccess) - This simple sample project showcase the following use cases:
  * Register/Login a Device Sync user.
  * Access a already logged user without an internet connection.
  * Opening a Realm with and without and internet connection.
  * Add an initial flexible sync subscription, which executes when opening a 
    realm for the very first time, even if offline.
  * Logging out a Device Sync user and resetting your SwiftUI's associated Realm 
    when doing so.
    
* [`Apple SignIn and Authentication`](https://github.com/realm/realm-swift-samples/tree/main/AppleSignInAuthentications) - This simple sample project showcase the following example:
  * Use Apple Sign In implementation in order to authenticate users in Realm/Device-Sync.
    * Log screen view in UIKit.
    * Authenticate users in Realm/Device-Sync using the RealmSwift SDK.
    
* [`Integrating In-App Purchases with Atlas App Services using Flexible Sync`](https://github.com/realm/realm-swift-samples/tree/main/InAppPurchasesAtlasAppServices) 
    * The scope of this app aims to demonstrate the effortless integration between Realm Device Sync, 
      offering efficient data management and synchronization, and StoreKit for handling in-app purchases. 
      The goal is to achieve a robust implementation that enables users to buy recipes stored in a Realm Database. 
      After confirming the purchase through StoreKit, users can unlock premium content recipes and conveniently 
      store purchase receipts on a separate collection for easy access on the developer's side in Atlas.
    * In this project you will be able to see an example of the following use case:
        * Authenticate users using the Swift SDK.
        * Fetch data into your app using Flexible Sync.
        * Purchase non-consumable products.
        * Fetch all receipts from purchases and view them on Atlas.
