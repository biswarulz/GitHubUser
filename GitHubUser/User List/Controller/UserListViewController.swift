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

class UserListViewController: GenericViewController {

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
        let viewData = UserListViewData(userList: [])
        dataSource = UserListDataSource(viewData)
        sceneView.tableView.dataSource = dataSource
        sceneView.tableView.delegate = self
        tryToGetUserListFromRestCall()
        
        // handle when network comes online
        let retryGainConnectionAction: RetryAction = { [weak self] in
            
            guard let self = self else { return }
            self.tryToGetUserListFromRestCall()
        }
        
        let retryLossConnectionAction: RetryAction = { [weak self] in
            
            guard let self = self else { return }
            self.tryToGetUserListFromOffline()
        }
        afterGainConnectivity = retryGainConnectionAction
        afterLostConnectivity = retryLossConnectionAction
    }
    
    override func loadView() {
        
        view = sceneView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tryToGetUserListFromOffline()
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
    
    private func tryToGetUserListFromRestCall() {
        
        sceneView.showSpinner()
        userListViewModel?.getAllUserList()
    }
    
    private func tryToGetUserListFromOffline() {
        
        sceneView.showSpinner()
        userListViewModel?.getAllUserListFromCoreData()
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

