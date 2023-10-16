//
//  Purchase.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 06/10/2023.
//

import Foundation
import RealmSwift

class Purchase: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId?
    @Persisted var receipt: Purchase_receipt?
    @Persisted var userId: String?
}

class Purchase_receipt: EmbeddedObject {
    @Persisted var bundleId: String?

    @Persisted var deviceVerification: String?

    @Persisted var deviceVerificationNonce: String?

    @Persisted var environment: String?

    @Persisted var inAppOwnershipType: String?

    @Persisted var originalPurchaseDate: Double?

    @Persisted var originalTransactionId: String?

    @Persisted var productId: String?

    @Persisted var purchaseDate: Double?

    @Persisted var quantity: Double?

    @Persisted var signedDate: Double?

    @Persisted var storefront: String?

    @Persisted var storefrontId: String?

    @Persisted var transactionId: String?

    @Persisted var transactionReason: String?

    @Persisted var type: String?
}
