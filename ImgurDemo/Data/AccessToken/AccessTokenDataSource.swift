//
//  AccessTokenDataSource.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation
import Combine

enum AuthenticationError: Error {
    case encoding
    case decoding
    case keyNotExist
}

protocol AccessTokenDataSource {
    func saveAccessToken(_ accessToken: AccessToken, completion: (Result<Bool, AuthenticationError>) -> Void)
    func getAccessToken(completion: (Result<AccessToken?, AuthenticationError>) -> Void)
}
