//
//  Text+Extension.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 14/09/2023.
//

import SwiftUI

extension Text {
    func headerStyle() -> some View {
        self
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
    }
}
