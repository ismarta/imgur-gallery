//
//  InitialViewAssembler.swift
//  ImgurDemo
//
//  Created by Marta on 13/5/24.
//

import Foundation

protocol InitialViewAssembler {
    func resolve() -> InitialView
    func resolve() -> InitialViewViewModel
    func resolve() -> GetAccessToken
    func resolve() -> SaveAccessToken
    func resolve() -> AccessTokenRepository
    func resolve() -> AccessTokenDataSource
    func resolve() -> UserDefaultProtocol
}

extension InitialViewAssembler {
    func resolve() -> InitialView {
        return InitialView(viewModel: resolve())
    }

    func resolve() -> InitialViewViewModel {
        return InitialViewViewModel(getAccessTokenUseCase: resolve(), saveAccessTokenUseCase: resolve())
    }

    func resolve() -> GetAccessToken {
        return GetAccessToken(accessTokenRepository: resolve())
    }

    func resolve() -> SaveAccessToken {
        return SaveAccessToken(accessTokenRepository: resolve())
    }

    func resolve() -> AccessTokenRepository {
        return AccessTokenDataRepository(localDataSource: resolve())
    }

    func resolve() -> AccessTokenDataSource {
        return AccessTokenLocalDataSource(userDefaults: resolve())
    }

    func resolve() -> UserDefaultProtocol {
        return UserDefaultManager()
    }
}

class InitialViewInjection: InitialViewAssembler {}
