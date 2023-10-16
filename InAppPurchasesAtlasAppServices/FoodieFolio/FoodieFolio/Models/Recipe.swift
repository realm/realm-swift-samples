//
//  Recipe.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 09/08/2023.
//

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

    @Persisted var ingredients: List<Recipe_ingredients>

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

class Recipe_ingredients: EmbeddedObject {
    @Persisted var food: String?

    @Persisted var foodCategory: String?

    @Persisted var foodId: String?

    @Persisted var image: String?

    @Persisted var measure: String?

    @Persisted var quantity: Double?

    @Persisted var text: String?

    @Persisted var weight: Double?
}
