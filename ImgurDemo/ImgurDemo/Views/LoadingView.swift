//
//  LoadingView.swift
//  ImgurDemo
//
//  Created by Marta on 17/5/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Color.black.opacity(0.4)
            .edgesIgnoringSafeArea(.all)
        ProgressView()
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
    }
}

#Preview {
    LoadingView()
}
