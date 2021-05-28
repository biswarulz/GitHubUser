//
//  GenericViewController.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 28/05/21.
//

import UIKit
import Alamofire

typealias RetryAction = () -> Void
class GenericViewController: UIViewController {

    var reachabiltyManager: NetworkReachabilityManager?
    var isReachable: Bool { return reachabiltyManager?.isReachable == true }
    var afterGainConnectivity: RetryAction?
    var afterLostConnectivity: RetryAction?
    lazy var genericSceneView: GenericView = {
        
        GenericView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reachabiltyManager = NetworkReachabilityManager()
        trackReachability()
    }
    
    override func loadView() {
        
        view = genericSceneView
    }
    
    private func trackReachability() {
        
        reachabiltyManager?.startListening(onUpdatePerforming: { [weak self] (status) in
            
            guard let self = self else { return }
            switch status {
            case .reachable(_):
                self.executeReloadAction(action: self.afterGainConnectivity)
                print("reachable")
                self.genericSceneView.showOfflineBanner(false)
            case .notReachable:
                print("not reachable")
                self.genericSceneView.showOfflineBanner(true)
                self.executeReloadAction(action: self.afterLostConnectivity)
            case .unknown:
                break
            }
        })
    }
    
    private func executeReloadAction(action: RetryAction?) {
        
        action?()
    }

}
