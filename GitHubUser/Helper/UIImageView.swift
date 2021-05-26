//
//  UIImageView.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import UIKit
import AlamofireImage

extension UIImageView {
    
    /// Set image asyncronously using alamofire image
    /// - Parameter url: image URL
    func setAFImage(url: URL) {
        
        af.setImage(withURL: url, placeholderImage: UIImage(named: Identifiers.userPlaceHolderImage), progressQueue: .main, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: false)
    }
}
