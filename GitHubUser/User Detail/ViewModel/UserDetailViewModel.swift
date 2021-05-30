//
//  UserDetailViewModel.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 27/05/21.
//

import Foundation

protocol UserDetailBusinessLogic: AnyObject {
    
    func getUserDetailBasedOnUsername(_ username: String)
    func getUserDetailOfflineBasedOnUsername(_ username: String)
    func saveNoteDataToUserDetails(for username: String, noteText text: String)
}

protocol UserDetailDataStore {
    
    var userDetails: UserDetail { get set }
}

class UserDetailViewModel: UserDetailDataStore {
    
    private let serviceLayer: NetworkManager
    weak var viewController: UserDetailDisplayLogic?
    var userDetails: UserDetail
    private let dataController: DataController
    
    init(dataController: DataController = DataController(),
         userDetails: UserDetail = UserDetail(),
         serviceLayer: NetworkManager = NetworkManager()) {
        
        self.dataController = dataController
        self.userDetails = userDetails
        self.serviceLayer = serviceLayer
    }
}

extension UserDetailViewModel: UserDetailBusinessLogic {
    
    /// fetch user details from username
    /// - Parameter username: username of the user
    func getUserDetailBasedOnUsername(_ username: String) {
        
        serviceLayer.getUserDetail(forUsername: username) { [weak self] (result) in
            
            guard let self = self else {
                
                return
            }
            switch result {
            case .success(let userDetail):
                self.userDetails = userDetail
                self.dataController.saveUserDetail(userDetail)
                self.presentuserDetail(userDetail, username: username)
            case .failure(_):
                self.presentErrorFetchingUserDetail()
            }
        }
        
    }
    
    /// get user detail stored in the core data
    /// - Parameter username: username of the user
    func getUserDetailOfflineBasedOnUsername(_ username: String) {
        
        let detail = dataController.fetchUserDetailBasedOnUsername(username)
        self.userDetails = detail
        self.presentuserDetail(detail, username: username)
    }
    
    /// save note text entered in core data
    /// - Parameters:
    ///   - username: username of the user
    ///   - text: note text
    func saveNoteDataToUserDetails(for username: String, noteText text: String) {
        
        dataController.saveNoteDataForUser(username, note: text)
    }
    
    /// Present user detail by formatting the data to desired view data
    /// - Parameters:
    ///   - data: user detail data
    ///   - username: username of the user
    private func presentuserDetail(_ data: UserDetail, username: String) {
        
        let media = UserDetailMediaViewData(username: data.userName, userImage: data.avatarURL)
        let description = UserDetailDescriptionViewData(noOfFollowers: data.followers,
                                                        noOfFollowing: data.following,
                                                        fullName: data.fullName,
                                                        company: data.company,
                                                        blog: data.blog,
                                                        location: data.location)
        let noteText = dataController.getNoteDataForUser(username)
        let note = UserDetailNoteViewData(noteText: noteText)
        viewController?.displayUserDetail(UserDetailViewData(detailViewData: [media, description, note]))
    }
    
    /// Present error screen
    private func presentErrorFetchingUserDetail() {
        
        viewController?.displayErrorForUserDetail()
    }
}
