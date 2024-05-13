//
//  AccessTokenRepository.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation

protocol AccessTokenRepository {
    func saveAccessToken(_ accessToken: AccessToken, completion: (Result<Bool, AuthenticationError>) -> Void)
    func getAccessToken(completion: (Result<AccessToken?, AuthenticationError>) -> Void)
}
