//
//  ErrorView.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import SwiftUI

struct ErrorView: View {
    let textMessage: String
    let textButton: String?
    @ObservedObject var viewModel: InitialViewViewModel
    var body: some View {
        VStack() {
            Image(systemName: "exclamationmark.triangle").resizable()
                .foregroundColor(.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Spacer().frame(height: 20)
            Text(textMessage)
                .font(.system(size: 17))
                .foregroundColor(.black)
            Spacer().frame(height: 20)
            if let textButton = textButton {
                Button(action: {
                    viewModel.loadView()
                }, label: {
                    Text(textButton)
                }).padding()
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(8)
            }

        }.padding()
    }
}
