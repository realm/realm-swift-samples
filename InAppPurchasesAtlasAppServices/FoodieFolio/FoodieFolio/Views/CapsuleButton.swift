//
//  CapsuleButton.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 05/10/2023.
//

import SwiftUI

struct CapsuleButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title.capitalizedWord)
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .foregroundColor(.white)
                .background(
                    Capsule()
                        .foregroundColor(ColorPalette.darkLilacAccent)
                )
        }
    }
}
