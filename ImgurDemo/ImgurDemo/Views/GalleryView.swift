//
//  GalleryView.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import SwiftUI

struct GalleryView: View {
    @ObservedObject var viewModel: InitialViewViewModel
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    var body: some View {
        VStack {
            if viewModel.images.isEmpty {
                ErrorView(textMessage: "Not images", textButton: nil, viewModel: viewModel).padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                        ForEach(viewModel.images, id: \.self) { imageData in
                            VStack {
                                AsyncImage(url: URL(string:imageData.link)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(8)
                                            .shadow(radius: 4)
                                    case .failure:
                                        Image(systemName: "exclamationmark.triangle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }.padding()
                }//Scroll
            }
            HStack {
                Button("Import Picture") {
                    self.showImagePicker.toggle()
                }.padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                
                Button("Take Picture") {
                }.padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding()
            .background(Color.white)
        }.sheet(isPresented: $showImagePicker) {
            PickerView(selectedImage: $selectedImage)
        }.onChange(of: selectedImage) { oldValue, newValue in
            if let image = newValue {
                viewModel.uploadImage(image: image)
            }
        }
    }
}
