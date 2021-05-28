//
//  NetworkManager.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import Foundation
import Alamofire

class NetworkManager {
    
    /// Get all users lists
    /// - Parameter completionHandler: completion handler containing success and failure data
    /// - Parameter index: start index of user list
    func getUserList(_startIndex index: Int, completionHandler: @escaping (Result<[User], Error>) -> ()) {
        
        let networkURL = "\(Identifiers.userNetworkURL)\(index)"
        AF.request(networkURL)
            {$0.timeoutInterval = Identifiers.requestTimeoutInterval}.validate()
            .responseDecodable(of: [User].self) { (response) in
            
            if let error = response.error {
                
                completionHandler(.failure(error))
            } else {
                
                let users = response.value ?? []
                completionHandler(.success(users))
            }
        }
    }
    
    /// Fetch user details based on username
    /// - Parameters:
    ///   - username: user name
    ///   - completionHandler: completion handler containing success and failure data
    func getUserDetail(forUsername username: String, completionHandler: @escaping (Result<UserDetail, Error>) -> ()) {
        
        let networkURL = "\(Identifiers.userDetailNetworkURL)\(username)"
        AF.request(networkURL)
            {$0.timeoutInterval = Identifiers.requestTimeoutInterval}.validate()
            .responseDecodable(of: UserDetail.self) { (response) in
            
            if let error = response.error {
                
                completionHandler(.failure(error))
            } else {
                
                let users = response.value ?? UserDetail()
                completionHandler(.success(users))
            }
        }
    }
}
