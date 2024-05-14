//
//  Media.swift
//  ImgurDemo
//
//  Created by Marta on 14/5/24.
//

import Foundation

struct MediaEntity {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String

    init(data: Data, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "upload.jpg"
        self.data = data
    }
}
