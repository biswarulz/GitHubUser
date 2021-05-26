//
//  UserListView.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import UIKit

class UserListView: GenericView {

    let tableView: UITableView
    
    /// constant values used
    private struct ViewTraits {
        
        static let estimatedRowHeight: CGFloat = 80.0
    }
    
    override init(frame: CGRect) {
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: Identifiers.userListCellIdentifier)
        tableView.estimatedRowHeight = ViewTraits.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        super.init(frame: frame)
        addSubview(tableView)
        addCustomConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCustomConstraints() {
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

