//
//  CircleImage.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 10/08/2023.
//

import SwiftUI

struct CircleImage: View {
    var image: String

    var body: some View {
        AsyncImage(url: URL(string: image)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(Color.white, lineWidth: 4)
                    }
                    .shadow(radius: 7)
            case .failure(let error):
                Text("Failed to load image: \(error.localizedDescription)")
            case .empty:
                ProgressView()
            @unknown default:
                // Handle any future cases that might be added
                Text("Unknown image loading phase")
            }
        }
        .frame(width: 150, height: 150)
    }
}

/*
 struct CircleImage_Previews: PreviewProvider {
 static var previews: some View {
 CircleImage(image: Image(""))
 }
 }
 */
