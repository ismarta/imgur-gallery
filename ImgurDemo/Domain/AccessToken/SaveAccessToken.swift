//
//  SaveAccessToken.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation

class SaveAccessToken {
    private let accessTokenRepository: AccessTokenRepository
    
    init(accessTokenRepository: AccessTokenRepository) {
        self.accessTokenRepository = accessTokenRepository
    }

    func execute(accessToken: AccessToken, completion: (Result<Bool, AuthenticationError>)-> Void) {
        accessTokenRepository.saveAccessToken(accessToken, completion: { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
