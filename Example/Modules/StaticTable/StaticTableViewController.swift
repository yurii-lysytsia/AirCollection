//
//  StaticTableViewController.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

protocol StaticTableViewInput: TableViewControllerProtocol {
    func showDynamicTableView()
    func showCollectionHighlightAndSelect()
}

final class StaticTableViewController: UIViewController {
    
    // MARK: Stored properties
    var output: StaticTableViewOutput!
    
    // MARK: Outlet properties
    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        
        self.configureTableView { (tableView) in
            tableView.register(StaticTableViewCell.self)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
        
    }
    
}

// MARK: - StaticTableViewInput
extension StaticTableViewController: StaticTableViewInput {
    
    var tableViewSource: UITableView {
        return self.tableView
    }
    
    var tableViewPresenter: TableViewPresenterProtocol {
        return self.output
    }

    func showDynamicTableView() {
        let viewController = ModuleFabric.createDynamicTableModule()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showCollectionHighlightAndSelect() {
        let viewController = ModuleFabric.createCollectionHighlightAndSelectModule()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
