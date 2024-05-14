//
//  ImageEntityMock.swift
//  ImgurDemoTests
//
//  Created by Marta on 14/5/24.
//

import Foundation
@testable import ImgurDemo

class ImageEntityMock {
    let id: String
    init(id: String) {
        self.id = id
    }
    func givenAnImageentity() -> ImageEntity {
        return ImageEntity(id: id, name: "image_name", description: "image:description", link: "image_link")
    }
}
