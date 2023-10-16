//
//  RecipesListView.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 09/08/2023.
//

import SwiftUI
import RealmSwift

struct RecipesListView: View {
    @ObservedResults(Recipe.self) var recipes: Results<Recipe>
    @ObservedResults(Purchase.self) var purchases: Results<Purchase>
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
                    .sheet(isPresented: $isPresentingModal) {
                        StorePurchaseView()
                    }
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

    var hasPurchases: Bool {
        return !filteredPurchases.isEmpty
    }
}
