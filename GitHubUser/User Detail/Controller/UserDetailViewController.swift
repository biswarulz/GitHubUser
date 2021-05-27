//
//  UserDetailViewController.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 27/05/21.
//

import UIKit

protocol UserDetailDisplayLogic: AnyObject {
    
    func displayUserDetail(_ viewData: UserDetailViewData)
}

class UserDetailViewController: UIViewController {

    lazy var sceneView: UserDetailView = {
        
        UserDetailView()
    }()
    private var userDetailViewModel: UserDetailBusinessLogic?
    private var dataSource: UserDetailDataSource?
    private var userame: String
    
    init(username: String) {
        
        self.userame = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = userame
        setUpArchitecture()
    }

    override func loadView() {
        
        view = sceneView
    }
    
    private func setUpArchitecture() {
        
        let viewController = self
        let viewModel = UserDetailViewModel()
        viewModel.viewController = viewController
        viewController.userDetailViewModel = viewModel
    }
}

extension UserDetailViewController: UserDetailDisplayLogic {
    
    func displayUserDetail(_ viewData: UserDetailViewData) {
        
    }
}
