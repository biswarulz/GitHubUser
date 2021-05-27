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
    private var isUserSearched = false
    
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
        searchController.delegate = self
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
        
        sceneView.showSpinner()
        userListViewModel?.getAllUserList()
    }
}

extension UserListViewController: UserListDisplayLogic {
    
    func displayUserList(_ viewData: UserListViewData) {
        
        sceneView.hideSpinner()
        dataSource?.userListViewData = viewData
        sceneView.tableView.reloadData()
    }
}

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
        tableView.tableFooterView?.isHidden = true
        if indexPath.row == numberOfRows - 1 && !isUserSearched {
            
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            userListViewModel?.loadMoreUserList()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentUser = dataSource?.userListViewData.userList[indexPath.row]
        let detailVC = UserDetailViewController(username: currentUser?.userName ?? "")
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension UserListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            isUserSearched = true
            userListViewModel?.fetchFilteredListBasedOnSearch(text)
        }
    }
}

extension UserListViewController: UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
        isUserSearched = false
    }
}

