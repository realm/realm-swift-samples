//
//  RecipeDetailInfoView.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 11/08/2023.
//

import SwiftUI

struct RecipeDetailInfoView: View {
    let imageName: String
    let text: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
            Text(text)
        }
    }
}

struct RecipeDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailInfoView(imageName: "flame", text: "400 cal")
    }
}
