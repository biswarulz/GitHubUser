//
//  UserDetailDescriptionTableViewCell.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 28/05/21.
//

import UIKit

class UserDetailDescriptionTableViewCell: UITableViewCell {

    private let detailStackView: UIStackView
    private let followersStackView: UIStackView
    private let noOfFollowersLabel: UILabel
    private let noOfFollowingLabel: UILabel
    private let fullNameLabel: UILabel
    private let companyLabel: UILabel
    private let blogLabel: UILabel
    private let locationLabel: UILabel
    
    /// constant values used
    private struct ViewTraits {
        
        static let viewMargin: CGFloat = 10.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        detailStackView = UIStackView()
        detailStackView.spacing = 10.0
        detailStackView.axis = .vertical
        detailStackView.alignment = .leading
        detailStackView.distribution = .equalSpacing
        
        followersStackView = UIStackView()
        followersStackView.spacing = 0.0
        followersStackView.axis = .horizontal
        followersStackView.alignment = .leading
        followersStackView.distribution = .fillEqually
        
        noOfFollowersLabel = UILabel()
        noOfFollowersLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        noOfFollowersLabel.numberOfLines = 0
        
        noOfFollowingLabel = UILabel()
        noOfFollowingLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        noOfFollowingLabel.numberOfLines = 0
        
        fullNameLabel = UILabel()
        fullNameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        fullNameLabel.numberOfLines = 0
        
        companyLabel = UILabel()
        companyLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        companyLabel.numberOfLines = 0
        
        blogLabel = UILabel()
        blogLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        blogLabel.numberOfLines = 0
        
        locationLabel = UILabel()
        locationLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        locationLabel.numberOfLines = 0
        
        followersStackView.addArrangedSubview(noOfFollowersLabel)
        followersStackView.addArrangedSubview(noOfFollowingLabel)
        detailStackView.addArrangedSubview(followersStackView)
        detailStackView.addArrangedSubview(fullNameLabel)
        detailStackView.addArrangedSubview(companyLabel)
        detailStackView.addArrangedSubview(blogLabel)
        detailStackView.addArrangedSubview(locationLabel)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        detailStackView.backgroundColor = .lightGray

        contentView.addSubViewsForAutoLayout([detailStackView])
        addCustomConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillData(_ data: UserDetailDescriptionViewData) {
        
        noOfFollowersLabel.text = "Followers: \(data.noOfFollowers)"
        noOfFollowingLabel.text = "Following: \(data.noOfFollowing)"
        fullNameLabel.text = "Full Name: \(data.fullName)"
        companyLabel.text = "Company: \(data.company)"
        blogLabel.text = "Blog: \(data.blog)"
        locationLabel.text = "Location: \(data.location)"
    }
    
    private func addCustomConstraints() {
        
        NSLayoutConstraint.activate([
        
            detailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.viewMargin),
            detailStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewTraits.viewMargin),
            detailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewTraits.viewMargin),
            detailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewTraits.viewMargin),
            
            followersStackView.leadingAnchor.constraint(equalTo: detailStackView.leadingAnchor),
            followersStackView.topAnchor.constraint(equalTo: detailStackView.topAnchor),
            followersStackView.trailingAnchor.constraint(equalTo: detailStackView.trailingAnchor),
            followersStackView.heightAnchor.constraint(equalToConstant: 40.0),
             
            noOfFollowersLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            noOfFollowingLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            fullNameLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            companyLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            blogLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            locationLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ])
    }

}
