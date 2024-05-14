//
//  ImagesremoteDataSourceMocks.swift
//  ImgurDemoTests
//
//  Created by Marta on 14/5/24.
//

import Foundation
import Combine
@testable import ImgurDemo

class ImagesRemoteDataSourceSuccessMock: ImagesDataSource {
    let imagesResult: [ImageEntity]
    let imageUploaded: ImageEntity?

    init(imagesResult: [ImageEntity] = [], imageUploaded: ImageEntity? = nil) {
        self.imagesResult = imagesResult
        self.imageUploaded = imageUploaded
    }

    func getImages(accessToken: AccessToken) ->
        AnyPublisher<[ImageEntity],ServiceError> {
        return Just(imagesResult)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }

    func uploadImageData(accessToken: AccessToken, mediaImage: MediaEntity) -> AnyPublisher<ImageEntity?, ServiceError> {
        return Just(imageUploaded)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
}

class ImagesRemoteDataSourceFailureMock: ImagesDataSource {
    func getImages(accessToken: AccessToken) ->
        AnyPublisher<[ImageEntity],ServiceError> {
        return Fail(error: ServiceError.decode)
                .eraseToAnyPublisher()
    }

    func uploadImageData(accessToken: AccessToken, mediaImage: MediaEntity) -> AnyPublisher<ImageEntity?, ServiceError> {
        return Fail(error: ServiceError.decode)
            .eraseToAnyPublisher()
    }
}

