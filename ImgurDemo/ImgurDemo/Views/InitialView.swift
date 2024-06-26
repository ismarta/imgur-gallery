//
//  InitialView.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation
import SwiftUI

struct InitialView: View {
    @ObservedObject var viewModel: InitialViewViewModel
    var body: some View {
        ZStack {
            switch viewModel.statusView {
            case .gallery:
                GalleryView(viewModel: viewModel)
            case .login:
                LoginView(viewModel: viewModel)
            case .error(let textMessage, let textButton):
                ErrorView(textMessage: textMessage, textButton: textButton, viewModel: viewModel)
            }

            if viewModel.isLoading {
               LoadingView()
            }
        }
    }
}
