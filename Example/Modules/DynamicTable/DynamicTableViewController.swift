//
//  DynamicTableViewController.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

protocol DynamicTableViewInput: TableViewControllerProtocol, ScrollRefreshControllerProtocol {
    func showUser(_ user: User)
    func showStory(_ story: Story)
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
        
        let scrollRefreshConfiguration = ScrollRefreshConfiguration(tintColor: UIColor.systemBlue, attributedTitle: nil)
        self.configureScrollRefresh(for: self.tableView, using: self.output, configuration: scrollRefreshConfiguration)
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
    
    func showUser(_ user: User) {
        let view = ModuleFabric.createDynamicUserTableModule(user: user)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func showStory(_ story: Story) {
        let view = ModuleFabric.createDynamicStoryTableModule(story: story)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    // MARK: TableViewControllerProtocol
    var tableViewSource: UITableView {
        return self.tableView
    }
    
    var tableViewPresenter: TableViewPresenterProtocol {
        return self.output
    }

    // MARK: ScrollRefreshControllerProtocol
    
}
