//
//  UserDetailDataSource.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 27/05/21.
//

import UIKit

enum DetailCellType : Int {
    
    case media = 0
    case description
    case note
}

protocol PassNoteDataCallbackDelegate: AnyObject {
    
    func passNoteDataAction(_ text: String)
}

class UserDetailDataSource: NSObject {
    
    var userDetailViewData: UserDetailViewData
    weak var delegate: PassNoteDataCallbackDelegate?
    
    init(_ userDetailViewData: UserDetailViewData) {
        
        self.userDetailViewData = userDetailViewData
    }
}

extension UserDetailDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userDetailViewData.detailViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = DetailCellType(rawValue: indexPath.row)
        let detailData = userDetailViewData.detailViewData[indexPath.row]
        
        switch type {
        case .media:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.userDetailMediaCellIdentifier) as? UserDetailMediaTableViewCell, let mediaData = detailData as? UserDetailMediaViewData else {
                
                return UITableViewCell()
            }
            
            cell.fillData(mediaData)
            cell.selectionStyle = .none
            return cell
        case .description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.userDetailDescCellIdentifier) as? UserDetailDescriptionTableViewCell, let descData = detailData as? UserDetailDescriptionViewData else {
                
                return UITableViewCell()
            }
            
            cell.fillData(descData)
            cell.selectionStyle = .none
            return cell
        case .note:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.userDetailNoteCellIdentifier) as? UserDetailNoteTableViewCell, let noteData = detailData as? UserDetailNoteViewData else {
                
                return UITableViewCell()
            }
            
            cell.fillData(noteData)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
}

extension UserDetailDataSource: SaveNoteDataDelegate {
    
    func saveNoteButtonClicked(_ text: String) {
        
        delegate?.passNoteDataAction(text)
    }
    
}
