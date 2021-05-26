//
//  UserListDataSource.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import UIKit

class UserListDataSource: NSObject {
    
    var userListViewData: UserListViewData
    
    init(_ userListViewData: UserListViewData) {
        
        self.userListViewData = userListViewData
    }
}

extension UserListDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userListViewData.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.userListCellIdentifier) as? UserListTableViewCell else {
            
            return UITableViewCell()
        }
        
        let user = userListViewData.userList[indexPath.row]
        cell.fillData(user, isNoteAvailable: userListViewData.isNoteAvailable)
        return cell
    }
}
