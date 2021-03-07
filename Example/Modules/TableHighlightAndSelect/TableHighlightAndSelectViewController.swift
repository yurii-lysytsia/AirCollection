//
//  TableHighlightAndSelectViewController.swift
//  AirCollection
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
        
        view.addSubview(tableView)
        
        tableView.frame = self.view.bounds
        tableView.allowsMultipleSelection = true
        tableView.register(TableHightlightAndSelectTableViewCell.self)
        configureTableView(tableView, with: output)
        
        output.didLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}

// MARK: - TableHighlightAndSelectViewInput
extension TableHighlightAndSelectViewController: TableHighlightAndSelectViewInput {
    
}
