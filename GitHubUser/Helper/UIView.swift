//
//  UIView.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import UIKit

extension UIView {
    
    /// Function to add an array of subviews for autolayout
    /// - Parameter subViews: array of subviews
    func addSubViewsForAutoLayout(_ subViews: [UIView]) {
        
        for subview in subViews {
            
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
    }
}
