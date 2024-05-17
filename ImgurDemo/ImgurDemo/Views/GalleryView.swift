//
//  GalleryView.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import SwiftUI

enum PhotosSourceType {
    case camera
    case photoLibrary
}

struct GalleryView: View {
    @ObservedObject var viewModel: InitialViewViewModel
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var sourceType: PhotosSourceType = .photoLibrary
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
                                Button(action: {
                                    viewModel.deleteImage(imageId: imageData.id)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }.padding()
                }//Scroll
            }
            HStack {
                Button("Import Picture") {
                    self.sourceType = .photoLibrary
                    self.showImagePicker.toggle()
                }.padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                
                Button("Take Picture") {
                    self.sourceType = .camera
                    self.showImagePicker.toggle()
                }.padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding()
            .background(Color.white)
        }.sheet(isPresented: $showImagePicker) {
            PickerView(selectedImage: $selectedImage, sourceType: sourceType)
        }.onChange(of: selectedImage) { image in
            if let image = image {
                viewModel.uploadImage(image: image)
            }
        }.onChange(of: sourceType) { sourceType in
            self.sourceType = sourceType
        }
    }
}



