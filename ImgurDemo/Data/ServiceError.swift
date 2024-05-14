//
//  ServiceError.swift
//  ImgurDemo
//
//  Created by Marta on 14/5/24.
//

import Foundation

enum ServiceError: Error {
    case decode
    case encode
    case defaultError
    case url(URLError?)
}
