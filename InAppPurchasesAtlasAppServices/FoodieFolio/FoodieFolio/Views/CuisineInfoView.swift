//
//  CuisineInfoView.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 28/08/2023.
//

import SwiftUI

struct CuisineInfoView: View {
  var cuisineType: String
  var calories: String

    var body: some View {
        HStack(spacing: 20) {
       //     let cuisineType = recipe.cuisineType.first ?? "Unspecified"
            RecipeDetailInfoView(imageName: "fork.knife", text: cuisineType.capitalizedWord)
                .foregroundColor(.gray) // Set the tint color to gray

       //     let calories = recipe.calories?.roundedUpToString() ?? "0 cal"
            RecipeDetailInfoView(imageName: "flame", text: "\(calories) cal")
                .foregroundColor(.gray) // Set the tint color to gray
        }
        .padding(.bottom, 20)
    }
}

struct CuisineInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CuisineInfoView(cuisineType: "American", calories: "500 cal")
    }
}
