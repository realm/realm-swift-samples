//
//  RecipeRow.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 10/08/2023.
//

import SwiftUI

struct RecipeRow: View {
    var recipe: Recipe

    var body: some View {
        HStack(spacing: 10) {
            AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.label ?? "Name not available")

                if let mealType = recipe.mealType.first {
                    Text(mealType.capitalizedWord)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                                .foregroundColor(ColorPalette.lightLilac)
                        )
                }
            }
        }
    }
}
