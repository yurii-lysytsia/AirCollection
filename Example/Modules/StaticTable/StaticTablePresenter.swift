//
//  StaticTablePresenter.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation
import Source

protocol StaticTableViewOutput: TableViewPresenterProtocol {

}

final class StaticTablePresenter {
    
    // MARK: Stored properties
    private let rows: [[Row]] = [
        [.dynamicTableView]
    ]
    
    // MARK: Dependency properties
    private unowned let view: StaticTableViewInput
    
    // MARK: Lifecycle
    init(view: StaticTableViewInput) {
        self.view = view
    }
    
    // MARK: Helpers
    private enum Row: String, CaseIterable {
        case dynamicTableView = "Dynamic table view"
    }
    
}

// MARK: - HomeViewOutput
extension StaticTablePresenter: StaticTableViewOutput {
    
    var tableSections: Int {
        return self.rows.count
    }
    
    func tableRows(for section: Int) -> Int {
        return self.rows[section].count
    }
    
    func tableRowIdentifier(for indexPath: IndexPath) -> String {
        return StaticTableViewCell.viewIdentifier
    }
    
    func tableRowHeight(for indexPath: IndexPath) -> TableViewRowHeight {
        return .fixed(44)
    }
    
    func tableRowModel(for indexPath: IndexPath) -> Any? {
        let row = self.rows[indexPath.section][indexPath.row]
        return StaticTableViewCell.Model(title: row.rawValue)
    }
    
    func tableRowDidSelect(at indexPath: IndexPath) {
        self.view.deselectTableViewRow(at: indexPath, animated: true)
        switch self.rows[indexPath.section][indexPath.row] {
        case .dynamicTableView:
            self.view.showDynamicViewController()
        }
    }
    
}
