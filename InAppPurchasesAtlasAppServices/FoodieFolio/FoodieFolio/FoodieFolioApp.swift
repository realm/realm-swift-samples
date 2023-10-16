//
//  FoodieFolioApp.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 08/08/2023.
//

import SwiftUI

@main
struct FoodieFolioApp: App {

    var body: some Scene {
        WindowGroup {
            VStack {
                ContentView(app: realmApp)
            }
        }
    }
}
