//
//  IngredientsView.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 28/08/2023.
//

import SwiftUI

struct IngredientsView: View {
    var ingredients: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("INGREDIENTS")
                .font(.system(.title2))
            ForEach(ingredients, id: \.self) { ingredient in
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 7, weight: .light))
                        .foregroundColor(ColorPalette.darkLilacAccent)
                    Text(ingredient)
                }
            }
        }
        .padding()
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ColorPalette.darkLilacAccent, lineWidth: 1)
        )
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView(ingredients: ["2 teaspoons olive oil", "water"])
    }
}
