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

struct LoginView: View {
    @State private var isAlertPresented = false
    @State var isLoginSuccessful = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("purchases-background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    ZStack {
                        ColorPalette.violet
                            .opacity(0.8)
                            .cornerRadius(20)
                            .padding(10)

                        Image("foodie-icon")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(20)
                            .padding(10)
                    }
                    .frame(width: 100, height: 100)

                    Text("Foodie Folio")
                        .font(.system(size: 20, weight: .bold))
                    LoginFormCard(isLoginSuccessful: $isLoginSuccessful)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
