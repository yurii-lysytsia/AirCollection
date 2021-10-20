//
//  TableViewControllerProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 27.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct Foundation.IndexPath
import struct Foundation.IndexSet
import struct CoreGraphics.CGPoint
import class UIKit.UIView
import class UIKit.UITableView
import class UIKit.UITableViewCell
import protocol UIKit.UIScrollViewDelegate
import func Foundation.objc_getAssociatedObject
import func Foundation.objc_setAssociatedObject

public protocol TableViewControllerProtocol: AnyObject {
    
    /// Configure `UITableViewDataSource` and `UITableViewDelegate` for specific table view and presenter. Also automatically add `TableViewDelegate` to current view controller if implemented.
    /// - Parameter tableView: Instanse of the table view source that will be use by presenter.
    /// - Parameter presenter: Instanse of the table view presenter.
    func configureTableView(_ tableView: UITableView, with presenter: TableViewPresenterProtocol)
    
    /// Reloads the rows and sections of the table view
    func reloadTableView()
    
    /// Begin update table view data and table view rows
    /// - Parameters:
    ///   - updates: Use this block to call update methods for table view. You should call `reloadTableViewRows(at:with:)`, `deleteTableViewRows(at:with:)`, `insertTableViewRows(at:with:)`
    ///   - completion: A completion handler block to execute when all of the operations are finished
    func updateTableView(updates: () -> Void, completion: ((Bool) -> Void)?)
    
    /// Update table view rows for specific rows and section.
    /// - Parameters:
    ///   - deletions: Rows that will be delete
    ///   - insertions: Rows that will be insert
    ///   - modifications: Rows that will be reload
    ///   - section: Section where this rows will updated. For exaple for `deletions = [0]` and `section = 1` will removed row at `IndexPath(row: 0, section: 1)`
    func updateTableView(deletions: [Int], insertions: [Int], modifications: [Int], forSection section: Int, with animation: UITableView.RowAnimation, completion: ((Bool) -> Void)?)
    
    /// Reloads the specified rows using a given animation effect.
    func reloadTableViewRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    
    /// Deletes the rows specified by an array of index paths, with an option to animate the deletion
    func deleteTableViewRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    
    /// Inserts rows in the table view at the locations identified by an array of index paths, with an option to animate the insertion
    func insertTableViewRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    
    /// Moves the row at a specified location to a destination location
    func moveTableViewRow(at indexPath: IndexPath, to newIndexPath: IndexPath)
    
    /// Selects a row in the table view identified by index path, optionally scrolling the row to a location in the table view
    func selectTableViewRow(at indexPath: IndexPath, animated: Bool, scrollPosition: UITableView.ScrollPosition)
    
    /// Deselects a given row identified by index path, with an option to animate the deselection.
    func deselectTableViewRow(at indexPath: IndexPath, animated: Bool)
    
    /// Make a row input view in the table view identified by index path the first responder in its window at.
    func becomeTableViewRowFirstResponder(at indexPath: IndexPath)
    
    /// Notifies a row input view in the table view identified by index path that it has been asked to relinquish its status as first responder in its window.
    func resignTableViewRowFirstResponder(at indexPath: IndexPath)
    
    /// Reloads the specified sections using a given animation effect
    func reloadTableViewSections(_ sections: [Int], with animation: UITableView.RowAnimation)
    
    /// Deletes one or more sections in the table view, with an option to animate the deletion
    func deleteTableViewSections(_ sections: [Int], with animation: UITableView.RowAnimation)
    
    /// Inserts one or more sections in the table view, with an option to animate the insertion
    func insertTableViewSections(_ sections: [Int], with animation: UITableView.RowAnimation)
    
    /// Moves a section to a new location in the table view
    func moveTableViewSection(from section: Int, to newSection: Int)
    
    /// Scrolls through the table view until a row identified by index path is at a particular location on the screen
    func scrollTableViewToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool)
    
    /// Scrolls the table view so that the selected row nearest to a specified position in the table view is at that position
    func scrollTableViewToNearestSelectedRow(at scrollPosition: UITableView.ScrollPosition, animated: Bool)
    
    /// Call `configureCell(_:for)` method for cell at specified index path of the table view
    func reconfigureTableViewCellForRow(at indexPath: IndexPath)
    
    /// Returns an index path identifying the subview
    func indexPathForRow(with view: UIView) -> IndexPath?
    
}

public extension TableViewControllerProtocol {
    
    // MARK: Configure
    
    func configureTableView(_ tableView: UITableView, with presenter: TableViewPresenterProtocol) {
        tableViewSource = tableView
        tableViewPresenter = presenter
        tableViewSource.dataSource = tableViewData
        tableViewSource.delegate = tableViewData
        if let delegate = self as? TableViewDelegate {
            // Forward available table view delegates to current view controller.
            tableViewData.tableViewDelegate = delegate
        }
    }
    
    // MARK: Reload
    
    func reloadTableView() {
        tableViewData.reloadAll()
        tableViewSource.reloadData()
    }
    
    // MARK: Update
    
    func updateTableView(updates: () -> Void, completion: ((Bool) -> Void)?) {
        tableViewSource.performBatchUpdates({
            updates()
        }, completion: { (finished) in
            completion?(finished)
        })
    }
    
    func updateTableView(updates: () -> Void) {
        updateTableView(updates: updates, completion: nil)
    }
    
    func updateTableView(deletions: [Int], insertions: [Int], modifications: [Int], forSection section: Int, with animation: UITableView.RowAnimation, completion: ((Bool) -> Void)?) {
        if deletions.isEmpty, insertions.isEmpty, modifications.isEmpty {
            assertionFailure("\(#function) deletions, insertions or modifications can't be empty. One of them must contains element")
            return
        }
        updateTableView(updates: {
            if !deletions.isEmpty {
                let indexPaths = deletions.map { IndexPath(row: $0, section: section) }
                deleteTableViewRows(at: indexPaths, with: animation)
            }
            if !insertions.isEmpty {
                let indexPaths = insertions.map { IndexPath(row: $0, section: section) }
                insertTableViewRows(at: indexPaths, with: animation)
            }
            if !modifications.isEmpty {
                let indexPaths = modifications.map { IndexPath(row: $0, section: section) }
                reloadTableViewRows(at: indexPaths, with: animation)
            }
        }, completion: completion)
    }
    
    func updateTableView(deletions: [Int], insertions: [Int], modifications: [Int], forSection section: Int, completion: ((Bool) -> Void)? = nil) {
        updateTableView(deletions: deletions, insertions: insertions, modifications: modifications, forSection: section, with: .automatic, completion: completion)
    }
    
    // MARK: Rows
    func reloadTableViewRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableViewData.reloadRows(at: indexPaths)
        tableViewSource.reloadRows(at: indexPaths, with: animation)
    }
    
    func reloadTableViewRows(at indexPaths: [IndexPath]) {
        reloadTableViewRows(at: indexPaths, with: .automatic)
    }
    
    func deleteTableViewRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableViewData.removeRows(at: indexPaths)
        tableViewSource.deleteRows(at: indexPaths, with: animation)
    }
    
    func deleteTableViewRows(at indexPaths: [IndexPath]) {
        deleteTableViewRows(at: indexPaths, with: .automatic)
    }
    
    func insertTableViewRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableViewData.insertRows(at: indexPaths)
        tableViewSource.insertRows(at: indexPaths, with: animation)
    }
    
    func insertTableViewRows(at indexPaths: [IndexPath]) {
        insertTableViewRows(at: indexPaths, with: .automatic)
    }
    
    func moveTableViewRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        tableViewData.moveRow(from: indexPath, to: newIndexPath)
        tableViewSource.moveRow(at: indexPath, to: newIndexPath)
    }
    
    func selectTableViewRow(at indexPath: IndexPath, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        tableViewSource.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }
    
    func deselectTableViewRow(at indexPath: IndexPath, animated: Bool) {
        tableViewSource.deselectRow(at: indexPath, animated: animated)
    }
    
    func becomeTableViewRowFirstResponder(at indexPath: IndexPath) {
        guard let cell = tableViewSource.cellForRow(at: indexPath) as? InputConfigurableView else {
            return
        }
        cell.becomeInputViewFirstResponder()
    }
    
    func resignTableViewRowFirstResponder(at indexPath: IndexPath) {
        guard let cell = tableViewSource.cellForRow(at: indexPath) as? InputConfigurableView else {
            return
        }
        cell.resignInputViewFirstResponder()
    }
    
    // MARK: Sections
    func reloadTableViewSections(_ sections: [Int], with animation: UITableView.RowAnimation) {
        tableViewData.reloadSections(sections)
        let indexSet = IndexSet(sections)
        tableViewSource.reloadSections(indexSet, with: animation)
    }
    
    func reloadTableViewSection(_ section: Int) {
        reloadTableViewSections([section], with: .automatic)
    }
    
    func deleteTableViewSections(_ sections: [Int], with animation: UITableView.RowAnimation) {
        tableViewData.removeSections(sections)
        let indexSet = IndexSet(sections)
        tableViewSource.deleteSections(indexSet, with: animation)
    }
    
    func deleteTableViewSections(_ sections: [Int]) {
        deleteTableViewSections(sections, with: .automatic)
    }
    
    func insertTableViewSections(_ sections: [Int], with animation: UITableView.RowAnimation) {
        tableViewData.insertSections(sections)
        let indexSet = IndexSet(sections)
        tableViewSource.insertSections(indexSet, with: animation)
    }
    
    func insertTableViewSections(_ sections: [Int]) {
        insertTableViewSections(sections, with: .automatic)
    }
    
    func moveTableViewSection(from section: Int, to newSection: Int) {
        tableViewData.moveSection(from: section, to: newSection)
        tableViewSource.moveSection(section, toSection: newSection)
    }

    // MARK: Scroll
    func scrollTableViewToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        tableViewSource.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    func scrollTableViewToNearestSelectedRow(at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        tableViewSource.scrollToNearestSelectedRow(at: scrollPosition, animated: animated)
    }
    
    // MARK: Configuration
    func reconfigureTableViewCellForRow(at indexPath: IndexPath) {
        guard let cell = tableViewSource.cellForRow(at: indexPath) else {
            return
        }
        tableViewData.configureCell(cell, for: indexPath)
    }

    func indexPathForRow(with view: UIView) -> IndexPath? {
        let rect = view.convert(view.bounds, to: tableViewSource)
        return tableViewSource.indexPathsForRows(in: rect)?.first
    }
    
}

// MARK: - TableViewData

fileprivate enum TableViewControllerProtocolAssociatedKey {
    static var tableViewSource: String = "TableViewControllerProtocol.tableViewSource"
    static var tableViewPresenter: String = "TableViewControllerProtocol.tableViewPresenter"
    static var tableViewData: String = "TableViewControllerProtocol.tableViewData"
}

fileprivate extension TableViewControllerProtocol {
    
    /// Get associated `UITableView` object with this table view controller.
    var tableViewSource: UITableView {
        get {
            guard let tableView = objc_getAssociatedObject(self, &TableViewControllerProtocolAssociatedKey.tableViewSource) as? UITableView else {
                assertionFailure("Table view haven't set for view controller. Please use `configureTableView(:,with:)` before use other `TableViewControllerProtocol` methods")
                return UITableView(frame: .zero, style: .plain)
            }
            return tableView
        }
        set {
            objc_setAssociatedObject(self, &TableViewControllerProtocolAssociatedKey.tableViewSource, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// Get associated `TableViewPresenterProtocol` object with this table view controller
    var tableViewPresenter: TableViewPresenterProtocol {
        get {
            guard let presenter = objc_getAssociatedObject(self, &TableViewControllerProtocolAssociatedKey.tableViewPresenter) as? TableViewPresenterProtocol else {
                fatalError("Table view presenter haven't set for view controller. Please use `configureTableView(:,with:)` before use other `TableViewControllerProtocol` methods")
            }
            return presenter
        }
        set {
            objc_setAssociatedObject(self, &TableViewControllerProtocolAssociatedKey.tableViewPresenter, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// Get associated `TableViewData` object with this table view controller. Will create new one if associated object is nil
    var tableViewData: TableViewData {
        if let data = objc_getAssociatedObject(self, &TableViewControllerProtocolAssociatedKey.tableViewData) as? TableViewData {
            return data
        } else {
            // Create new `tableViewData` model
            let tableViewData = TableViewData(input: self, output: tableViewPresenter)
            objc_setAssociatedObject(self, &TableViewControllerProtocolAssociatedKey.tableViewData, tableViewData, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return tableViewData
        }
    }
    
}
