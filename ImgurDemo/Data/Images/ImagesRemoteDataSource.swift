//
//  ImagesRemoteDataSource.swift
//  ImgurDemo
//
//  Created by Marta on 14/5/24.
//

import Foundation
import Combine

class ImagesRemoteDataSource: ImagesDataSource {
    func getImages(accessToken: AccessToken) -> AnyPublisher<[ImageEntity], ServiceError> {
        let publisher: AnyPublisher<ImageDataRemoteEntity, ServiceError> = ImagesApi.getImages(accessToken.userName).buildRequestPublisher(token: accessToken.token)
        let dataPublisher = publisher.map { response in
            return response.data
        }
        let imagesEntityPublisher = dataPublisher.map { image in
            return image.transformToDomain()
        }
        return imagesEntityPublisher.eraseToAnyPublisher()
    }

    func uploadImageData(accessToken: AccessToken, mediaImage: MediaEntity) -> AnyPublisher<ImageEntity?,ServiceError> {
        let publisher: AnyPublisher<UploadResponseRemoteEntity, ServiceError> = ImagesApi.uploadImage(mediaImage).buildRequestPublisher(token: accessToken.token)
        let transformedPublisher = publisher.map { response in
            return response.transformToImageEntity()
        }
        return transformedPublisher.eraseToAnyPublisher()
    }
}
