//
//  StorePurchaseView.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 30/08/2023.
//

import SwiftUI
import StoreKit
import RealmSwift

struct StorePurchaseView: View {
    @StateObject var storeKit = StoreKitManager()
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedProduct: Product?
    @State private var isAnyProductBundleSelected = false
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @State private var isProductAlreadyPurchased = false

    var body: some View {
        ZStack(alignment: .top) {
            Image("purchases-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
                .edgesIgnoringSafeArea(.all)
        VStack {
            HStack {
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 25))
                        .padding()
                        .foregroundColor(.white)
                }
            }
            Spacer().frame(height: 55)
            VStack(alignment: .leading) {
                Text("Premium")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                Text("Want to unlock more recipes?")
                    .foregroundColor(.white)

                ForEach(storeKit.storeProducts) { product in
                    HStack {
                        Button {
                            // Toggle the selectedProduct when the button is tapped
                            if selectedProduct == product {
                                selectedProduct = nil
                            } else {
                                selectedProduct = product
                            }

                            isAnyProductBundleSelected = selectedProduct != nil
                        } label: {
                            Image(systemName: selectedProduct == product ? "circle.inset.filled" : "circle")
                                .foregroundColor(ColorPalette.violet)
                        }
                        Text(product.displayName)
                        Spacer()
                        BundleRecipeItem(storeKit: storeKit, product: product, isSelected: selectedProduct == product)
                    }
                    .padding(EdgeInsets(top: 50, leading: 10, bottom: 50, trailing: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(ColorPalette.darkLilacAccent, lineWidth: 1.5)
                            .padding(5)
                    )
                }
            }
            .padding(20)

            Spacer()

            Button {
                if let selectedProduct = selectedProduct {
                    // Perform purchase for the selected product
                    Task {
                        do {
                            isProductAlreadyPurchased = storeKit.isPurchased(selectedProduct)
                            if !isProductAlreadyPurchased {
                                let transactionResult = try await storeKit.purchase(selectedProduct)

                                handleTransactionResult(transactionResult!)
                            } else {
                                isAlertPresented = true
                                alertMessage = "Oops! You've already purchased this product"
                            }

                        } catch {
                            // Handle error if purchase fails
                            print("Purchase failed: \(error)")
                        }
                    }
                }
            } label: {
                Text("Purchase Bundle")
                    .foregroundColor(Color.white)
                    .padding()
                    .background(isAnyProductBundleSelected ? ColorPalette.violet : ColorPalette.darkLilacAccent)
                    .cornerRadius(10)
            }
            .alert(isPresented: $isAlertPresented) {
                            Alert(
                                title: Text("Error"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("OK"))
                            )
            }
            .padding(.bottom)
            .disabled(!isAnyProductBundleSelected) // Disable the button if no circle button is selected
        }
    }
}

struct BundleRecipeItem: View {
    @ObservedObject var storeKit: StoreKitManager
    @State var isPurchased: Bool = false
    var product: Product
    var isSelected: Bool // Indicates whether the product is selected

    var body: some View {
        VStack {
            if isPurchased {
                Text(Image(systemName: "checkmark.circle.fill"))
                    .bold()
                    .padding(10)
                    .allowsHitTesting(false)
            } else {
                Text(product.displayPrice)
                    .padding(10)
            }
        }
        .onChange(of: storeKit.purchasedRecipes) { _ in
            isPurchased = storeKit.isPurchased(product)
        }
        .foregroundColor(isSelected ? ColorPalette.violet : ColorPalette.lightLilac)
        }
    }

    func handleTransactionResult(_ transaction: StoreKit.Transaction) {
        Task {
            if let user = realmApp.currentUser {
                do {
                    let concatenatedString = try await user.functions.addPurchaseReceipt([AnyBSON("\(user.id)"),
                                                                                          AnyBSON("\(transaction)")])
                    print("Called function 'addPurchaseReceipt' and got result: \(concatenatedString)")
                    } catch {
                        // Show alert here
                        isAlertPresented = true
                        alertMessage = error.localizedDescription
                    }
            }
        }
    }
}
