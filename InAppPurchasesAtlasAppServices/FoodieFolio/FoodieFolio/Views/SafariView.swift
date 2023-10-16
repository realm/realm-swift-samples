//
//  SafariView.swift
//  FoodieFolio
//
//  Created by Mar Cabrera on 28/08/2023.
//

import SwiftUI
import SafariServices

struct SafariView: View {
    var url: URL

    var body: some View {
        SafariViewController(url: url)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SafariViewController: UIViewControllerRepresentable {
    var url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        return safariViewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // Update the view controller if needed
        // Not needed in this case
    }
}
