//
//  TableHighlightAndSelectPresenter.swift
//  Example
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation
import Source

protocol TableHighlightAndSelectViewOutput: TableViewPresenterProtocol {
    // Add presenter properties which will use by view
}

final class TableHighlightAndSelectPresenter: NSObject {
    
    // MARK: Dependency properties
    private unowned let view: TableHighlightAndSelectViewInput
    
    // MARK: Lifecycle
    init(view: TableHighlightAndSelectViewInput) {
        self.view = view
    }
    
}

// MARK: - TableHighlightAndSelectViewOutput
extension TableHighlightAndSelectPresenter: TableHighlightAndSelectViewOutput {
    
    // MARK: TableViewPresenterProtocol
    var tableSections: Int {
        return 1
    }
    
    func tableRows(for section: Int) -> Int {
        return 100
    }
    
    func tableRowIdentifier(for indexPath: IndexPath) -> String {
        return TableHightlightAndSelectTableViewCell.viewIdentifier
    }
    
    func tableRowHeight(for indexPath: IndexPath) -> TableViewRowHeight {
        return .fixed(44)
    }
    
    func tableRowModel(for indexPath: IndexPath) -> Any? {
        let title = "Row: \(indexPath.row)"
        return TableHightlightAndSelectTableViewCell.Model(title: title)
    }
    
    func tableRowDidSelect(at indexPath: IndexPath) {
        
    }
    
    
}
