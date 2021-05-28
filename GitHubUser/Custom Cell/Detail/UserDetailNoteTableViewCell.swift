//
//  UserDetailNoteTableViewCell.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 28/05/21.
//

import UIKit

protocol SaveNoteDataDelegate: AnyObject {
    
    func saveNoteButtonClicked(_ text: String)
}

class UserDetailNoteTableViewCell: UITableViewCell {

    private let noteLabel: UILabel
    private let noteTextView: UITextView
    private let saveButton: UIButton
    weak var delegate: SaveNoteDataDelegate?
    
    /// constant values used
    private struct ViewTraits {
        
        static let viewMargin: CGFloat = 10.0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        noteLabel = UILabel()
        noteLabel.font = UIFont.systemFont(ofSize: 21.0, weight: .bold)
        
        noteTextView = UITextView()
        noteTextView.isEditable = true
        noteTextView.isScrollEnabled = true
        noteTextView.layer.borderWidth = 2.0
        noteTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        saveButton = UIButton()
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.backgroundColor = .gray
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        saveButton.addTarget(self, action: #selector(didTapOnSaveNote), for: .touchUpInside)

        contentView.addSubViewsForAutoLayout([noteLabel, noteTextView, saveButton])
        addCustomConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillData(_ data: UserDetailNoteViewData) {
        
        noteLabel.text = "Note:"
        noteTextView.text = data.noteText
        saveButton.setTitle("Save", for: .normal)
    }
    
    @objc func didTapOnSaveNote() {
        
        delegate?.saveNoteButtonClicked(noteTextView.text)
        saveButton.setTitle("Saved", for: .normal)
        saveButton.backgroundColor = .green
        UIView.animate(withDuration: 3.0) {
            
            self.saveButton.backgroundColor = .gray

        } completion: { (_) in
            
            self.saveButton.setTitle("Save", for: .normal)

        }
    }
    
    private func addCustomConstraints() {
        
        NSLayoutConstraint.activate([
        
            noteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.viewMargin),
            noteLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewTraits.viewMargin),
            noteLabel.widthAnchor.constraint(equalToConstant: 100.0),
            
            noteTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTraits.viewMargin),
            noteTextView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: ViewTraits.viewMargin),
            noteTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewTraits.viewMargin),
            noteTextView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -ViewTraits.viewMargin),
            noteTextView.heightAnchor.constraint(equalToConstant: 160.0),
            
            saveButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: ViewTraits.viewMargin),
            saveButton.heightAnchor.constraint(equalToConstant: 50.0),
            saveButton.widthAnchor.constraint(equalToConstant: 100.0),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

}
