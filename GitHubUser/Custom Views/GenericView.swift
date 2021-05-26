//
//  GenericView.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import UIKit

class GenericView: UIView {
    
    let wrapperView: UIView
    let spinner: UIActivityIndicatorView
    
    /// constant values used
    private struct ViewTraits {
        
        static let maxAlpha: CGFloat = 0.7
        static let minAlpha: CGFloat = 0.0
        static let animateDuration = 0.1
        static let spinnerSize: CGFloat = 50.0
    }
    
    override init(frame: CGRect) {
        
        wrapperView = UIView()
        wrapperView.backgroundColor = .lightGray
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        spinner = UIActivityIndicatorView()
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        wrapperView.addSubview(spinner)
        addSubview(wrapperView)
        addCustomConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Show spinner while having network call
    func showSpinner() {
        
        self.wrapperView.alpha = ViewTraits.maxAlpha
        self.spinner.startAnimating()
        bringSubviewToFront(wrapperView)
    }
    
    /// Hide spinner once data received
    func hideSpinner() {
        
        UIView.animate(withDuration: ViewTraits.animateDuration) {
            
            self.wrapperView.alpha = ViewTraits.minAlpha
        } completion: { (_) in
            
            self.sendSubviewToBack(self.wrapperView)
            self.spinner.stopAnimating()
        }

    }
    
    private func addCustomConstraints() {
        
        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: topAnchor),
            wrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: trailingAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            spinner.heightAnchor.constraint(equalToConstant: ViewTraits.spinnerSize),
            spinner.widthAnchor.constraint(equalToConstant: ViewTraits.spinnerSize),
            spinner.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor)
        ])
    }
    
}

