# Integrating In-App Purchases with Atlas App Services using Flexible Sync

This example contains a skeleton app to be used as a reference on how to In App Purchase with a seamless integration in App Services using the [Swift SDK](https://www.mongodb.com/docs/realm/sdk/swift/#realm-swift-sdk).

The scope of this app aims to demonstrate the effortless integration between Realm Device Sync, offering efficient data management and synchronization, and StoreKit for handling in-app purchases. The goal is to achieve a robust implementation that enables users to buy recipes stored in a Realm Database. After confirming the purchase through StoreKit, users can unlock premium content recipes and conveniently store purchase receipts on a separate collection for easy access on the developer's side in Atlas.

In this project you will be able to see an example of the following use case:
* Authenticate users using the Swift SDK.
* Fetch data into your app using Flexible Sync.
* Purchase non-consumable products.
* Fetch all receipts from purchases and view them on Atlas.

## Relevant Files
```
├── FoodieFolio
│   ├── Managers                                (Managers for Atlas App)
│   │   ├── RealmManager.swift                  (Manager for Realm functionality)
│   │   ├── StoreKitManager.swift               (Manager for StoreKit Functionality)
│   │   ├── AuthenticationManager.swift         (Manager for handling Realm Authentication)
│   ├── Views                                   (Apps Views)
│   │   ├── RecipesListView.swift               (Main App View)
│   │   ├── RecipeDetail.swift                  (Recipe Detail View)
│   │   ├── StorePurchaseView.swift             (Main IAP View to purchase premium recipes)
│   │   ├── LoginView.swift                     (Authentication View - App Entry)
│   │   └── other views/components
├── App Services app                            (App Services Backend app)
│   ├── realm_config.json                       (App Services configuration)
│   ├── triggers                                (Triggers for data fetching)
│   ├── functions                               (Linked functions to triggers)
│   └── data_sources
└──  other configuration/helper files...
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
* RealmSwift v10.44.0

## Version Support

* XCode: 15.0
* iOS: 17.0

## Getting Started

### Set up an Atlas App Services App

To use Email/Password Authentication in App Services, you must first:

1. [Create an App Services App](https://www.mongodb.com/docs/atlas/app-services/manage-apps/create/create-with-ui/)
2. Enable [Email/password](https://www.mongodb.com/docs/atlas/app-services/authentication/email-password/) authentication.
3. [Enable Flexible Sync](https://www.mongodb.com/docs/atlas/app-services/sync/configure/enable-sync/) with **Development Mode** on.
    * When Development Mode is enabled, the schema is added automatically when the 
      app is running.

### Run the foodie-folio project (FoodieFolio.xcodeproj)

#### Foodie Folio app

1. Copy your [Atlas App ID](https://www.mongodb.com/docs/atlas/app-services/reference/find-your-project-or-app-id/#std-label-find-your-app-id) from the App Services UI.
2. Paste the copied ID as the value of the existing variable `appRealm` to `FoodieFolio/Managers/AuthenticationManager.swift`.
3. You can use the `App Services app` directory as an example for fetching the content of the recipes into your Atlas database. As an alternative, you can use this app and import it to your own App Services app doing the following:
3.1. Create an App Services app following the steps provided in the above section.
3.2. Rename the main directory from `App Services app` to the name of the app that you have created in App Services.
3.3. Modify the parameters `clusterName`, `app_id` and `name` from the config files within the directory so it matches your own. 
3.4. Import the app using the command `app services push --remote="your_app_id"` from the [App Services CLI](https://www.mongodb.com/docs/atlas/app-services/cli/#installation)
4. Run the example.
