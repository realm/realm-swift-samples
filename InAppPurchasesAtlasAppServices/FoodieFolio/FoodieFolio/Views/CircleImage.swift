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
