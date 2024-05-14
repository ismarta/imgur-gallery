//
//  AUthorizationManagementTests.swift
//  ImgurDemoTests
//
//  Created by Marta on 13/5/24.
//

import XCTest
@testable import ImgurDemo

final class AUthorizationManagementTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginScreenWithoutToken() {
        //GIVEN
        let userDefault = UserDefaultKeyNotExistMock()
        let initialViewViewModel = getInitialViewViewModel(userDefault: userDefault)
        //WHEN
        initialViewViewModel.loadView()
        //THEN
        XCTAssertEqual(initialViewViewModel.statusView, .login)
    }

    func testGalleryScreenWithToken() {
        //GIVEN
        let mockAccessToken = MyAccessTokenMock().getAccessToken()
        let userDefault = UserDefaultWithSuccessTokenMock(accessToken: mockAccessToken)
        let initialViewViewModel = getInitialViewViewModel(userDefault: userDefault)
        //WHEN
        initialViewViewModel.loadView()
        //THEN
        XCTAssertEqual(initialViewViewModel.statusView, .gallery)
        XCTAssertEqual(initialViewViewModel.accessToken, mockAccessToken)
    }

    func testHandleAuthorizationWithSuccessURL() {
        //GIVEN
        let mockAccessToken = MyAccessTokenMock().getAccessToken()
        let userDefault = UserDefaultWithSuccessTokenMock(accessToken: mockAccessToken)
        let initialViewViewModel = getInitialViewViewModel(userDefault: userDefault)
        let urlMock = "imgurdemo://oauth/callback?code=AUTHORIZATION_CODE&state=APPLICATION_STATE#access_token=myToken&expires_in=myExpiration&token_type=bearer&refresh_token=myRefreshToken&account_username=myUsername&account_id=acountId"
        //WHEN
        initialViewViewModel.handleAuthorizationCallback(url: URL(string:urlMock)!)
        //THEN
        XCTAssertEqual(initialViewViewModel.statusView, .gallery)
    }

    func testHandleAuthorizationWithWrongURL() {
        //GIVEN
        let mockAccessToken = MyAccessTokenMock().getAccessToken()
        let userDefault = UserDefaultWithSuccessTokenMock(accessToken: mockAccessToken)
        let initialViewViewModel = getInitialViewViewModel(userDefault: userDefault)
        let urlMock = "imgurdemo://oauth/callback?code=AUTHORIZATION_CODE&state=APPLICATION_STATE"
        //WHEN
        initialViewViewModel.handleAuthorizationCallback(url: URL(string:urlMock)!)
        //THEN
        XCTAssertEqual(initialViewViewModel.statusView, .error(initialViewViewModel.authorizationErrorText, initialViewViewModel.tryAgainText))
    }

    func testHandleAuthorizationWithErrorSavingToken() {
        //GIVEN
        let userDefault = UserDefaultWithErrorTokenMock()
        let initialViewViewModel = getInitialViewViewModel(userDefault: userDefault)
        let urlMock = "imgurdemo://oauth/callback?code=AUTHORIZATION_CODE&state=APPLICATION_STATE#access_token=myToken&expires_in=myExpiration&token_type=bearer&refresh_token=myRefreshToken&account_username=myUsername&account_id=acountId"
        //WHEN
        initialViewViewModel.handleAuthorizationCallback(url: URL(string:urlMock)!)
        //THEN
        XCTAssertEqual(initialViewViewModel.statusView, .error(initialViewViewModel.errorTokenText, initialViewViewModel.tryAgainText))
    }


    private func getInitialViewViewModel(userDefault: UserDefaultProtocol) -> InitialViewViewModel {
        let accessTokenLocalDataSource = AccessTokenLocalDataSource(userDefaults: userDefault)
        let accessTokenRepository = AccessTokenDataRepository(localDataSource: accessTokenLocalDataSource)
        let getAccessTokenUseCase = GetAccessToken(accessTokenRepository: accessTokenRepository)
        let saveAccessTokenUseCase = SaveAccessToken(accessTokenRepository: accessTokenRepository)
        return InitialViewViewModel(getAccessTokenUseCase: getAccessTokenUseCase, saveAccessTokenUseCase: saveAccessTokenUseCase)
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
