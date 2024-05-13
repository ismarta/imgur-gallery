//
//  LoginView.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: InitialViewViewModel
    @State private var authorizationResult: Result<URL, Error>?
    var body: some View {
        VStack {
            Button("Login with Imgur") {
                UIApplication.shared.open(viewModel.generateAuthorizationURL())
            }
            .padding()
        }
        .onOpenURL { url in
            viewModel.handleAuthorizationCallback(url: url)
        }
    }
}

