//
//  UserListTableViewCell.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    private let userImageView: UIImageView
    private let userListStackView: UIStackView
    private let userNameLabel: UILabel
    private let userTypeLabel: UILabel
    private let noteImageView: UIImageView
    
    /// constant values used
    private struct ViewTraits {
        
        static let viewMargin: CGFloat = 10.0
        static let userImageViewHeight: CGFloat = 50.0
        static let userImageViewWidth: CGFloat = 100.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        userImageView = UIImageView()
        userImageView.layer.cornerRadius = ViewTraits.userImageViewWidth/2
        userImageView.clipsToBounds = true
        
        userListStackView = UIStackView()
        userListStackView.spacing = 10.0
        userListStackView.axis = .vertical
        userListStackView.alignment = .leading
        userListStackView.distribution = .equalSpacing
        
        userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        userNameLabel.numberOfLines = 1
        
        userTypeLabel = UILabel()
        userTypeLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        userTypeLabel.textColor = .darkGray
        userNameLabel.numberOfLines = 1
        
        noteImageView = UIImageView()
        
        userListStackView.addArrangedSubview(userNameLabel)
        userListStackView.addArrangedSubview(userTypeLabel)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubViewsForAutoLayout([userImageView, userListStackView, noteImageView])
        addCustomConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillData(_ data: User, isNoteAvailable: Bool) {
        
        if let avatarURL = URL(string: data.avatarURL) {
            
            userImageView.setAFImage(url: avatarURL)
        } else {
            
            userImageView.image = UIImage(named: Identifiers.userPlaceHolderImage)
        }
        
        userNameLabel.text = data.userName
        userTypeLabel.text = "Role: \(data.userType)"
        noteImageView.image = UIImage(systemName: isNoteAvailable ? Identifiers.systemNoteTextImage : Identifiers.emptyImage)
    }
    
    private func addCustomConstraints() {
        
        NSLayoutConstraint.activate([
        
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.viewMargin),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewTraits.viewMargin),
            userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewTraits.viewMargin),
            userImageView.widthAnchor.constraint(equalToConstant: ViewTraits.userImageViewWidth),
            
            userListStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: ViewTraits.viewMargin),
            userListStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewTraits.viewMargin),
            userListStackView.trailingAnchor.constraint(equalTo: noteImageView.leadingAnchor, constant: -ViewTraits.viewMargin),
            userListStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewTraits.viewMargin),
            
            noteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewTraits.viewMargin),
            noteImageView.heightAnchor.constraint(equalToConstant: 25.0),
            noteImageView.widthAnchor.constraint(equalToConstant: 25.0),
            noteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
