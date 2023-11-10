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

class Purchase: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId?
    @Persisted var receipt: PurchaseReceipt?
    @Persisted var userId: String?
}

class PurchaseReceipt: EmbeddedObject {
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
