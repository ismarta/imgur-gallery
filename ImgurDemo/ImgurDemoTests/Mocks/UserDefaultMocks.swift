//
//  UserDefaultMocks.swift
//  ImgurDemoTests
//
//  Created by Marta on 14/5/24.
//

import Foundation
@testable import ImgurDemo

class UserDefaultWithSuccessTokenMock: UserDefaultProtocol {
    let accessToken: AccessToken

    init(accessToken: AccessToken) {
        self.accessToken = accessToken
    }

    func saveAccessToken(_ accessToken: AccessToken, completion: (Result<Bool, AuthenticationError>) -> Void) {
        return completion(.success(true))
    }

    func getAccessToken(completion: (Result<AccessToken?, AuthenticationError>) -> Void) {
        return completion(.success(accessToken))
    }
}

class UserDefaultWithErrorTokenMock: UserDefaultProtocol {
    func saveAccessToken(_ accessToken: AccessToken, completion: (Result<Bool, AuthenticationError>) -> Void) {
        return completion(.failure(.encoding))
    }

    func getAccessToken(completion: (Result<AccessToken?, AuthenticationError>) -> Void) {
        return completion(.failure(.decoding))
    }
}

class UserDefaultKeyNotExistMock: UserDefaultProtocol {
    let accessToken: AccessToken?

    init(accessToken: AccessToken? = nil) {
        self.accessToken = accessToken
    }

    func saveAccessToken(_ accessToken: AccessToken, completion: (Result<Bool, AuthenticationError>) -> Void) {
        return completion(.failure(.encoding))
    }

    func getAccessToken(completion: (Result<AccessToken?, AuthenticationError>) -> Void) {
        return completion(.failure(.keyNotExist))
    }
}
