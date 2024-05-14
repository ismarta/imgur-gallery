//
//  RequestPublisher.swift
//  ImgurDemo
//
//  Created by Marta on 14/5/24.
//

import Foundation
import Combine

protocol RequestableProtocol {
    func get<T: Codable>(fromURL urlString: String, token: String, method: String, bodyParams: [String: String]?, mediaImage: [MediaEntity]?) -> AnyPublisher<T, ServiceError>
}

class RequestPublisher: RequestableProtocol {
    private var urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func get<T: Codable>(fromURL urlString: String, token: String, method: String = "GET", bodyParams: [String: String]? = nil, mediaImage: [MediaEntity]? = nil) -> AnyPublisher<T, ServiceError> {
        guard let url = URL(string: urlString) else {
            return Fail<T, ServiceError>(error: .url(URLError(URLError.Code.badURL))).eraseToAnyPublisher()
        }
        return getData(fromURL: getRequest(from: url, token: token, method: method, bodyParams: bodyParams, mediaImage: mediaImage))
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                return .decode
            }
            .eraseToAnyPublisher()
    }

    private func getRequest(from url: URL, token: String, method: String = "GET", bodyParams: [String: String]?, mediaImage: [MediaEntity]?) -> URLRequest {
        var request = URLRequest(url: url)
        request.cachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        if method == "POST", bodyParams != nil {
            //multipart/form-data
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let dataBody = createDataBody(withParameters: bodyParams, media: mediaImage, boundary: boundary)
            request.httpBody = dataBody
        }
        return request
    }

    private func getData(fromURL request: URLRequest) -> AnyPublisher<Data, ServiceError> {
        return urlSession
            .dataTaskPublisher(for: request)
            .map {
                return $0.data
            }
            .mapError {
                error in
                .url(error)}
            .eraseToAnyPublisher()
    }

    private func createDataBody(withParameters params: [String: String]?, media: [MediaEntity]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        if let media = media {
            for item in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(item.key)\"; filename=\"\(item.filename)\"\(lineBreak)")
                body.append("Content-Type: \(item.mimeType + lineBreak + lineBreak)")
                body.append(item.data)
                body.append("\(lineBreak)")
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
