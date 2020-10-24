//
//  DynamicUserTableViewController.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

protocol DynamicUserTableViewInput: TableViewControllerProtocol, TextFieldControllerProtocol, TextFieldDatePickerControllerProtocol, TextFieldPickerViewControllerProtocol {
    
}

final class DynamicUserTableViewController: UIViewController {
    
    // MARK: Stored properties
    var output: DynamicUserTableViewOutput!
    
    // MARK: Outlet properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        
        self.configureTableView { (tableView) in
            tableView.register(DynamicUserTableViewCell.self)
            tableView.register(DynamicUserFooterView.self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
}

// MARK: - DynamicUserTableViewInput
extension DynamicUserTableViewController: DynamicUserTableViewInput {
    
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
    
    // MARK: TextFieldDatePickerControllerProtocol
    var datePickerPresenter: DatePickerPresenterProtocol {
        return self.output
    }

    // MARK: TextFieldPickerViewControllerProtocol
    var pickerViewPresenter: PickerViewPresenterProtocol {
        return self.output
    }
    
}
