//
//  DeleteImage.swift
//  ImgurDemo
//
//  Created by Marta on 17/5/24.
//

import Foundation
import Combine

class DeleteImage {
    let repository: ImagesRepository

    init(repository: ImagesRepository) {
        self.repository = repository
    }

    func execute(accessToken: AccessToken, imageId: String) -> AnyPublisher<Bool,ServiceError> {
        repository.deleteImage(accessToken: accessToken, imageId: imageId)
    }
}
