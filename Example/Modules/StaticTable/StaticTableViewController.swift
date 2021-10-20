//
//  StaticTableViewController.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

protocol StaticTableViewInput: TableViewControllerProtocol {
    func showDynamicTableView()
    func showTableHighlightAndSelect()
    func showCollectionHighlightAndSelect()
}

final class StaticTableViewController: UIViewController {
    
    // MARK: Stored properties
    var output: StaticTableViewOutput!
    
    // MARK: Outlet properties
    private let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure view
        view.addSubview(tableView)
        // Configure table view
        configureTableView { (tableView) in
            tableView.register(StaticTableViewCell.self, forCellReuseIdentifier: "StaticTableViewCell")

        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Resize table view
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
    
    func showTableHighlightAndSelect() {
        let viewController = ModuleFabric.createTableHighlightAndSelectModule()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showCollectionHighlightAndSelect() {
        let viewController = ModuleFabric.createCollectionHighlightAndSelectModule()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
