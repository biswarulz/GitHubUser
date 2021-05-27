//
//  UserlistViewModel.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import Foundation

protocol UserListBusinessLogic: AnyObject {
    
    func getAllUserList()
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
    
    init() {
        
        userList = []
        serviceLayer = NetworkManager()
    }
    
}

extension UserlistViewModel: UserListBusinessLogic {
    
    /// Get all album data
    func getAllUserList() {
        
        let pageIndex = 0
        serviceLayer.getUserList(_startIndex: pageIndex) { [weak self] (result) in
            
            guard let self = self else {
                
                return
            }
            switch result {
            case .success(let user):
                self.userList = user
                self.presentUserList(user)
            case .failure(let error):
                print(error)
            }
        }
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
            
            serviceLayer.getUserList(_startIndex: lastUser.userId) { [weak self] (result) in
                
                guard let self = self else {
                    
                    return
                }
                switch result {
                case .success(let user):
                    self.userList.append(contentsOf: user)
                    self.presentUserList(self.userList)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func presentUserList(_ data: [User]) {
        
        let viewData = UserListViewData(userList: data, isNoteAvailable: false)
        viewController?.displayUserList(viewData)
    }
}
