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
    private let sections: [Section] = [
        Section(identifier: .table, rows: [.dynamicTableView]),
        Section(identifier: .collection, rows: [.highlightAndSelect])
    ]
    
    // MARK: Dependency properties
    private unowned let view: StaticTableViewInput
    
    // MARK: Lifecycle
    init(view: StaticTableViewInput) {
        self.view = view
    }
    
    // MARK: Helpers
    private struct Section: Equatable {
        let identifier: Identifier
        let rows: [Row]
        
        enum Identifier: String {
            case table = "Table view"
            case collection = "Collection view"
        }
        
        enum Row: String, CaseIterable {
            case dynamicTableView = "Dynamic table view"
            case highlightAndSelect = "Highlight and select states"
        }
    }
    
    private func section(at sectionIndex: Int) -> Section {
        return self.sections[sectionIndex]
    }
    
    private func rows(at sectionIndex: Int) -> [Section.Row] {
        let section = self.section(at: sectionIndex)
        return section.rows
    }
    
    private func row(at indexPath: IndexPath) -> Section.Row {
        let rows = self.rows(at: indexPath.section)
        return rows[indexPath.row]
    }
    
}

// MARK: - HomeViewOutput
extension StaticTablePresenter: StaticTableViewOutput {
    
    var tableSections: Int {
        return self.sections.count
    }
    
    func tableRows(for section: Int) -> Int {
        let rows = self.rows(at: section)
        return rows.count
    }
    
    func tableRowIdentifier(for indexPath: IndexPath) -> String {
        return StaticTableViewCell.viewIdentifier
    }
    
    func tableRowHeight(for indexPath: IndexPath) -> TableViewRowHeight {
        return .fixed(44)
    }
    
    func tableRowModel(for indexPath: IndexPath) -> Any? {
        let row = self.row(at: indexPath)
        return StaticTableViewCell.Model(title: row.rawValue)
    }
    
    func tableRowDidSelect(at indexPath: IndexPath) {
        self.view.deselectTableViewRow(at: indexPath, animated: true)
        
        let section = self.section(at: indexPath.section)
        switch section.identifier {
        case .table:
            switch section.rows[indexPath.row] {
            case .dynamicTableView:
                self.view.showDynamicTableView()
            case .highlightAndSelect:
                return
            }
            
        case .collection:
            switch section.rows[indexPath.row] {
            case .dynamicTableView:
                return
            case .highlightAndSelect:
            self.view.showCollectionHighlightAndSelect()
            }
        }
    }
    
}
