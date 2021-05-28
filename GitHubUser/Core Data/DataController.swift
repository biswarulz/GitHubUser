//
//  DataController.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 28/05/21.
//

import UIKit
import CoreData

class DataController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var context: NSManagedObjectContext {
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func insertUser(_ users: [User]) {
        
        for user in users {
            
            let entity = UserEntity(context: context)
            entity.avatarURL = user.avatarURL
            entity.userName = user.userName
            entity.userId = Int16(user.userId)
            entity.userType = user.userType
            entity.isAdmin = user.isAdmin
            
            context.insert(entity)
            
            appDelegate.saveContext()
        }
    }
    
    func fetchUsers() -> [User] {
        
        var userList: [User] = []
        if let entities = try? context.fetch(UserEntity.fetchRequest() as NSFetchRequest<UserEntity>) {
            
            for entity in entities {
                
                let user = User(userName: entity.userName ?? "", userId: Int(entity.userId) , avatarURL: entity.avatarURL ?? "", userType: entity.userType ?? "", isAdmin: entity.isAdmin)
                userList.append(user)
            }
        }
        
        return userList
    }
    
    func fetchUserDetailBasedOnUsername(_ username: String) -> UserDetail {
        
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        request.predicate = NSPredicate(format: "userName == %@", username)
        
        if let users = try? context.fetch(request), let firstUser = users.first {
            
            let userDetail = UserDetail(userName: firstUser.userName ?? "", userId: Int(firstUser.userId), avatarURL: firstUser.avatarURL ?? "", userType: firstUser.userType ?? "", isAdmin: firstUser.isAdmin, fullName: firstUser.fullName ?? "", company: firstUser.company ?? "", blog: firstUser.blog ?? "", location: firstUser.location ?? "", followers: Int(firstUser.followers), following: Int(firstUser.following))
            return userDetail
        }
        
        return UserDetail()
    }
    
    func saveNoteDataForUser(_ username: String, note: String) {
        
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        request.predicate = NSPredicate(format: "userName == %@", username)
        
        if let users = try? context.fetch(request), let firstUser = users.first {
            
            firstUser.note = note
            context.insert(firstUser)
            appDelegate.saveContext()
        }
    }
}
