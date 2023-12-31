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
