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

struct IngredientsView: View {
    var ingredients: RealmSwift.List<String>

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("INGREDIENTS")
                .font(.system(.title2))
            ForEach(0..<ingredients.count, id: \.self) { index in
                HStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 7, weight: .light))
                        .foregroundColor(ColorPalette.darkLilacAccent)
                    Text(ingredients[index])
                }
            }
        }
        .padding()
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ColorPalette.darkLilacAccent, lineWidth: 1)
        )
    }
}
