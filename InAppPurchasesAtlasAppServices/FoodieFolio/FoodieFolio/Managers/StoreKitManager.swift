//
//  StoreKitManager.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 31/08/2023.
//

import Foundation
import StoreKit

/// `StoreKitManager` is responsible for managing in-app purchases and product information.
///  NOTE:
class StoreKitManager: ObservableObject {
    /// An array of published products available for purchase.
    @Published var storeProducts: [Product] = []

    /// An array of published products that have been purchased.
    @Published var purchasedRecipes: [Product] = []

    /// A dictionary to map product identifiers to localized names.
    private let productDict: [String: String]

    var updateListenerTask: Task<Void, Error>?

    /// Initializes the `StoreKitManager` instance.
    init() {
        // Initialize productDict using property list data, or set to empty if not available
        if let plistPath = Bundle.main.path(forResource: "PropertyList", ofType: "plist"),
           let plist = FileManager.default.contents(atPath: plistPath),
           let plistDict = try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String] {
            productDict = plistDict
        } else {
            productDict = [:]
        }

        updateListenerTask = transactionListener()

        // Fetch products asynchronously when the StoreKitManager is initialized
        Task {
            await requestProducts()

            await updateCustomerProductStatus()
        }
    }

    // If user quits app for example, stop listening for transactions
    deinit {
        updateListenerTask?.cancel()
    }

    func transactionListener() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through any transactions that don't come from a direct call to purchase() method
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    // transaction is verified, so the content unlocks for the user
                    await self.updateCustomerProductStatus()

                    // The transaction always needs to be finished
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }

    /// Fetches available products asynchronously and updates `storeProducts`.
    @MainActor
    func requestProducts() async {
        do {
            // Fetch products using productDict values (IDs)
            storeProducts = try await Product.products(for: productDict.values)
        } catch {
            // Handle errors if product fetching fails
            print("Failed - error retrieving products \(error)")
        }
    }

    /// Call product purchase and returns an optional transaction
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verificationResult):
            // Transaction will be verified for automatically using JWT
            let transaction = try checkVerified(verificationResult)

            await updateCustomerProductStatus()

            await transaction.finish()

            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check if JWS passes the StoreKit verification
        switch result {
        case .unverified:
            // failed verification
            throw StoreError.failedVerification
        case .verified(let signedType):
            // Result is verified, return the unwrapped value
            return signedType
        }
    }

    @MainActor
    func updateCustomerProductStatus() async {
        var purchaseRecipes: [Product] = []

        // iterate through all the user's purcahsed products
        for await result in Transaction.currentEntitlements {
            do {
                // check if transaction is verified
                let transaction = try checkVerified(result)
                // since there is only one type of product (non-consumable), 
                // check if any storeProducs matches the productID and add it to the purchased recipes
                if let recipeBundle = storeProducts.first(where: { $0.id == transaction.productID}) {
                    purchaseRecipes.append(recipeBundle)
                }
            } catch {
                // StoreKit has a failed verification transaction, therefore don't open content to the user
                print("Transaction failed verification process")
            }

            // Assign the purchased products
            self.purchasedRecipes = purchaseRecipes
        }
    }

    /**
     Checks if a product has already been purchased
     */
    func isPurchased(_ product: Product) -> Bool {
        return purchasedRecipes.contains(product)
    }
}

public enum StoreError: Error {
    case failedVerification
}
