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
        
        AF.request(Identifiers.userNetworkURL)
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
}
