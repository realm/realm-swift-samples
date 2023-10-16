//
//  CuisineView.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 28/08/2023.
//

import SwiftUI

struct CuisineView: View {
    var cuisineType: String
    var calories: String

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                RecipeDetailInfoView(imageName: "fork.knife", text: cuisineType.capitalizedWord)

                RecipeDetailInfoView(imageName: "flame", text: "\(calories) cal")
            }
            .padding(.bottom, 20)
        }
    }
}

struct CuisineView_Previews: PreviewProvider {
    static var previews: some View {
        CuisineView(cuisineType: "American", calories: "520 cal")
    }
}
