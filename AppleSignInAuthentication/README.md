# Integrating Apple Sign-in with Realm using the Swift SDK: A Step-by-Step Guide

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

* Create an iOS app in Swift using Xcode.
* Integrate RealmSwift framework for database management.
* Implement Apple Sign-In authentication.
* Store user information securely in Realm database.

**Realm Details:**
* RealmSwift v10.34.1

## Version Support

* XCode: 14.3.1
* iOS: 16.0

## Getting Started

### Set up an Atlas App Services App

To use Apple Sign In authentication in Realm, you must first:

1. [Create an App Services App](https://www.mongodb.com/docs/atlas/app-services/manage-apps/create/create-with-ui/)
2. Enable [Apple Sign In Authentication](https://www.mongodb.com/docs/atlas/app-services/authentication/apple/#apple-id-authentication)
3. Add [Apple Sign in with Apple to your app](https://www.mongodb.com/docs/atlas/app-services/authentication/apple/#add-sign-in-with-apple-to-your-app)

### Run the apple-sign-in project (apple-sign-in.xcodeproj)

#### Apple Sign In App

1. Copy your [Atlas App ID](https://www.mongodb.com/docs/atlas/app-services/reference/find-your-project-or-app-id/#std-label-find-your-app-id) from the App Services UI.
2. Paste the copied ID as the value of the existing variable `app` to `AppDelegate`.
3. Run the example on a physical device, or make sure you are logged in with your Apple ID in the simulator.
5. Tap on the Sign in with Apple button that displays on the main view.
6. This will perform an authentication and will login the user in Realm.

