//
//  User.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import Foundation

/// User list model data
struct User: Decodable {
    
    let userName: String
    let userId: Int
    let avatarURL: String
    let userType: String
    let isAdmin: Bool
    var isNoteAvailable: Bool
    var cachedImage: Data?
    
    enum CodingKeys: String, CodingKey {
        
        case userName = "login"
        case userId = "id"
        case avatarURL = "avatar_url"
        case userType = "type"
        case isAdmin = "site_admin"
        case isNoteAvailable
        case cachedImage
    }

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        userId = try container.decodeIfPresent(Int.self, forKey: .userId) ?? 0
        avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL) ?? ""
        userType = try container.decodeIfPresent(String.self, forKey: .userType) ?? ""
        isAdmin = try container.decodeIfPresent(Bool.self, forKey: .isAdmin) ?? false
        isNoteAvailable = try container.decodeIfPresent(Bool.self, forKey: .isNoteAvailable) ?? false
        cachedImage = try container.decodeIfPresent(Data.self, forKey: .cachedImage)
    }
    
    init(userName: String = "",
         userId: Int = 0,
         avatarURL: String = "",
         userType: String = "",
         isAdmin: Bool = false,
         isNoteAvailable: Bool = false,
         cachedImage: Data? = nil) {
        
        self.userName = userName
        self.userId = userId
        self.avatarURL = avatarURL
        self.userType = userType
        self.isAdmin = isAdmin
        self.isNoteAvailable = isNoteAvailable
        self.cachedImage = cachedImage
    }
}

struct UserListViewData {
    
    let userList: [User]
    let showOfflineData : Bool
}
