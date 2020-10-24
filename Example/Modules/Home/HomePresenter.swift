//
//  StaticTablePresenter.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation
import Source

protocol HomeViewOutput: TableViewPresenterProtocol {

}

final class StaticTablePresenter {
    
    // MARK: Stored properties
    private let rows: [[Row]] = [
        [.nib]
    ]
    
    // MARK: Dependency properties
    private unowned let view: HomeViewInput
    
    // MARK: Lifecycle
    init(view: HomeViewInput) {
        self.view = view
    }
    
    // MARK: Functions
    
    // MARK: Helpers
    private enum Row: String, CaseIterable {
        case nib = "Load UIView from Nib"
    }
    
}

// MARK: - HomeViewOutput
extension StaticTablePresenter: HomeViewOutput {
    
    var tableSections: Int {
        return self.rows.count
    }
    
    func tableRows(for section: Int) -> Int {
        return self.rows[section].count
    }
    
    func tableRowIdentifier(for indexPath: IndexPath) -> String {
        return HomeTableViewCell.viewIdentifier
    }
    
    func tableRowHeight(for indexPath: IndexPath) -> TableViewRowHeight {
        return .fixed(44)
    }
    
    func tableRowModel(for indexPath: IndexPath) -> Any? {
        let row = self.rows[indexPath.section][indexPath.row]
        return HomeTableViewCell.Model(title: row.rawValue)
    }
    
    func tableRowDidSelect(at indexPath: IndexPath) {
        self.view.deselectTableViewRow(at: indexPath, animated: true)
    }
    
}
