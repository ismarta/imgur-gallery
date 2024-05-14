//
//  UploadResponseRemoteEntity.swift
//  ImgurDemo
//
//  Created by Marta on 14/5/24.
//

import Foundation

struct UploadResponseRemoteEntity: Codable {
    let status: Int
    let success: Bool
    let data: ImageRemoteEntity
}

extension UploadResponseRemoteEntity {
    func transformToImageEntity() -> ImageEntity? {
        if success, let id = data.id, let link = data.link {
            return ImageEntity(id: id, name: data.name, description: data.description, link: link)
        } else {
            return nil
        }
    }
}
