//
//  InitialViewViewModel.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation
import Combine

enum StatusView: Equatable {
    case login
    case gallery
    case error(String, String?)
}

class InitialViewViewModel: ObservableObject {
    @Published var statusView: StatusView
    @Published var images: [ImageEntity] = []
    let getAccessTokenUseCase: GetAccessToken
    let saveAccessTokenUseCase: SaveAccessToken
    let getImagesUseCase: GetImages
    let uploadImageUseCase: UploadImage
    var accessToken: AccessToken?
    let authorizationErrorText = "Authorization Error"
    let errorTokenText = "Error saving AccesToken"
    let tryAgainText = "Try Again"
    var cancellables: Set<AnyCancellable> = []

    init(getAccessTokenUseCase: GetAccessToken, saveAccessTokenUseCase: SaveAccessToken, getImagesUseCase: GetImages, uploadImageUseCase: UploadImage, accessToken: AccessToken? = nil) {
        self.getAccessTokenUseCase = getAccessTokenUseCase
        self.saveAccessTokenUseCase = saveAccessTokenUseCase
        self.getImagesUseCase = getImagesUseCase
        self.uploadImageUseCase = uploadImageUseCase
        self.accessToken = accessToken
        self.statusView = .login
        loadView()
    }

    func loadView() {
        existAccessToken(completion: { result in
            switch result {
            case .success(_):
                loadImages()
            case .failure(_):
                loadLogin()
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

    private func loadImages() {
        guard let accessToken = accessToken else {
            return loadLogin()
        }
        let publisher = getImagesUseCase.execute(accessToken: accessToken).receive(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("getImagesUseCase::success")
            case .failure(let error):
                print("getImagesUseCase::Error: \(error)")
            }
        }, receiveValue: {[weak self] images in
            DispatchQueue.main.async {
                self?.images = images
                self?.statusView = .gallery
            }
        })
        publisher.store(in: &cancellables)
    }

    private func loadLogin() {
        statusView = .login
    }
}
