//
//  LoginView.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 11/09/2023.
//

import SwiftUI
import RealmSwift

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @State var isLoginSuccessful = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("purchases-background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    ZStack {
                        // Background View
                        ColorPalette.violet
                            .opacity(0.8)
                            .cornerRadius(20)
                            .padding(10)

                        Image("foodie-icon")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                            .padding(10)
                    }
                    .frame(width: 100, height: 100)

                    Text("Foodie Folio")
                        .font(.system(size: 20, weight: .bold))
                    LoginFormCard(isLoginSuccessful: $isLoginSuccessful)
                }
            }
            .navigationDestination(isPresented: $isLoginSuccessful) {
                RecipesListView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
