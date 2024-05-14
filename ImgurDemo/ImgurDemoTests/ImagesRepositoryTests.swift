//
//  ImagesRepositoryTests.swift
//  ImgurDemoTests
//
//  Created by Marta on 14/5/24.
//

import XCTest
@testable import ImgurDemo
import Combine

final class ImagesRepositoryTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetImagesSuccess() {
        //GIVEN
        let token = MyAccessTokenMock().getAccessToken()
        let imagesResult = [ImageEntityMock(id: "1").givenAnImageentity(), ImageEntityMock(id: "2").givenAnImageentity(), ImageEntityMock(id: "3").givenAnImageentity()]
        let imageUploaded = ImageEntityMock(id: "4").givenAnImageentity()
        let imagesRemoteDataSource = ImagesRemoteDataSourceSuccessMock(imagesResult: imagesResult, imageUploaded: imageUploaded)
        let imagesRepository = ImagesDataRepository(remoteDataSource: imagesRemoteDataSource)
        var successResult = false
        var errorResult: Error?
        var receivedValue: [ImageEntity] = []
        let expectation = XCTestExpectation(description: "Asynchronous operation is expected to complete")
        //WHEN
        _ = imagesRepository.getImages(accessToken: token).sink(receiveCompletion: { completion in
            switch completion {
                case .finished:
                    successResult = true
                case .failure(let error):
                    errorResult = error
                }},
              receiveValue: { images in
                receivedValue = images
        })

        XCTWaiter().wait(for: [expectation], timeout: 1.0)
        //THEN
        XCTAssertTrue(successResult)
        XCTAssertNil(errorResult)
        XCTAssertEqual(imagesResult, receivedValue)
    }

    func testGetImagesFailure() {
        //GIVEN
        let token = MyAccessTokenMock().getAccessToken()
        let imagesRemoteDataSource = ImagesRemoteDataSourceFailureMock()
        let imagesRepository = ImagesDataRepository(remoteDataSource: imagesRemoteDataSource)
        var successResult = false
        var errorResult: Error?
        var receivedValue: [ImageEntity] = []
        let expectation = XCTestExpectation(description: "Asynchronous operation is expected to complete")
        //WHEN
        _ = imagesRepository.getImages(accessToken: token).sink(receiveCompletion: { completion in
            switch completion {
                case .finished:
                    successResult = true
                case .failure(let error):
                    errorResult = error
                }},
              receiveValue: { images in
                receivedValue = images
        })

        XCTWaiter().wait(for: [expectation], timeout: 1.0)
        //THEN
        XCTAssertFalse(successResult)
        XCTAssertNotNil(errorResult)
        XCTAssertEqual(receivedValue, [])
    }

    func testUploadImageSuccess() {
        //GIVEN
        let token = MyAccessTokenMock().getAccessToken()
        let imageUploaded = ImageEntityMock(id: "4").givenAnImageentity()
        let imagesRemoteDataSource = ImagesRemoteDataSourceSuccessMock(imageUploaded: imageUploaded)
        let imagesRepository = ImagesDataRepository(remoteDataSource: imagesRemoteDataSource)
        var successResult = false
        var errorResult: Error?
        var receivedValue: ImageEntity? = nil
        let expectation = XCTestExpectation(description: "Asynchronous operation is expected to complete")
        //WHEN
        _ = imagesRepository.uploadImageData(accessToken: token, mediaImage: MediaEntity(data: Data(), forKey: "image")).sink(receiveCompletion: { completion in
            switch completion {
                case .finished:
                    successResult = true
                case .failure(let error):
                    errorResult = error
                }},
              receiveValue: { image in
                receivedValue = image
        })

        XCTWaiter().wait(for: [expectation], timeout: 1.0)
        //THEN
        XCTAssertTrue(successResult)
        XCTAssertNil(errorResult)
        XCTAssertEqual(imageUploaded, receivedValue)
    }

    func testUploadImageFailure() {
        //GIVEN
        let token = MyAccessTokenMock().getAccessToken()
        let imagesRemoteDataSource = ImagesRemoteDataSourceFailureMock()
        let imagesRepository = ImagesDataRepository(remoteDataSource: imagesRemoteDataSource)
        var successResult = false
        var errorResult: Error?
        var receivedValue: ImageEntity?
        let expectation = XCTestExpectation(description: "Asynchronous operation is expected to complete")
        //WHEN
        _ = imagesRepository.uploadImageData(accessToken: token, mediaImage: MediaEntity(data: Data(), forKey: "image")).sink(receiveCompletion: { completion in
            switch completion {
                case .finished:
                    successResult = true
                case .failure(let error):
                    errorResult = error
                }},
              receiveValue: { image in
                receivedValue = image
        })

        XCTWaiter().wait(for: [expectation], timeout: 1.0)
        //THEN
        XCTAssertFalse(successResult)
        XCTAssertNotNil(errorResult)
        XCTAssertEqual(receivedValue, nil)
    }
}

