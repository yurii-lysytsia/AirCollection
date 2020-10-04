//
//  HomeViewController.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

protocol HomeViewInput: TableViewControllerProtocol {
    // Add public methods which will use by presenter
}

final class HomeViewController: UIViewController {
    
    // MARK: Stored properties
    var output: HomeViewOutput!
    
    // MARK: Outlet properties
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView { (tableView) in
            tableView.register(HomeTableViewCell.self)
        }
        
        self.output.didLoad()
    }
    
    // MARK: Functions
    
    // MARK: Helpers
    
}

// MARK: - HomeViewInput
extension HomeViewController: HomeViewInput {
    
    var tableViewSource: UITableView {
        return self.tableView
    }
    
    var tableViewPresenter: TableViewPresenterProtocol {
        return self.output
    }
    
}
