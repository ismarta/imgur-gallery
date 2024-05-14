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
    func resolve() -> GetImages
    func resolve() -> UploadImage
    func resolve() -> AccessTokenRepository
    func resolve() -> AccessTokenDataSource
    func resolve() -> ImagesRepository
    func resolve() -> UserDefaultProtocol
}

extension InitialViewAssembler {
    func resolve() -> InitialView {
        InitialView(viewModel: resolve())
    }

    func resolve() -> InitialViewViewModel {
        InitialViewViewModel(getAccessTokenUseCase: resolve(), saveAccessTokenUseCase: resolve(), getImagesUseCase: resolve(), uploadImageUseCase: resolve())
    }

    func resolve() -> GetAccessToken {
        GetAccessToken(accessTokenRepository: resolve())
    }

    func resolve() -> SaveAccessToken {
        SaveAccessToken(accessTokenRepository: resolve())
    }

    func resolve() -> GetImages {
        GetImages(imagesRespository: resolve())
    }

    func resolve() -> UploadImage {
        UploadImage(imageRepository: resolve())
    }

    func resolve() -> ImagesRepository {
        ImagesDataRepository(remoteDataSource: ImagesRemoteDataSource())
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
