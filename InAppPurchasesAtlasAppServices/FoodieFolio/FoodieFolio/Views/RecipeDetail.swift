////////////////////////////////////////////////////////////////////////////
//
// Copyright 2023 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

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

                IngredientsView(ingredients: recipe.ingredientLines)
                    .padding(.bottom, 20)

                ReadRecipeButton(recipeURL: URL(string: recipe.url ?? ""))
            }
            .padding(15)
        }
    }
}
