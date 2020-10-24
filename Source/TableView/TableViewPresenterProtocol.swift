//
//  TableViewPresenterProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 27.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct Foundation.IndexPath
import class UIKit.UITableView
import class UIKit.UISwipeActionsConfiguration

public protocol TableViewPresenterProtocol: class {
    
    /// Number of sections in the table view
    var tableSections: Int { get }
    
    /// Number of rows in a given section of a table view
    func tableRows(for section: Int) -> Int
    
    /// Cell identifier to insert in a particular location of the table view for index path
    func tableRowIdentifier(for indexPath: IndexPath) -> String
    
    /// Height to use for a row in a specified location of the table view for index path
    func tableRowHeight(for indexPath: IndexPath) -> TableViewRowHeight
    
    /// Model to use for a row in a specified location of the table view for index path
    func tableRowModel(for indexPath: IndexPath) -> Any?
    
    /// Tells when the specified row is now selected
    func tableRowDidSelect(at indexPath: IndexPath)
    
    /// Tells when the specified row is now deselected
    func tableRowDidDeselect(at indexPath: IndexPath)
    
    /// Returns the swipe actions to display on the leading edge of the row
    func tableLeadingSwipeActionsConfiguration(for indexPath: IndexPath) -> UISwipeActionsConfiguration?
    
    /// Returns the swipe actions to display on the trailing edge of the row
    func tableTrailingSwipeActionsConfiguration(for indexPath: IndexPath) -> UISwipeActionsConfiguration?
    
    /// View identifier to display in the header of the specified section of the table view
    func tableHeaderIdentifier(for section: Int) -> String?
    
    /// Height to use for the header of a particular section of the table view
    func tableHeaderHeight(for section: Int) -> TableViewHeaderFooterViewHeight
    
    /// Model to use for the header of a particular section of the table view
    func tableHeaderModel(for section: Int) -> Any?
    
    /// View identifier to display in the footer of the specified section of the table view
    func tableFooterIdentifier(for section: Int) -> String?
    
    /// Height to use for the footer of a particular section of the table view
    func tableFooterHeight(for section: Int) -> TableViewHeaderFooterViewHeight
    
    /// Model to use for the footer of a particular section of the table view
    func tableFooterModel(for section: Int) -> Any?
    
    /// Return the titles for the sections of a table view
    func tableSectionIndexTitles(for tableView: UITableView) -> [String]?
    
}

public extension TableViewPresenterProtocol {
    
    // MARK: Row
    func tableRowDidSelect(at indexPath: IndexPath) {
        
    }
    
    func tableRowDidDeselect(at indexPath: IndexPath) {
        
    }
    
    func tableLeadingSwipeActionsConfiguration(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableTrailingSwipeActionsConfiguration(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    // MARK: Header
    func tableHeaderIdentifier(for section: Int) -> String? {
        return nil
    }
    
    func tableHeaderHeight(for section: Int) -> TableViewHeaderFooterViewHeight {
        return self.tableHeaderIdentifier(for: section) == nil ? .none : .flexible
    }
    
    func tableHeaderModel(for section: Int) -> Any? {
        return nil
    }
    
    // MARK: Footer
    func tableFooterIdentifier(for section: Int) -> String? {
        return nil
    }
    
    func tableFooterHeight(for section: Int) -> TableViewHeaderFooterViewHeight {
        return self.tableFooterIdentifier(for: section) == nil ? .none : .flexible
    }
    
    func tableFooterModel(for section: Int) -> Any? {
        return nil
    }
    
    // MARK: Section titles
    func tableSectionIndexTitles(for tableView: UITableView) -> [String]? {
        return nil
    }
    
}

