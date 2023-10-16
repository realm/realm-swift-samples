//
//  ContentView.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 08/08/2023.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedObject var realmManager = RealmManager()
    @ObservedObject var app: RealmSwift.App

    var body: some View {
        switch app.currentUser?.state {
        case .loggedIn:
            if let user = app.currentUser {
                if let realm = realmManager.realm {
                    RecipesListView()
                        .environment(\.realmConfiguration, realm.configuration)
                } else {
                    ProgressView()
                        .onAppear {
                            Task {
                                do {
                                    try await realmManager.initializeRealm(user: user)
                                } catch {
                                    print("Error while opening realm \(error)")
                                }
                            }
                        }
                }
            }
        case .loggedOut, .removed, .none:
            LoginView()
                .onAppear {
                    realmManager.reset()
                }
        default:
            EmptyView()
        }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
