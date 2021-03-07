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
        tableView.tableHeaderView = StaticTableHeaderView()
        tableView.tableFooterView = StaticTableFooterView.loadFromNib()
        tableView.register(StaticTableViewCell.self)
        tableView.register(StaticTableSectionHeaderView.self)
        tableView.register(StaticTableSectionFooterView.self)
        configureTableView(tableView, with: output)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Resize table view
        self.tableView.frame = self.view.bounds
        // Resize table view table header view
        self.tableView.fitHeaderTableViewHeight()
        // Resize table view table footer view
        self.tableView.fitFooterViewHeight()
    }
    
}

// MARK: - StaticTableViewInput
extension StaticTableViewController: StaticTableViewInput {
    
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
