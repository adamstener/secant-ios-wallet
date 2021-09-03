//
//  AppRouterNavigationTests.swift
//  secantTests
//
//  Created by Francisco Gindre on 9/2/21.
//

import XCTest
@testable import secant_testnet
import Foundation
import Combine
class LoadingScreenTests: XCTestCase {

    var cancellables = [AnyCancellable]()
    
    
    // MARK: LoadingScreenViewModel Tests
    
    func testLoadingPublishedHomeScreenWhenCredentialsArePresent() throws {
        let mockServices = MockServices()
        let stub = KeysPresentStub(returnBlock: {
            true
        })
        mockServices.keyStorage = stub
        let loadingViewModel = LoadingScreenViewModel(services: mockServices)
        let testExpectation = XCTestExpectation(description: "LoadingViewModel Publishes .credentialsFound when credentials are present and there's no failure")
        let expected = LoadingScreenViewModel.LoadingResult.credentialsFound
        
        loadingViewModel.$loadingResult
            .dropFirst()
            .sink { r in
                testExpectation.fulfill()
                
                XCTAssertTrue(stub.called)
                switch r {
                case .success(let result):
                    XCTAssertEqual(result, expected)
                case .failure(let e):
                    XCTFail("found error \(e.localizedDescription)")
                case .none:
                    XCTFail("found None when expected a value")
                }
            }
            .store(in: &cancellables)
        loadingViewModel.loadAsync()
        wait(for: [testExpectation], timeout: 0.1)
    }

    func testLoadingPublishesNavigatesToOnboardingWhenNoCredentialsFound() throws  {
        let mockServices = MockServices()
        let stub = KeysPresentStub(returnBlock: {
            false
        })
        mockServices.keyStorage = stub
        let loadingViewModel = LoadingScreenViewModel(services: mockServices)
        let testExpectation = XCTestExpectation(description: "LoadingViewModel Publishes .newWallet when no credentials are present and there's no failure")
        let expected = LoadingScreenViewModel.LoadingResult.newWallet
        
        loadingViewModel.$loadingResult
            .dropFirst()
            .sink { r in
                testExpectation.fulfill()
                
                XCTAssertTrue(stub.called)
                switch r {
                case .success(let result):
                    XCTAssertEqual(result, expected)
                case .failure(let e):
                    XCTFail("found error \(e.localizedDescription)")
                case .none:
                    XCTFail("found None when expected a value")
                }
            }
            .store(in: &cancellables)
        loadingViewModel.loadAsync()
        wait(for: [testExpectation], timeout: 0.1)
    }
    
    func testLoadingPublishesInitFailedScreenWhenFailsToInitialize() throws {
        let mockServices = MockServices()
        let stub = KeysPresentStub(returnBlock: {
            throw KeyStoringError.alreadyImported
        })
        mockServices.keyStorage = stub
        let loadingViewModel = LoadingScreenViewModel(services: mockServices)
        let testExpectation = XCTestExpectation(description: "LoadingViewModel Publishes .failure when there's a failure")
        
        loadingViewModel.$loadingResult
            .dropFirst()
            .sink { r in
                testExpectation.fulfill()
                
                XCTAssertTrue(stub.called)
                switch r {
                case .success(let result):
                    XCTFail("found result: \(result) but expected a failure")
                case .failure:
                    XCTAssertTrue(true) // fails when expected
                case .none:
                    XCTFail("found None when expected a failure")
                }
            }
            .store(in: &cancellables)
        loadingViewModel.loadAsync()
        wait(for: [testExpectation], timeout: 0.1)
    }

    func testLoadReturnsNewWalletWhenCredentialsAreNotPresent() throws {
        let mockServices = MockServices()
        let stub = KeysPresentStub(returnBlock: {
            false
        })
        mockServices.keyStorage = stub
        let loadingViewModel = LoadingScreenViewModel(services: mockServices)
        
        let expected = LoadingScreenViewModel.LoadingResult.newWallet
        let result = loadingViewModel.load()
        
        XCTAssertTrue(stub.called)
        switch result {
        case .failure(let e):
            XCTFail("found error \(e.localizedDescription)")
        case .success(let r):
            XCTAssertEqual(expected, r)
        }
    }
    
    func testLoadReturnsCredentialsFoundWhenCredentialsArePresent() throws {
        let mockServices = MockServices()
        let stub = KeysPresentStub(returnBlock: {
            true
        })
        mockServices.keyStorage = stub
        let loadingViewModel = LoadingScreenViewModel(services: mockServices)
        
        
        let expected = LoadingScreenViewModel.LoadingResult.credentialsFound
        let result = loadingViewModel.load()
        
        XCTAssertTrue(stub.called)
        switch result {
        case .failure(let e):
            XCTFail("found error \(e.localizedDescription)")
        case .success(let r):
            XCTAssertEqual(expected, r)
        }
    }
    
    func testLoadReturnsErrorWhenLoadingFails() throws {
        let mockServices = MockServices()
        let stub = KeysPresentStub(returnBlock: {
            throw KeyStoringError.uninitializedWallet
        })
        mockServices.keyStorage = stub
        let loadingViewModel = LoadingScreenViewModel(services: mockServices)
        
        
        let result = loadingViewModel.load()
        XCTAssertTrue(stub.called)
        switch result {
        case .failure:
            XCTAssertTrue(true)
        case .success(let r):
            XCTFail("case succeeded when testing failure - result: \(r)")
        }
    }
    
    // MARK: LoadingScreen View Tests
    
    func testProceedToHomeIsCalledWhenCredentialsAreFound() throws {
        
        let mockServices = MockServices()
        let stub = KeysPresentStub(returnBlock: {
            true
        })
        mockServices.keyStorage = stub
        let loadingViewModel = LoadingScreenViewModel(services: mockServices)
       
        
        let spyRouter = LoadingScreenRouterSpy(fulfillment: {
        })
        
        loadingViewModel.callRouter(spyRouter, with: loadingViewModel.load())
        XCTAssertTrue(spyRouter.proceedToHomeCalled)

    }
    
    func testProceedToWelcomeIsCalledWhenCredentialsAreNotFound() throws {
        let mockServices = MockServices()
        let stub = KeysPresentStub(returnBlock: {
            false
        })
        mockServices.keyStorage = stub
        let loadingViewModel = LoadingScreenViewModel(services: mockServices)
       
        
        let spyRouter = LoadingScreenRouterSpy(fulfillment: {
        })
        
        loadingViewModel.callRouter(spyRouter, with: loadingViewModel.load())
        XCTAssertTrue(spyRouter.proceedToWelcomeCalled)

    }
    
    func testFailWithErrorIsCalledWhenKeyStoringFails() throws {
        let mockServices = MockServices()
        let stub = KeysPresentStub(returnBlock: {
            throw KeyStoringError.alreadyImported
        })
        mockServices.keyStorage = stub
        let loadingViewModel = LoadingScreenViewModel(services: mockServices)
       
        
        let spyRouter = LoadingScreenRouterSpy(fulfillment: {
        })
        
        loadingViewModel.callRouter(spyRouter, with: loadingViewModel.load())
        XCTAssertTrue(spyRouter.failWithErrorCalled)

    }
}


class LoadingScreenRouterSpy: LoadingScreenRouter {
    init(fulfillment: @escaping () -> ()) {
        self.fulfillmentBlock = fulfillment
    }
    
    var fulfillmentBlock: () -> ()
    var proceedToHomeCalled: Bool = false
    var failWithErrorCalled: Bool = false
    var proceedToWelcomeCalled: Bool = false
    func proceedToHome() {
        proceedToHomeCalled = true
        fulfillmentBlock()
    }
    
    func failWithError() {
        failWithErrorCalled = true
        fulfillmentBlock()
    }
    
    func proceedToWelcome() {
        proceedToWelcomeCalled = true
        fulfillmentBlock()
    }
}

