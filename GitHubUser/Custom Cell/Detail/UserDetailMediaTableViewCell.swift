//
//  UserDetailMediaTableViewCell.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 28/05/21.
//

import UIKit

class UserDetailMediaTableViewCell: UITableViewCell {

    private let detailImageView: CustomImageView
    
    /// constant values used
    private struct ViewTraits {
        
        static let viewMargin: CGFloat = 10.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        detailImageView = CustomImageView()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubViewsForAutoLayout([detailImageView])
        addCustomConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillData(_ data: UserDetailMediaViewData) {
        
        if let userImage = URL(string: data.userImage) {
            
            detailImageView.setAFImage(for: data.username, url: userImage)
        } else {
            
            detailImageView.image = UIImage(named: Identifiers.userPlaceHolderImage)
        }
    }
    
    private func addCustomConstraints() {
        
        NSLayoutConstraint.activate([
        
            detailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.viewMargin),
            detailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewTraits.viewMargin),
            detailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewTraits.viewMargin),
            detailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewTraits.viewMargin)
        ])
    }
    
}
