//
//  LoginFormCard.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 14/09/2023.
//

import SwiftUI
import RealmSwift

struct LoginFormCard: View {
    // MARK: - Properties
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isAlertPresented = false
    @State private var alertMessage = ""
    @Binding var isLoginSuccessful: Bool

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Email")
                .headerStyle()

            TextField("Email", text: $email)
                .textFieldStyle()

            Text("Password")
                .headerStyle()

            SecureField("Password", text: $password)
                .padding(.all)
                .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(.white, style: StrokeStyle(lineWidth: 1.0)))
                .foregroundColor(.white)

            Button {
                Task {
                    await handleAuth(.login)
                }
            } label: {
                Text("Sign in")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(ColorPalette.violet)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $isAlertPresented) {
                            Alert(
                                title: Text("Login Error"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("OK"))
                            )
            }

            Button {
                Task {
                    await handleAuth(.register)
                }
            } label: {
                Text("Create Account")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(ColorPalette.violet)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $isAlertPresented) {
                            Alert(
                                title: Text("Login Error"),
                                message: Text(alertMessage),
                                dismissButton: .default(Text("OK"))
                            )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(Color.gray.opacity(0.8))
        .cornerRadius(10)
        .padding()
    }

    enum AuthAction {
        case login
        case register
    }

    // Function to handle login and registration and avoid code duplicity
    private func handleAuth(_ action: AuthAction) async {
        do {
            var result: Result<User, Error>

            switch action {
            case .login:
                result = await AuthenticationManager.shared.loginUser(email: email, password: password)
            case .register:
                result = await AuthenticationManager.shared.registerUser(email: email, password: password)
            }

            switch result {
            case .success:
                isLoginSuccessful = true
            case .failure(let error):
                alertMessage = error.localizedDescription
                isAlertPresented = true
            }
        }
    }
}
