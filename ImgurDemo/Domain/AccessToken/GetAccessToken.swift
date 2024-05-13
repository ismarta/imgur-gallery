//
//  GetAccessToken.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation

class GetAccessToken {
    private let accessTokenRepository: AccessTokenRepository

    init(accessTokenRepository: AccessTokenRepository) {
        self.accessTokenRepository = accessTokenRepository
    }

    func execute(completion: (Result<AccessToken?, AuthenticationError>) -> Void) {
        accessTokenRepository.getAccessToken(completion: { result in
            switch result {
            case .success(let accessToken):
                completion(.success(accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

