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

import Foundation
import RealmSwift

class Recipe: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId?

    @Persisted var calories: Double?

    @Persisted var cautions: List<String>

    @Persisted var cuisineType: List<String>

    @Persisted var dietLabels: List<String>

    @Persisted var dishType: List<String>

    @Persisted var healthLabels: List<String>

    @Persisted var image: String?

    @Persisted var ingredientLines: List<String>

    @Persisted var ingredients: List<RecipeIngredients>

    @Persisted var label: String?

    @Persisted var mealType: List<String>

    @Persisted var shareAs: String?

    @Persisted var source: String?

    @Persisted var totalCO2Emissions: Double?

    @Persisted var totalTime: Double?

    @Persisted var totalWeight: Double?

    @Persisted var uri: String?

    @Persisted var url: String?

    @Persisted var yield: Double?
}

class RecipeIngredients: EmbeddedObject {
    @Persisted var food: String?

    @Persisted var foodCategory: String?

    @Persisted var foodId: String?

    @Persisted var image: String?

    @Persisted var measure: String?

    @Persisted var quantity: Double?

    @Persisted var text: String?

    @Persisted var weight: Double?
}
