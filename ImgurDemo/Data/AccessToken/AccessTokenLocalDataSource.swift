//
//  AccessTokenLocalDataSource.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation

class AccessTokenLocalDataSource: AccessTokenDataSource {
    private let userDefaults: UserDefaultProtocol

    init(userDefaults: UserDefaultProtocol) {
        self.userDefaults = userDefaults
    }

    func saveAccessToken(_ accessToken: AccessToken, completion: (Result<Bool, AuthenticationError>) -> Void) {
        userDefaults.saveAccessToken(accessToken, completion: { result in
            switch result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func getAccessToken(completion: (Result<AccessToken?, AuthenticationError>) -> Void) {
        userDefaults.getAccessToken(completion: { result in
            switch result {
            case .success(let accessToken):
                completion(.success(accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
