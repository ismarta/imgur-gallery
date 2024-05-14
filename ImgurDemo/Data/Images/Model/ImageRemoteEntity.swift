//
//  ImageRemoteEntity.swift
//  ImgurDemo
//
//  Created by Marta on 14/5/24.
//

import Foundation

struct ImageRemoteEntity: Codable {
    let id: String?
    let name: String?
    let description: String?
    let link: String?
}

extension ImageRemoteEntity {
    func transformToDomain() -> ImageEntity? {
        if let id = id, let link = link {
            return ImageEntity(id: id, name: name, description: description, link: link)
        } else {
            return nil
        }
    }
}
extension Sequence where Iterator.Element == ImageRemoteEntity {
    func transformToDomain() -> [ImageEntity] {
        compactMap { $0.transformToDomain() }
    }
}
