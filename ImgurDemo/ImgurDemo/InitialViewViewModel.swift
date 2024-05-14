//
//  InitialViewViewModel.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation

enum StatusView: Equatable {
    case login
    case gallery
    case error(String, String?)
}

class InitialViewViewModel: ObservableObject {
    @Published var statusView: StatusView
    let getAccessTokenUseCase: GetAccessToken
    let saveAccessTokenUseCase: SaveAccessToken
    var accessToken: AccessToken?
    let authorizationErrorText = "Authorization Error"
    let errorTokenText = "Error saving AccesToken"
    let tryAgainText = "Try Again"

    init(getAccessTokenUseCase: GetAccessToken, saveAccessTokenUseCase: SaveAccessToken, accessToken: AccessToken? = nil) {
        self.getAccessTokenUseCase = getAccessTokenUseCase
        self.saveAccessTokenUseCase = saveAccessTokenUseCase
        self.accessToken = accessToken
        self.statusView = .login
        loadView()
    }

    func loadView() {
        existAccessToken(completion: { [weak self] result in
            switch result {
            case .success(_):
                self?.statusView = .gallery
            case .failure(_):
                self?.statusView = .login
            }
        })
    }

    func generateAuthorizationURL() -> URL {
        let clientID = ApiDetails.clientID
        let responseType = "token"
        let state = "APPLICATION_STATE"

        var components = URLComponents(string: ApiDetails.baseURL+"/oauth2/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "response_type", value: responseType),
            URLQueryItem(name: "state", value: state)
        ]
        guard let url = components?.url else {
            return URL(string: ApiDetails.baseURL+"/oauth2/authorize")!
        }
        return url
    }
    
    func handleAuthorizationCallback(url: URL) {
        guard let accessToken = url.extractAccessToken() else {
            statusView = .error(authorizationErrorText, tryAgainText)
            return
        }
        saveAccessTokenUseCase.execute(accessToken: accessToken, completion: { result in
            switch result {
            case .success(_):
                statusView = .gallery
            case .failure(_):
                statusView = .error(errorTokenText, tryAgainText)
            }
        })
    }

    private func existAccessToken(completion: (Result<Bool, AuthenticationError>) -> Void) {
        getAccessTokenUseCase.execute(completion: {[weak self] result in
            switch result {
            case .success(let accessToken):
                self?.accessToken = accessToken
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
