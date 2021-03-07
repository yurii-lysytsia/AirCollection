//
//  DynamicUserTableViewController.swift
//  AirCollection
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
        
        view.addSubview(tableView)
        
        tableView.register(DynamicUserTableViewCell.self)
        tableView.register(DynamicUserFooterView.self)
        configureTableView(tableView, with: output)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}

// MARK: - DynamicUserTableViewInput
extension DynamicUserTableViewController: DynamicUserTableViewInput {
    
    // MARK: TextFieldControllerProtocol
    var textFieldPresenter: TextFieldPresenterProtocol {
        return output
    }
    
    // MARK: TextFieldDatePickerControllerProtocol
    var datePickerPresenter: DatePickerPresenterProtocol {
        return output
    }

    // MARK: TextFieldPickerViewControllerProtocol
    var pickerViewPresenter: PickerViewPresenterProtocol {
        return output
    }
    
}
