//
//  UserDetailViewModel.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 27/05/21.
//

import Foundation

protocol UserDetailBusinessLogic: AnyObject {
    
    func getUserDetailBasedOnUsername(_ username: String)
}

protocol UserDetailDataStore {
    
    var userDetails: [UserDetail] { get set }
}

class UserDetailViewModel: UserDetailDataStore {
    
    private let serviceLayer: NetworkManager
    weak var viewController: UserDetailDisplayLogic?
    var userDetails: [UserDetail]
    
    init() {
        
        userDetails = []
        serviceLayer = NetworkManager()
    }
}

extension UserDetailViewModel: UserDetailBusinessLogic {
    
    func getUserDetailBasedOnUsername(_ username: String) {
        
    }
    
    
}
