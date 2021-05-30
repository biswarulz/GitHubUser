//
//  UserListViewController.swift
//  GitHubUser
//
//  Created by Biswajyoti Sahu on 26/05/21.
//

import UIKit

protocol UserListDisplayLogic: AnyObject {
    
    func displayUserList(_ viewData: UserListViewData)
    func displayErrorForUserList()
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
        let viewData = UserListViewData(userList: [], showOfflineData: false)
        dataSource = UserListDataSource(viewData)
        sceneView.tableView.dataSource = dataSource
        sceneView.tableView.delegate = self
        
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
        
        tryToGetUserListFromRestCall()

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
        
        userListViewModel?.getAllUserListFromCoreData()
    }
}

extension UserListViewController: UserListDisplayLogic {
    
    /// Gets userlist and populate the data
    /// - Parameter viewData: view data for user list
    func displayUserList(_ viewData: UserListViewData) {
        
        if !viewData.showOfflineData {
            
            sceneView.hideSpinner()
        }
        dataSource?.userListViewData = viewData
        sceneView.tableView.reloadData()
    }
    
    /// Displays error alert
    func displayErrorForUserList() {
        
        sceneView.hideSpinner()
        let alert = UIAlertController(title: Identifiers.errorTitle, message: Identifiers.errorDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Identifiers.okTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

// MARK: - Search Result delegate

extension UserListViewController: UISearchResultsUpdating {
    
    /// Gets called when typing in the search textfield
    /// - Parameter searchController: search controller
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            isUserSearched = true
            userListViewModel?.fetchFilteredListBasedOnSearch(text)
        }
    }
}

// MARK: - Search delegate

extension UserListViewController: UISearchControllerDelegate {
    
    /// Gets called when cancelling search
    /// - Parameter searchController: search controller
    func didDismissSearchController(_ searchController: UISearchController) {
        
        isUserSearched = false
    }
}

