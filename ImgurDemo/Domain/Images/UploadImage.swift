//
//  UploadImage.swift
//  ImgurDemoTests
//
//  Created by Marta on 14/5/24.
//

import Foundation
import Combine

class UploadImage {
    let imageRepository: ImagesRepository

    init(imageRepository: ImagesRepository) {
        self.imageRepository = imageRepository
    }

    func execute(accessToken: AccessToken, mediaImage: MediaEntity) -> AnyPublisher<ImageEntity?,ServiceError> {
        imageRepository.uploadImageData(accessToken: accessToken, mediaImage: mediaImage)
    }
}
