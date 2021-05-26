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
    
    enum CodingKeys: String, CodingKey {
        
        case userName = "login"
        case userId = "id"
        case avatarURL = "avatar_url"
        case userType = "type"
        case isAdmin = "site_admin"
    }

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        userId = try container.decodeIfPresent(Int.self, forKey: .userId) ?? 0
        avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL) ?? ""
        userType = try container.decodeIfPresent(String.self, forKey: .userType) ?? ""
        isAdmin = try container.decodeIfPresent(Bool.self, forKey: .isAdmin) ?? false
    }
}

struct UserListViewData {
    
    let userList: [User]
    let isNoteAvailable: Bool
}
