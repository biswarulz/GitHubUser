//
//  UserListViewController.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import UIKit

protocol UserListDisplayLogic: AnyObject {
    
    func displayUserList(_ viewData: UserListViewData)
}

class UserListViewController: UIViewController {

    lazy var sceneView: UserListView = {
        
        UserListView()
    }()
    private var userListViewModel: UserListBusinessLogic?
    private var dataSource: UserListDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "User"
        setUpArchitecture()
        setupSearchField()
        let viewData = UserListViewData(userList: [], isNoteAvailable: false)
        dataSource = UserListDataSource(viewData)
        sceneView.tableView.dataSource = dataSource
        sceneView.tableView.delegate = self
        tryToGetUserList()
    }
    
    override func loadView() {
        
        view = sceneView
    }
    
    private func setupSearchField() {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
    private func setUpArchitecture() {
        
        let viewController = self
        let viewModel = UserlistViewModel()
        viewModel.viewController = viewController
        viewController.userListViewModel = viewModel
    }
    
    private func tryToGetUserList() {
        
        userListViewModel?.getAllUserList()
    }
}

extension UserListViewController: UserListDisplayLogic {
    
    func displayUserList(_ viewData: UserListViewData) {
        
        dataSource?.userListViewData = viewData
        sceneView.tableView.reloadData()
    }
}

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
    }
}

extension UserListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

