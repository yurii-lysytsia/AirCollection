//
//  TableHighlightAndSelectViewController.swift
//  Example
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

protocol TableHighlightAndSelectViewInput: TableViewControllerProtocol {
    // Add public methods which will use by presenter
}

final class TableHighlightAndSelectViewController: UIViewController {
    
    // MARK: Stored properties
    var output: TableHighlightAndSelectViewOutput!
    
    // MARK: Outlet properties
    private let tableView = UITableView(frame: .zero, style: .plain)
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        
        self.tableView.frame = self.view.bounds
        self.tableView.allowsMultipleSelection = true
        self.configureTableView { (tableView) in
            tableView.register(TableHightlightAndSelectTableViewCell.self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
    // MARK: Functions
    
    // MARK: Helpers
    
}

// MARK: - TableHighlightAndSelectViewInput
extension TableHighlightAndSelectViewController: TableHighlightAndSelectViewInput {
    
    // MARK: TableViewControllerProtocol
    var tableViewSource: UITableView {
        return self.tableView
    }
    
    var tableViewPresenter: TableViewPresenterProtocol {
        return self.output
    }
    
}
