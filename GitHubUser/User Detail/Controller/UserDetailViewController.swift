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
        dataSource = UserDetailDataSource(UserDetailViewData())
        sceneView.tableView.dataSource = dataSource
        sceneView.tableView.delegate = self
        setUpArchitecture()
        tryToGetUserDetail()
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
    
    private func tryToGetUserDetail() {
        
        sceneView.showSpinner()
        userDetailViewModel?.getUserDetailBasedOnUsername(userame)
    }
}

extension UserDetailViewController: UserDetailDisplayLogic {
    
    func displayUserDetail(_ viewData: UserDetailViewData) {
        
        sceneView.hideSpinner()
        dataSource?.userDetailViewData = viewData
        sceneView.tableView.reloadData()
    }
}

extension UserDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let type = DetailCellType(rawValue: indexPath.row)
        
        switch type {
        case .media:
            return 250.0
        case .description:
            return 200.0
        case .note:
            return 250.0
        default:
            return 0.0
        }
    }
    
}
