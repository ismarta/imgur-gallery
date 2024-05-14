//
//  GetImages.swift
//  ImgurDemoTests
//
//  Created by Marta on 14/5/24.
//

import Foundation
import Combine

class GetImages {
    let imagesRespository: ImagesRepository

    init(imagesRespository: ImagesRepository) {
        self.imagesRespository = imagesRespository
    }

    func execute(accessToken: AccessToken) -> AnyPublisher<[ImageEntity],ServiceError> {
        imagesRespository.getImages(accessToken: accessToken)
    }
}
