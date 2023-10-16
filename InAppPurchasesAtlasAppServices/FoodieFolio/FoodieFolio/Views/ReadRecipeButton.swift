//
//  ReadRecipeButton.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 28/08/2023.
//

import SwiftUI

struct ReadRecipeButton: View {
    var recipeURL: URL?
    @State private var showSafariView = false

    var body: some View {
        Button(action: {
            showSafariView.toggle()
        }) {
            Text("Read Recipe")
                .font(.system(.body, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(ColorPalette.darkLilacAccent)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $showSafariView) {
            if let recipeURL = recipeURL {
                SafariView(url: recipeURL)
            }
        }
    }
}
