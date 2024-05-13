//
//  AccessToken.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation

struct AccessToken: Codable, Equatable {
    let token: String
    let expiresIn: String
    let userName: String
}
