# Integrating In-App Purchases with Atlas App Services using Flexible Sync

This example contains a skeleton app to be used as a reference on how to implement Apple Sign in authentication with Realm using the [Realm Swift SDK](https://www.mongodb.com/docs/atlas/app-services/authentication/apple/#apple-id-authentication).
In this project you will be able to see an example of the following use case
* Use Apple Sign In implementation in order to authenticate users in your Realm database.
    * Log screen view in UIKit.
    * Authenticate users in Realm using the Swift SDK.

## Relevant Files
```
├── AppDelegate.swift
├── LoginViewController.swift                      (Authentication Implementation)
└──  other configuration files...    
```

## Scope

The app addresses the following points:
* Register/Login a Device Sync user using email/password authentication.
* Integrate RealmSwift framework for database management using Flexible Sync.
* Access a already login user in order to display a list of recipes.
* Implement [IAP](https://developer.apple.com/in-app-purchase/) for purchasing premium recipes.
* After the purchase is done, new recipes will get unlocked.
* Log user purchases in Atlas using Atlas App Services to be able to obtain all customer's purchases through Apple's purchase receipts. 

**Realm Details:**
* RealmSwift v10.43.0

## Version Support

* XCode: 15.0
* iOS: 17.0

## Getting Started

### Set up an Atlas App Services App

To use Apple Sign In authentication in Realm, you must first:

1. [Create an App Services App](https://www.mongodb.com/docs/atlas/app-services/manage-apps/create/create-with-ui/)
2. Enable [Email/password](https://www.mongodb.com/docs/atlas/app-services/authentication/email-password/) authentication.
3. [Enable Flexible Sync](https://www.mongodb.com/docs/atlas/app-services/sync/configure/enable-sync/) with **Development Mode** on.
    * When Development Mode is enabled, the schema is added automatically when the 
      app is running.

### Run the foodie-folio project (FoodieFolio.xcodeproj)

#### Foodie Folio app

1. Copy your [Atlas App ID](https://www.mongodb.com/docs/atlas/app-services/reference/find-your-project-or-app-id/#std-label-find-your-app-id) from the App Services UI.
2. Paste the copied ID as the value of the existing variable `appRealm` to `FoodieFolio/Managers/AuthenticationManager.swift`.
3. You can use the `App Services app` directory as an example for fetching the content of the recipes into your Atlas database.
3. Run the example. 
