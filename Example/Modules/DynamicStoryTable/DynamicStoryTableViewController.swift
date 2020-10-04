//
//  DynamicStoryTableViewController.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

protocol DynamicStoryTableViewInput: TableViewControllerProtocol, TextFieldControllerProtocol, TextViewControllerProtocol {
    
}

final class DynamicStoryTableViewController: UIViewController {
    
    // MARK: Stored properties
    var output: DynamicStoryTableViewOutput!
    
    // MARK: Outlet properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        
        self.configureTableView { (tableView) in
            tableView.register(DynamicUserTableViewCell.self)
            tableView.register(DynamicStoryTableViewCell.self)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
}

// MARK: - DynamicStoryTableViewInput
extension DynamicStoryTableViewController: DynamicStoryTableViewInput {
    
    // MARK: TableViewControllerProtocol
    var tableViewSource: UITableView {
        return self.tableView
    }
    
    var tableViewPresenter: TableViewPresenterProtocol {
        return self.output
    }
    
    // MARK: TextFieldControllerProtocol
    var textFieldPresenter: TextFieldPresenterProtocol {
        return self.output
    }
    
    // MARK: TextViewControllerProtocol
    var textViewPresenter: TextViewPresenterProtocol {
        return self.output
    }
    
}
