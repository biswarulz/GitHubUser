//
//  UserDetail.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 27/05/21.
//

import Foundation

struct UserDetail: Decodable {
    
    let userName: String
    let userId: Int
    let avatarURL: String
    let userType: String
    let isAdmin: Bool
    let fullName: String
    let company: String
    let blog: String
    let location: String
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        
        case userName = "login"
        case userId = "id"
        case avatarURL = "avatar_url"
        case userType = "type"
        case isAdmin = "site_admin"
        case fullName = "name"
        case company
        case blog
        case location
        case followers
        case following
    }

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        userId = try container.decodeIfPresent(Int.self, forKey: .userId) ?? 0
        avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL) ?? ""
        userType = try container.decodeIfPresent(String.self, forKey: .userType) ?? ""
        isAdmin = try container.decodeIfPresent(Bool.self, forKey: .isAdmin) ?? false
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName) ?? "-"
        company = try container.decodeIfPresent(String.self, forKey: .company) ?? "-"
        blog = try container.decodeIfPresent(String.self, forKey: .blog) ?? "-"
        location = try container.decodeIfPresent(String.self, forKey: .location) ?? "-"
        followers = try container.decodeIfPresent(Int.self, forKey: .followers) ?? 0
        following = try container.decodeIfPresent(Int.self, forKey: .following) ?? 0
    }
    
    init(userName: String, userId: Int, avatarURL: String, userType: String, isAdmin: Bool, fullName: String, company: String, blog: String, location: String, followers: Int, following: Int) {
        
        self.userName = userName
        self.userId = userId
        self.avatarURL = avatarURL
        self.userType = userType
        self.isAdmin = isAdmin
        self.fullName = fullName
        self.company = company
        self.blog = blog
        self.location = location
        self.followers = followers
        self.following = following
    }
    
    init() {
        
        userName = ""
        userId = 0
        avatarURL = ""
        userType = ""
        isAdmin = false
        fullName = "-"
        company = "-"
        blog = "-"
        location = "-"
        followers = 0
        following = 0
    }
}

struct UserDetailViewData {
    
    let detailViewData: [Any]
    
    init() {
        
        detailViewData = []
    }
    
    init(detailViewData: [Any]) {
        
        self.detailViewData = detailViewData
    }
}

struct UserDetailMediaViewData {
    
    let userImage: String
}

struct UserDetailDescriptionViewData {
    
    let noOfFollowers: Int
    let noOfFollowing: Int
    let fullName: String
    let company: String
    let blog: String
    let location: String
}

struct UserDetailNoteViewData {
    
    let noteText: String
}
