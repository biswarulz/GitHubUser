//
//  UserDetailViewModelTests.swift
//  GitHubUserTests
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import XCTest
@testable import GitHubUser

class UserDetailViewModelTests: XCTestCase {

    private var viewModel: UserDetailViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    private class DataControllerSpy: DataController {
        
        var saveUserDetailCalled = false
        var fetchUserDetailBasedOnUsernameCalled = false
        var saveNoteDataForUserCalled = false
        var getNoteDataForUsercalled = false
        
        override func saveUserDetail(_ detail: UserDetail) {
            
            saveUserDetailCalled = true
        }
        
        override func fetchUserDetailBasedOnUsername(_ username: String) -> UserDetail {
            
            fetchUserDetailBasedOnUsernameCalled = true
            return UserDetail()
        }
        
        override func saveNoteDataForUser(_ username: String, note: String) {
            
            saveNoteDataForUserCalled = true
        }
        
        override func getNoteDataForUser(_ username: String) -> String {
            
            getNoteDataForUsercalled = true
            return ""
        }
    }
    
    private class ServiceLayerSpySuccess: NetworkManager {
        
        override func getUserList(_startIndex index: Int, completionHandler: @escaping (Result<[User], Error>) -> ()) {
            
            completionHandler(.success([]))
        }
        
        override func getUserDetail(forUsername username: String, completionHandler: @escaping (Result<UserDetail, Error>) -> ()) {
            completionHandler(.success(UserDetail()))
        }
    }
    
    private class ServiceLayerSpyFailure: NetworkManager {
        
        override func getUserList(_startIndex index: Int, completionHandler: @escaping (Result<[User], Error>) -> ()) {
            let error = NSError(domain: "", code: 404, userInfo: [:])
            completionHandler(.failure(error))
        }
        
        override func getUserDetail(forUsername username: String, completionHandler: @escaping (Result<UserDetail, Error>) -> ()) {
            let error = NSError(domain: "", code: 404, userInfo: [:])
            completionHandler(.failure(error))
        }
    }
    
    private class ViewControllerSpy: UserDetailDisplayLogic {
        
        var displayUserDetailCalled = false
        var displayErrorForUserDetailCalled = false
        
        func displayUserDetail(_ viewData: UserDetailViewData) {
            
            displayUserDetailCalled = true
        }
        
        func displayErrorForUserDetail() {
            
            displayErrorForUserDetailCalled = true
        }
    }
    
    func testGetUserDetailBasedOnUsernameSuccess() {
        
        // Given
        let dataController = DataControllerSpy()
        let serviceLayer = ServiceLayerSpySuccess()
        viewModel = UserDetailViewModel(dataController: dataController, userDetails: UserDetail(), serviceLayer: serviceLayer)
        let viewController = ViewControllerSpy()
        viewModel?.viewController = viewController
        
        // When
        viewModel?.getUserDetailBasedOnUsername("test")
        
        // Then
        XCTAssertTrue(dataController.saveUserDetailCalled, "Should store user details to core data")
        XCTAssertTrue(dataController.getNoteDataForUsercalled, "Should fetch note data stored in storage")
        XCTAssertTrue(viewController.displayUserDetailCalled, "SHould display user detail")
    }
    
    func testGetUserDetailBasedOnUsernameFailure() {
        
        // Given
        let serviceLayer = ServiceLayerSpyFailure()
        viewModel = UserDetailViewModel(serviceLayer: serviceLayer)
        let viewController = ViewControllerSpy()
        viewModel?.viewController = viewController
        
        // When
        viewModel?.getUserDetailBasedOnUsername("test")
        
        // Then
        XCTAssertTrue(viewController.displayErrorForUserDetailCalled, "SHould display error")
    }
    
    func testGetUserDetailOfflineBasedOnUsername() {
        
        // Given
        let dataController = DataControllerSpy()
        viewModel = UserDetailViewModel(dataController: dataController)
        let viewController = ViewControllerSpy()
        viewModel?.viewController = viewController
        
        //When
        viewModel?.getUserDetailOfflineBasedOnUsername("test")
        
        // Then
        XCTAssertTrue(dataController.fetchUserDetailBasedOnUsernameCalled, "fetchUserDetailBasedOnUsernameCalled should be called")
        XCTAssertTrue(viewController.displayUserDetailCalled, "SHould display user detail")
    }
    
    func testSaveNoteDataToUserDetails() {
        
        // Given
        let dataController = DataControllerSpy()
        viewModel = UserDetailViewModel(dataController: dataController)
        let viewController = ViewControllerSpy()
        viewModel?.viewController = viewController
        
        //When
        viewModel?.saveNoteDataToUserDetails(for: "test", noteText: "text")
        
        // Then
        XCTAssertTrue(dataController.saveNoteDataForUserCalled, "saveNoteDataForUserCalled should be called")
    }

}
