//
//  UserDefaultManager.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation

class UserDefaultKeys {
    static let accessTokenKey = "AccessToken"
}

class UserDefaultManager: UserDefaultProtocol {
    static let shared = UserDefaultManager()
    private let userDefaults = UserDefaults.standard

    func saveAccessToken(_ accessToken: AccessToken, completion: (Result<Bool, AuthenticationError>) -> Void) {
        do {
            let encodedData = try JSONEncoder().encode(accessToken)
            userDefaults.set(encodedData, forKey: UserDefaultKeys.accessTokenKey)
            completion(.success(true))
        } catch {
            completion(.failure(.encoding))
        }
    }

    func getAccessToken(completion: (Result<AccessToken?, AuthenticationError>) -> Void) {
        guard let savedData = userDefaults.data(forKey: UserDefaultKeys.accessTokenKey) else {
            return completion(.failure(.keyNotExist))
        }
        do {
            let accessToken = try JSONDecoder().decode(AccessToken.self, from: savedData)
            completion(.success(accessToken))
        } catch {
            print("Error al decodificar el struct:", error)
            completion(.failure(.decoding))
        }
    }
}

protocol UserDefaultProtocol {
    func saveAccessToken(_ accessToken: AccessToken, completion: (Result<Bool, AuthenticationError>) -> Void)
    func getAccessToken(completion: (Result<AccessToken?, AuthenticationError>) -> Void)
}
