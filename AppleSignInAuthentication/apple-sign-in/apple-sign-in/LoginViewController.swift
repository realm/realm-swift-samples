//
//  LoginViewController.swift
//  apple-sign-in
//
//  Created by Mar Cabrera on 20/01/2023.
//

import UIKit
import AuthenticationServices
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var appleSignInButton: ASAuthorizationAppleIDButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppleSignInButton()
    }

    // Function that creates an Apple Sign In button and is of type ASAuthorizationAppleIDButton
    private func setupAppleSignInButton() {
        appleSignInButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        appleSignInButton.cornerRadius = 10
    }

    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    // Delegate that handles successful Sign In
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            guard let identityToken = appleIDCredential.identityToken else {
                return
            }

            let decodedToken = String(decoding: identityToken, as: UTF8.self)

            print(decodedToken)

            /*
             Note: If the user decides to hide their email on authentication,
             full name will return an empty string and email will be nil
             This is due to Apple's privacy settings, it the developer wants to interact with the user's email,
             it needs to be done through Apple's private email relay service
             https://developer.apple.com/documentation/sign_in_with_apple/sign_in_with_apple_js/communicating_using_the_private_email_relay_service
             */

            // Retrieve AppleID token so I can send it to Realm and authenticate myself
            realmSignIn(appleToken: decodedToken)
        }
    }

    // Delegate function that handles authentication error on Apple Sign In
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Oops! There was an error")
        // Display alert for error
    }

    private func realmSignIn(appleToken: String) {
        let credentials = Credentials.apple(idToken: appleToken)

        app.login(credentials: credentials) { (result) in
            switch result {
            case .failure(let error):
                print("Realm Login failed: \(error.localizedDescription)")
            case .success(let realm):
                DispatchQueue.main.async {
                    print("Successful Login for realm \(realm)")
                    self.performSegue(withIdentifier: "goToWelcomeViewController", sender: nil)
                }
            }
        }
    }
}
