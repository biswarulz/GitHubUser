//
//  GenericView.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import UIKit

class GenericView: UIView {
    
    private let wrapperView: UIView
    private let spinner: UIActivityIndicatorView
    private let noInternetView: UIView
    private let noInternetLabel: UILabel
    private var noInternetViewHeightContraint: NSLayoutConstraint?
    
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
        
        spinner = UIActivityIndicatorView()
        spinner.color = .white
        
        noInternetView = UIView()
        noInternetView.backgroundColor = .cyan
        noInternetView.isHidden = true
        
        noInternetLabel = UILabel()
        noInternetLabel.text = "Internet unavailable!"
        noInternetLabel.font = UIFont.systemFont(ofSize: 18.0)
        noInternetLabel.textColor = .darkGray
        
        noInternetView.addSubViewsForAutoLayout([noInternetLabel])
        
        super.init(frame: frame)
        wrapperView.addSubViewsForAutoLayout([spinner])
        addSubViewsForAutoLayout([wrapperView, noInternetView])
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
    
    func showOfflineBanner(_ show: Bool) {
        
        bringSubviewToFront(noInternetView)
        UIView.animate(withDuration: 0.5) {
            
            self.noInternetView.isHidden = show ? false : true
        } completion: { (_) in
            
            self.noInternetViewHeightContraint?.constant = show ? 60.0 : 0.0
        }
    }
    
    private func addCustomConstraints() {
        
        let noInternetViewHeightContraint = noInternetView.heightAnchor.constraint(equalToConstant: 0.0)
        self.noInternetViewHeightContraint = noInternetViewHeightContraint
        NSLayoutConstraint.activate([
            
            noInternetView.topAnchor.constraint(equalTo: topAnchor),
            noInternetView.leadingAnchor.constraint(equalTo: leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: trailingAnchor),
            noInternetViewHeightContraint,
            
            noInternetLabel.topAnchor.constraint(equalTo: noInternetView.topAnchor),
            noInternetLabel.leadingAnchor.constraint(equalTo: noInternetView.leadingAnchor),
            noInternetLabel.trailingAnchor.constraint(equalTo: noInternetView.trailingAnchor),
            noInternetLabel.bottomAnchor.constraint(equalTo: noInternetView.bottomAnchor),
            
            wrapperView.topAnchor.constraint(equalTo: noInternetView.topAnchor),
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

