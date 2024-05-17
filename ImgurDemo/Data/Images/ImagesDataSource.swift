//
//  ImagesDataSource.swift
//  ImgurDemo
//
//  Created by Marta on 14/5/24.
//

import Foundation
import Combine

protocol ImagesDataSource {
    func getImages(accessToken: AccessToken) -> AnyPublisher<[ImageEntity],ServiceError>
    func uploadImageData(accessToken: AccessToken, mediaImage: MediaEntity) -> AnyPublisher<ImageEntity?,ServiceError>
    func deleteImage(accessToken: AccessToken, imageId: String) -> AnyPublisher<Bool, ServiceError>
}
