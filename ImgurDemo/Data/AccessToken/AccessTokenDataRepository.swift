//
//  AccessTokenDataRepository.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation

class AccessTokenDataRepository: AccessTokenRepository {

    let localDataSource: AccessTokenDataSource
    init(localDataSource: AccessTokenDataSource) {
        self.localDataSource = localDataSource
    }

    func saveAccessToken(_ accessToken: AccessToken, completion: (Result<Bool, AuthenticationError>) -> Void) {
        localDataSource.saveAccessToken(accessToken, completion: { result in
            switch result {
            case .success(let result):
                completion(.success(result))
            case .failure(let failure):
                completion(.failure(failure))
            }
        })
    }

    func getAccessToken(completion: (Result<AccessToken?, AuthenticationError>) -> Void) {
        localDataSource.getAccessToken(completion: { result in
            switch result {
            case .success(let result):
                completion(.success(result))
            case .failure(let failure):
                completion(.failure(failure))
            }
        })
    }
}
