//
//  UserListViewModelTests.swift
//  GitHubUserTests
//
//  Created by Biswajyoti Sahu on 30/05/21.
//

import XCTest
@testable import GitHubUser

class UserListViewModelTests: XCTestCase {

    private var viewModel: UserlistViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    private class DataControllerSpy: DataController {
        
        var insertUserCalled = false
        var fetchUsersCalled = false
        var getNoteDataForUsercalled = false
        
        override func insertUser(_ users: [User]) {
            
            insertUserCalled = true
        }
        
        override func fetchUsers() -> [User] {
            
            fetchUsersCalled = true
            return []
        }
        
        override func getNoteDataForUser(_ username: String) -> String {
            
            getNoteDataForUsercalled = true
            return ""
        }
    }
    
    
    private class ServiceLayerSpySuccess: NetworkManager {
        
        
        override func getUserList(_startIndex index: Int, completionHandler: @escaping (Result<[User], Error>) -> ()) {
            
            let user = User(userName: "", userId: 0, avatarURL: "", userType: "", isAdmin: false, isNoteAvailable: false, cachedImage: nil)
            completionHandler(.success([user]))
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
    
    private class ViewControllerSpy: UserListDisplayLogic {
        
        var displayUserListCalled = false
        var displayErrorForUserListCalled = false
        
        func displayUserList(_ viewData: UserListViewData) {
            
            displayUserListCalled = true
        }
        
        func displayErrorForUserList() {
            
            displayErrorForUserListCalled = true
        }
    }

    func testGetAllUserListSuccess() {
        
        // Given
        let dataController = DataControllerSpy()
        let serviceLayer = ServiceLayerSpySuccess()
        viewModel = UserlistViewModel(dataController: dataController, userList: [], serviceLayer: serviceLayer)
        let viewController = ViewControllerSpy()
        viewModel?.viewController = viewController
        
        // When
        viewModel?.getAllUserList()
        
        // Then
        XCTAssertTrue(dataController.insertUserCalled, "Should store user list to core data")
        XCTAssertTrue(dataController.getNoteDataForUsercalled, "Should fetch note data stored in storage")
        XCTAssertTrue(viewController.displayUserListCalled, "SHould display user list")
    }
    
    func testGetAllUserListFailure() {
        
        // Given
        let dataController = DataControllerSpy()
        let serviceLayer = ServiceLayerSpyFailure()
        viewModel = UserlistViewModel(dataController: dataController, userList: [], serviceLayer: serviceLayer)
        let viewController = ViewControllerSpy()
        viewModel?.viewController = viewController
        
        // When
        viewModel?.getAllUserList()
        
        // Then
        XCTAssertTrue(viewController.displayErrorForUserListCalled, "SHould display error")
    }
    
    func testLoadMoreUserListSuccess() {
        
        // Given
        let user = User(userName: "", userId: 1, avatarURL: "", userType: "", isAdmin: false, isNoteAvailable: false, cachedImage: nil)
        let dataController = DataControllerSpy()
        let serviceLayer = ServiceLayerSpySuccess()
        viewModel = UserlistViewModel(dataController: dataController, userList: [user], serviceLayer: serviceLayer)
        let viewController = ViewControllerSpy()
        viewModel?.viewController = viewController
        
        // When
        viewModel?.loadMoreUserList()
        
        // Then
        XCTAssertTrue(dataController.insertUserCalled, "Should store user list to core data")
        XCTAssertTrue(dataController.getNoteDataForUsercalled, "Should fetch note data stored in storage")
        XCTAssertTrue(viewController.displayUserListCalled, "SHould display user list")
    }
    
    func testLoadMoreUserListFailure() {
        
        // Given
        let user = User(userName: "", userId: 1, avatarURL: "", userType: "", isAdmin: false, isNoteAvailable: false, cachedImage: nil)
        let dataController = DataControllerSpy()
        let serviceLayer = ServiceLayerSpyFailure()
        viewModel = UserlistViewModel(dataController: dataController, userList: [user], serviceLayer: serviceLayer)
        let viewController = ViewControllerSpy()
        viewModel?.viewController = viewController
        
        // When
        viewModel?.loadMoreUserList()
        
        // Then
        XCTAssertTrue(viewController.displayErrorForUserListCalled, "SHould display error")
    }
    
    func testFetchFilteredListBasedOnSearch() {
        
        // Given
        let user = User(userName: "test", userId: 1, avatarURL: "", userType: "", isAdmin: false, isNoteAvailable: false, cachedImage: nil)
        viewModel = UserlistViewModel(userList: [user])
        let viewController = ViewControllerSpy()
        viewModel?.viewController = viewController
        
        // When
        viewModel?.fetchFilteredListBasedOnSearch("test")
        
        // Then
        XCTAssertTrue(viewController.displayUserListCalled, "SHould display user list")
    }
    
    func testFetchFilteredListBasedOnEmptySearch() {
        
        // Given
        let user = User(userName: "test", userId: 1, avatarURL: "", userType: "", isAdmin: false, isNoteAvailable: false, cachedImage: nil)
        viewModel = UserlistViewModel(userList: [user])
        let viewController = ViewControllerSpy()
        viewModel?.viewController = viewController
        
        // When
        viewModel?.fetchFilteredListBasedOnSearch("")
        
        // Then
        XCTAssertTrue(viewController.displayUserListCalled, "SHould display user list")
    }
}
