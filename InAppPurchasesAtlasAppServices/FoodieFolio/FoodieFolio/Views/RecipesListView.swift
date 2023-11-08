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
import RealmSwift

struct RecipesListView: View {
    @ObservedResults(Recipe.self) var recipes
    @ObservedResults(Purchase.self) var purchases
    @State private var isPresentingModal = false
    @State private var selectedCategory: String = "general"

    var body: some View {
        TabView {
            NavigationStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Category")
                            .font(.system(size: 20, weight: .semibold))
                        HStack {
                            CapsuleButton(title: "General") {
                                selectedCategory = "general"
                            }
                            if showPremiumButton {
                                CapsuleButton(title: "Premium") {
                                    selectedCategory = "premium"
                                }
                            }
                        }
                        Divider()

                    }.padding()

                    List(filteredRecipes, id: \._id) { recipe in
                        NavigationLink {
                            RecipeDetail(recipe: recipe)
                        } label: {
                            RecipeRow(recipe: recipe)
                        }
                    }
                    .listStyle(.plain)
                    .navigationBarTitle("Recipes")
                    .navigationBarItems(trailing: Button {
                        isPresentingModal.toggle()
                    } label: {
                        Image(systemName: "gift.fill")
                            .foregroundColor(ColorPalette.lightLilac)
                    })
                }
                .sheet(isPresented: $isPresentingModal) {
                    StorePurchaseView()
                }
            }
            .tabItem {
                Label("Recipes", systemImage: "fork.knife")
            }

            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
        .accentColor(ColorPalette.lightLilac)
    }

    var showPremiumButton: Bool {
        return !filteredPurchases.isEmpty
    }

    var filteredRecipes: Results<Recipe> {
        if selectedCategory == "premium" {
            return recipes.where {
                ($0.cuisineType == "japanese")
            }
        } else {
            return recipes.where {
                $0.cuisineType == "american"
            }
        }
    }

    var filteredPurchases: Results<Purchase> {
        return purchases.where {
            $0.userId == realmApp.currentUser?.id
        }
    }
}
