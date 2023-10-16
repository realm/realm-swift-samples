//
//  RecipeDetail.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 10/08/2023.
//

import SwiftUI

struct RecipeDetail: View {
    var recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                CircleImage(image: recipe.image ?? "")
                    .padding(.top, 20)

                Text(recipe.label ?? "Name not available")
                    .font(.title)
                    .padding(.bottom, 10)

                let cuisineType = recipe.cuisineType.first ?? "Unspecified"
                let calories = recipe.calories?.roundedUpToString() ?? "0 cal"
                CuisineView(cuisineType: cuisineType.capitalizedWord, calories: calories)

                IngredientsView(ingredients: Array(recipe.ingredientLines))
                    .padding(.bottom, 20)

                ReadRecipeButton(recipeURL: URL(string: recipe.url ?? ""))
            }
            .padding(15)
        }
    }
}
