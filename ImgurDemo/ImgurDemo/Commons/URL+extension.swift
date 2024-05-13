//
//  URL+extension.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation

extension URL {
    func extractAccessToken() -> AccessToken? {
        var token: String = ""
        var expiresIn: String = ""
        var userName: String = ""

        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let fragment = components.fragment else {
            return nil
        }
        let parameters = fragment.components(separatedBy: "&")
        for parameter in parameters {
            let keyValue = parameter.components(separatedBy: "=")
            if keyValue.count == 2 {
                switch keyValue[0] {
                case "access_token":
                    token = keyValue[1]
                case "expires_in":
                   expiresIn = keyValue[1]
                case "account_username":
                    userName = keyValue[1]
                default:
                    break
                }
            }
        }
        return AccessToken(token: token, expiresIn: expiresIn, userName: userName)
    }

}
