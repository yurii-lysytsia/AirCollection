//
//  DynamicUserTablePresenter.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation
import Source

protocol DynamicUserTableViewOutput: TableViewPresenterProtocol, TextFieldPresenterProtocol {
    // Add presenter properties which will use by view
}

final class DynamicUserTablePresenter: NSObject {
    
    // MARK: Stored properties
    private let rows: [[Row]] = [
        [.name]
    ]
        
    // MARK: Dependency properties
    private unowned let user: User
    private unowned let view: DynamicUserTableViewInput
    
    // MARK: Lifecycle
    init(user: User, view: DynamicUserTableViewInput) {
        self.user = user
        self.view = view
    }
    
    // MARK: Helpers
    private enum Row: Int, CaseIterable {
        case name
    }
    
}

// MARK: - DynamicUserTableViewOutput
extension DynamicUserTablePresenter: DynamicUserTableViewOutput {
    
    // MARK: TableViewPresenterProtocol
    var tableSections: Int {
        return self.rows.count
    }
    
    func tableRows(for section: Int) -> Int {
        return self.rows[section].count
    }
    
    func tableRowIdentifier(for indexPath: IndexPath) -> String {
        return DynamicUserTableViewCell.viewIdentifier
    }
    
    func tableRowHeight(for indexPath: IndexPath) -> TableViewRowHeight {
        return .flexible
    }
    
    func tableRowModel(for indexPath: IndexPath) -> Any? {
        let configuration = TextFieldConfiguration(delegate: self.view)
        return DynamicUserTableViewCell.Model(title: "Username", text: self.user.name, textInputConfiguration: configuration)
    }
    
    func tableRowDidSelect(at indexPath: IndexPath) {
        self.view.deselectTableViewRow(at: indexPath, animated: true)
    }
    
    // MARK: TextFieldPresenterProtocol
    func textFieldTextDidChanged(_ text: String?, at indexPath: IndexPath) {
        switch self.rows[indexPath.section][indexPath.row] {
        case .name:
            self.user.name = text ?? ""
        }
    }
}
