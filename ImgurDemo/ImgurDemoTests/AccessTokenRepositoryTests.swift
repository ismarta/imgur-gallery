//
//  AccessTokenRepositoryTests.swift
//  ImgurDemoTests
//
//  Created by Marta on 13/5/24.
//

import XCTest
@testable import ImgurDemo

final class AccessTokenRepositoryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveAccessTokenSuccess() {
        //GIVEN
        let accessTokenToBeSaved = MyAccessTokenMock().getAccessToken()
        let userDefault = UserDefaultWithSuccessTokenMock(accessToken: accessTokenToBeSaved)
        let localDataSource = AccessTokenLocalDataSource(userDefaults: userDefault)
        let accessTokenRepository = AccessTokenDataRepository(localDataSource: localDataSource)
        var resultValue: Bool = false
        var authenticationError: AuthenticationError? = nil
        //WHEN
        accessTokenRepository.saveAccessToken(accessTokenToBeSaved, completion: { result in
            switch result {
            case .success(let success):
                resultValue = success
            case .failure(let error):
                authenticationError = error
            }
        })
        //THEN
        XCTAssertTrue(resultValue)
        XCTAssertNil(authenticationError)
    }

    func testSaveAccessTokenFailure() {
        //GIVEN
        let accessTokenToBeSaved = MyAccessTokenMock().getAccessToken()
        let userDefault = UserDefaultWithErrorTokenMock()
        let localDataSource = AccessTokenLocalDataSource(userDefaults: userDefault)
        let accessTokenRepository = AccessTokenDataRepository(localDataSource: localDataSource)
        var resultValue: Bool? = nil
        var authenticationError: AuthenticationError? = nil
        //WHEN
        accessTokenRepository.saveAccessToken(accessTokenToBeSaved, completion: { result in
            switch result {
            case .success(let success):
                resultValue = success
            case .failure(let error):
                authenticationError = error
            }
        })
        //THEN
        XCTAssertEqual(authenticationError!, AuthenticationError.encoding)
        XCTAssertNil(resultValue)
    }

    func testGetAccessTokenSuccess() {
        //GIVEN
        let accessTokenSaved = MyAccessTokenMock().getAccessToken()
        let userDefault = UserDefaultWithSuccessTokenMock(accessToken: accessTokenSaved)
        let localDataSource = AccessTokenLocalDataSource(userDefaults: userDefault)
        let accessTokenRepository = AccessTokenDataRepository(localDataSource: localDataSource)
        var accessTokenResult: AccessToken? = nil
        var authenticationError: AuthenticationError? = nil
        //WHEN
        accessTokenRepository.getAccessToken(completion: { result in
            switch result {
            case .success(let accessToken):
                accessTokenResult = accessToken
            case .failure(let error):
                authenticationError = error
            }
        })
        //THEN
        XCTAssertEqual(accessTokenResult, accessTokenSaved)
        XCTAssertNil(authenticationError)
    }

    func testGetAccessTokenFailure() {
        //GIVEN
        let userDefault = UserDefaultWithErrorTokenMock()
        let localDataSource = AccessTokenLocalDataSource(userDefaults: userDefault)
        let accessTokenRepository = AccessTokenDataRepository(localDataSource: localDataSource)
        var accessTokenResult: AccessToken? = nil
        var authenticationError: AuthenticationError? = nil
        //WHEN
        accessTokenRepository.getAccessToken(completion: { result in
            switch result {
            case .success(let accessToken):
                accessTokenResult = accessToken
            case .failure(let error):
                authenticationError = error
            }
        })
        //THEN
        XCTAssertNil(accessTokenResult)
        XCTAssertEqual(authenticationError, .decoding)
    }
}

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

class MyAccessTokenMock {
    func getAccessToken() -> AccessToken {
        AccessToken(token: "MyToken", expiresIn: "expiration", userName: "MyUserName")
    }
}
