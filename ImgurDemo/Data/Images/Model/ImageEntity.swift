//
//  ImageEntity.swift
//  ImgurDemo
//
//  Created by Marta on 14/5/24.
//

import Foundation

struct ImageEntity: Codable, Hashable {
    let id: String
    let name: String?
    let description: String?
    let link: String
}
