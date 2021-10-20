//
//  DynamicTableViewController.swift
//  AirCollection
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
        
        view.addSubview(tableView)
        
        tableView.register(DynamicTitleDescriptionTableViewCell.self, forCellReuseIdentifier: "DynamicTitleDescriptionTableViewCell")
        configureTableView(tableView, with: output)
        
        let scrollRefreshConfiguration = ScrollRefreshConfiguration(tintColor: UIColor.systemBlue, attributedTitle: nil)
        configureScrollRefresh(for: tableView, using: output, configuration: scrollRefreshConfiguration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = self.view.bounds
    }
    
}

// MARK: - StaticTableViewInput
extension DynamicTableViewController: DynamicTableViewInput {
    
    func showUser(_ user: User) {
        let view = ModuleFabric.createDynamicUserTableModule(user: user)
        navigationController?.pushViewController(view, animated: true)
    }
    
    func showStory(_ story: Story) {
        let view = ModuleFabric.createDynamicStoryTableModule(story: story)
        navigationController?.pushViewController(view, animated: true)
    }

    // MARK: ScrollRefreshControllerProtocol
    
}
