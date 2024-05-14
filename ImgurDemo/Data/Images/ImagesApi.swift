//
//  ImagesApi.swift
//  ImgurDemo
//
//  Created by Marta on 14/5/24.
//

import Foundation
import Combine

enum ImagesApi {
    case getImages(String)
    case uploadImage(MediaEntity)

    var method: String {
        switch self {
        case .getImages:
            return "GET"
        case .uploadImage:
            return "POST"
        }
    }

    var pathParams: String {
        switch self {
        case .getImages(let userName):
            return "/3/account/\(userName)/images"
        case .uploadImage:
            return "/3/image/"
        }
    }

    var bodyParams:[String: String] {
        switch self {
        case .getImages:
            return [:]
        case .uploadImage:
            return ["type": "image", "title": "", "description": ""]
        }
    }

    var mediaParam: [MediaEntity] {
        switch self {
        case .getImages:
            return []
        case .uploadImage(let media):
            return [media]
        }
    }

    func buildRequestPublisher<T: Codable>(requestPublisher: RequestableProtocol = RequestPublisher(), token: String) -> AnyPublisher<T, ServiceError>  {
        let urlString = ApiDetails.baseURL + pathParams
        return requestPublisher.get(fromURL: urlString, token: token, method: method, bodyParams: bodyParams, mediaImage: mediaParam)
    }
}
