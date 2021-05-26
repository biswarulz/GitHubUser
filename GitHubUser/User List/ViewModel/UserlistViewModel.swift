//
//  UserlistViewModel.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import Foundation

protocol UserListBusinessLogic: AnyObject {
    
    func getAllUserList()
}

class UserlistViewModel {
    
    private let serviceLayer: NetworkManager
    weak var viewController: UserListDisplayLogic?
    
    init() {
        
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
                self.presentUserList(user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func presentUserList(_ data: [User]) {
        
        let viewData = UserListViewData(userList: data, isNoteAvailable: false)
        viewController?.displayUserList(viewData)
    }
}
