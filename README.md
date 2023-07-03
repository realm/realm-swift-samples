![Realm]((https://github.com/realm/realm-swift/raw/master/logo.png)

[![License](https://img.shields.io/badge/License-Apache-blue.svg)](LICENSE)

# Realm Swift Samples

This repo contains Swift Samples that demonstrate the usage of [Realm Swift SDK](https://github.com/realm/realm-swift).

Realm Swift documentation can be found [here](https://www.mongodb.com/docs/realm/sdk/swift/) and API reference [here](https://www.mongodb.com/docs/realm-sdks/swift/latest/).

To install Realm Swift SDK you can consult our [Installation documentation](https://www.mongodb.com/docs/realm/sdk/swift/install/) or our [Get Started](https://github.com/realm/realm-swift#getting-started) on our repository.
You may find the [Quick Start - Realm Swift]( https://www.mongodb.com/docs/realm/sdk/swift/quick-start/) helpful if you are using Realm for the first time as well.

To learn more about using Realm with Atlas App Services, refer to the [Atlas Device Sync](https://www.mongodb.com/docs/realm/sdk/swift/sync/) and [connecting to Atlas App Services](https://www.mongodb.com/docs/realm/sdk/swift/app-services/) documentation.

# Samples list
* [`Sync connection state changes, Error handling, and Client reset Sample App`](https://github.com/realm/realm-swift-samples/tree/main/SyncConnectionStateErrorReset) - This project implements a simple example App which showcase the following use cases: 
  * Listening user state changes (logged in, logout, or removed).
  * Listening if the underlying sync session state, is active, inactive or invalid.
  * Listening if the underlying sync session connection state is connecting, connected, disconnected.
  * Listening for sync errors using sync's error handler.
  * Listening for pre and post client resets blocks with `.recoverOrDiscardUnsyncedChanges` mode.
