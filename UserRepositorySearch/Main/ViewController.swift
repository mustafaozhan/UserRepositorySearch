//
//  ViewController.swift
//  UserRepositorySearch
//
//  Created by Mustafa Ozhan on 15/05/2019.
//  Copyright © 2019 Mustafa Ozhan. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar : UISearchBar { return searchController.searchBar }
    
    var viewModel = ViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        viewModel.data
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { _ , repository, cell in
                cell.textLabel?.text = repository.repoName
                cell.detailTextLabel?.text = repository.repoUrl
            }.disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        viewModel.data.asDriver()
            .map { "\($0.count) Repositories" }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.text = "mustafaozhan"
        searchBar.placeholder = "Enter GitHub Username"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
}

