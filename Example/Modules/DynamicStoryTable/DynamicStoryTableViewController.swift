//
//  DynamicStoryTableViewController.swift
//  AirCollection
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
        
        view.addSubview(tableView)
        
        tableView.register(DynamicUserTableViewCell.self, forCellReuseIdentifier: "DynamicUserTableViewCell")
        tableView.register(DynamicStoryTableViewCell.self, forCellReuseIdentifier: "DynamicStoryTableViewCell")
        configureTableView(tableView, with: output)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}

// MARK: - DynamicStoryTableViewInput
extension DynamicStoryTableViewController: DynamicStoryTableViewInput {
    
    // MARK: TextFieldControllerProtocol
    var textFieldPresenter: TextFieldPresenterProtocol {
        return output
    }
    
    // MARK: TextViewControllerProtocol
    var textViewPresenter: TextViewPresenterProtocol {
        return output
    }
    
}
