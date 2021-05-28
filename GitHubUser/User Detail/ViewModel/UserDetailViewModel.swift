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
    
    var userDetails: UserDetail { get set }
}

class UserDetailViewModel: UserDetailDataStore {
    
    private let serviceLayer: NetworkManager
    weak var viewController: UserDetailDisplayLogic?
    var userDetails: UserDetail
    
    init() {
        
        userDetails = UserDetail()
        serviceLayer = NetworkManager()
    }
}

extension UserDetailViewModel: UserDetailBusinessLogic {
    
    func getUserDetailBasedOnUsername(_ username: String) {
        
        serviceLayer.getUserDetail(forUsername: username) { [weak self] (result) in
            
            guard let self = self else {
                
                return
            }
            switch result {
            case .success(let userDetail):
                self.userDetails = userDetail
                self.presentuserDetail(userDetail)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func presentuserDetail(_ data: UserDetail) {
        
        let media = UserDetailMediaViewData(userImage: data.avatarURL)
        let description = UserDetailDescriptionViewData(noOfFollowers: data.followers,
                                                        noOfFollowing: data.following,
                                                        fullName: data.fullName,
                                                        company: data.company,
                                                        blog: data.blog,
                                                        location: data.location)
        let note = UserDetailNoteViewData(noteText: "")
        viewController?.displayUserDetail(UserDetailViewData(detailViewData: [media, description, note]))
    }
}
