//
//  AccessTokenMock.swift
//  ImgurDemoTests
//
//  Created by Marta on 14/5/24.
//

import Foundation
@testable import ImgurDemo

class MyAccessTokenMock {
    func getAccessToken() -> AccessToken {
        AccessToken(token: "MyToken", expiresIn: "expiration", userName: "MyUserName")
    }
}
