//
//  DynamicTableViewController.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

protocol DynamicTableViewInput: TableViewControllerProtocol {
    func showAlert(title: String, message: String?)
    func showUser(_ user: User)
}

final class DynamicTableViewController: UIViewController {
    
    // MARK: Stored properties
    var output: DynamicTableViewOutput!
    
    // MARK: Outlet properties
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        
        self.configureTableView { (tableView) in
            tableView.register(DynamicTitleDescriptionTableViewCell.self)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadTableView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
        
    }
    
}

// MARK: - StaticTableViewInput
extension DynamicTableViewController: DynamicTableViewInput {
    
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showUser(_ user: User) {
        let view = ModuleFabric.createDynamicUserTableModule(user: user)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    var tableViewSource: UITableView {
        return self.tableView
    }
    
    var tableViewPresenter: TableViewPresenterProtocol {
        return self.output
    }
    
}

