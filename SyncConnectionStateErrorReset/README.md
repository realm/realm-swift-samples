# Sync Connection State changes/Error handling/Client reset App for RealmSwift

A skeleton app to be used as a reference for how to use the [Realm Swift SDK](https://www.mongodb.com/docs/realm/sdk/swift/).
On the following project you see an example of the following use cases
* Connection state changes.
* User state changes.
* Sync error handling.
* Client reset.

## Relevant Files

```
├── SyncConnectionStateErrorReset
│   ├── Managers                                (Managers)
│   │   ├── AppManager.swift                    (Manager for App Auth)
│   │   ├── RealmManager.swift                  (Manager for Realm)
│   ├── Models                                  (Includes all Realm models)
│   │   ├── Models.swift
│   ├── SyncConnectionStateErrorResetApp.swift  (App Entry)
│   ├── SyncConnectionStateErrorResetView.swift (Example Views)
└── other configuration files..
```

## Example use cases

This project implements a simple example App which showcases the following use cases:
* Listening for user state changes (logged in, logged out, or removed).
* Listening if the underlying sync session state, is active, inactive or invalid.
* Listening if the underlying sync session connection state is connecting, connected, disconnected.
* Listening for sync errors using sync's error handler.
* Listening for pre and post client resets blocks with `.recoverOrDiscardUnsyncedChanges` mode.

* This App also includes best practices to implement a Login/Register flow, handle the 
  sync connection (error handler, connection state, session state, user state), handle
  sync and client reset and adds initial/update sync subscriptions to a flexible 
  sync realm for a SwiftUI App.
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
2. Enable [Email/Password Authentication](https://www.mongodb.com/docs/atlas/app-services/authentication/email-password/#std-label-email-password-authentication)
3. [Enable Flexible Sync](https://www.mongodb.com/docs/atlas/app-services/sync/configure/enable-sync/) with **Development Mode** on.
    * When Development Mode is enabled, queryable fields will be added automatically.
    * Queryable fields used in this app: `_id`, `storeId`, `userId`.

After running the client and seeing the available collections in Atlas, [set read/write permissions](https://www.mongodb.com/docs/atlas/app-services/rules/roles/#with-device-sync) for all collections.

### Run the SyncConnectionStateErrorReset project (SyncConnectionStateErrorReset.xcodeproj)

1. Copy your [Atlas App ID](https://www.mongodb.com/docs/atlas/app-services/reference/find-your-project-or-app-id/#std-label-find-your-app-id) from the App Services UI.
2. Paste the copied ID as the value of the existing variable `ATLAS_APP_ID` in `SyncConnectionStateErrorReset/Managers/AppManager.swift`:
3. Run the example.
