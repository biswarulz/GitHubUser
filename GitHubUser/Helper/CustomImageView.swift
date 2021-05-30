//
//  CustomImageView.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import UIKit
import AlamofireImage

class CustomImageView: UIImageView {
    
    let dataController: DataController
    
    init() {
        
        dataController = DataController()
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Set image asyncronously using alamofire image
    /// - Parameter url: image URL
    /// - Parameter username: username of user to get/save image to core data
    func setAFImage(for username: String, url: URL, showInvertedImage: Bool = false) {
        
        if let image = dataController.getImageStoredOfflineStorage(username) {
            
            self.image = showInvertedImage
                ? invertImage(UIImage(data: image) ?? UIImage())
                : UIImage(data: image)
        } else {
            
            af.setImage(withURL: url, placeholderImage: UIImage(named: Identifiers.userPlaceHolderImage), progressQueue: .main, imageTransition: .crossDissolve(0.4), runImageTransitionIfCached: false) { [weak self] (response) in
                
                guard let self = self else { return }
                
                if let imageData = response.data {
                    
                    self.dataController.saveImageToOfflineStorage(username, imageData: imageData)
                }
            }
        }
    }
    
    
    /// invert the color of the image
    /// - Parameter image: original Image
    /// - Returns: inverted image
    func invertImage(_ image: UIImage) -> UIImage? {
        
        let filter = CIFilter(name: "CIColorInvert")
        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        if let outputImage = filter?.outputImage {
            
            let invertedImage = UIImage(ciImage: outputImage)
            return invertedImage
        }
        return nil
    }
}
