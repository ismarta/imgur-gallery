//
//  ImagesDataRepository.swift
//  ImgurDemo
//
//  Created by Marta on 14/5/24.
//

import Foundation
import Combine

class ImagesDataRepository: ImagesRepository {
    let remoteDataSource: ImagesDataSource

    init(remoteDataSource: ImagesDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getImages(accessToken: AccessToken) -> AnyPublisher<[ImageEntity],ServiceError> {
        remoteDataSource.getImages(accessToken: accessToken)
    }

    func uploadImageData(accessToken: AccessToken, mediaImage: MediaEntity) -> AnyPublisher<ImageEntity?, ServiceError> {
        remoteDataSource.uploadImageData(accessToken: accessToken, mediaImage: mediaImage)
    }

    func deleteImage(accessToken: AccessToken, imageId: String) -> AnyPublisher<Bool, ServiceError> {
        remoteDataSource.deleteImage(accessToken: accessToken, imageId: imageId)
    }
}
