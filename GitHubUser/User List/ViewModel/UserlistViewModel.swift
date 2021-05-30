//
//  UserlistViewModel.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import Foundation

protocol UserListBusinessLogic: AnyObject {
    
    func getAllUserList()
    func getAllUserListFromCoreData()
    func fetchFilteredListBasedOnSearch(_ text: String)
    func loadMoreUserList()
}

protocol UserListDataStore {
    
    var userList: [User] { get set }
}

class UserlistViewModel: UserListDataStore {
    
    private let serviceLayer: NetworkManager
    weak var viewController: UserListDisplayLogic?
    var userList: [User]
    private let dataController: DataController
    
    init(dataController: DataController = DataController(),
         userList: [User] = [],
         serviceLayer: NetworkManager = NetworkManager()) {
        
        self.dataController = dataController
        self.userList = userList
        self.serviceLayer = serviceLayer
    }
    
}

extension UserlistViewModel: UserListBusinessLogic {
    
    /// Get all album data
    func getAllUserList() {
        
        let pageIndex = 0
        fetchUserList(from: pageIndex)
        
    }
    
    func getAllUserListFromCoreData() {
        
        let users = dataController.fetchUsers()
        self.userList = users
        presentUserList(users)
    }
    
    func fetchFilteredListBasedOnSearch(_ text: String) {
        
        guard !text.isEmpty else {
            
            presentUserList(userList)
            return
        }
        let filteredUserList = userList.filter({ $0.userName.lowercased().contains(text.lowercased())})
        presentUserList(filteredUserList)
    }
    
    func loadMoreUserList() {
        
        if let lastUser = userList.last {
            
            fetchUserList(from: lastUser.userId)
        }
    }
    
    private func fetchUserList(from index: Int) {
        
        serviceLayer.getUserList(_startIndex: index) { [weak self] (result) in
            
            guard let self = self else {
                
                return
            }
            switch result {
            case .success(let user):
                self.userList.append(contentsOf: user)
                self.presentUserList(self.userList)
                self.dataController.insertUser(user)
            case .failure(_):
                self.presentErrorFetchingUserList()
            }
        }
    }
    
    private func presentUserList(_ data: [User]) {
        
        var updateList: [User] = []
        for user in data {
            
            var user = user
            let note = dataController.getNoteDataForUser(user.userName)
            user.isNoteAvailable = note.isEmpty ? false : true
            updateList.append(user)
        }
        let viewData = UserListViewData(userList: updateList)
        viewController?.displayUserList(viewData)
    }
    
    private func presentErrorFetchingUserList() {
        
        viewController?.displayErrorForUserList()
    }
}
