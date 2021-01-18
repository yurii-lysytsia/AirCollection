//
//  TableViewData.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 27.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct Foundation.IndexPath
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
import class Foundation.NSObject
import class UIKit.UIScrollView
import class UIKit.UITableView
import class UIKit.UITableViewCell
import class UIKit.UITableViewHeaderFooterView
import class UIKit.UISwipeActionsConfiguration
import class UIKit.UIView
import protocol UIKit.UITableViewDataSource
import protocol UIKit.UIScrollViewDelegate
import protocol UIKit.UITableViewDelegate

/// Data for building `UITableView` based on `UITableViewDataSource` and `UITableViewDelegate`
class TableViewData: NSObject {
    
    // MARK: Stored properties
    weak var tableViewDelegate: TableViewDelegate?
    
    /// Cached table view width when last row displayed
    private var preferredTableViewWidthForRow: CGFloat = 0
    
    /// Cached table view width when last header displayed
    private var preferredTableViewWidthForHeader: CGFloat = 0
    
    /// Cached table view width when last footer displayed
    private var preferredTableViewWidthForFooter: CGFloat = 0
    
    /// Array of sections (array of rows) with estimated sizes for table view row. First array is equal to `IndexPath.section`, second to `IndexPath.row`
    private var estimatedHeightsForRow = [[CGFloat]]()
    
    /// Array of sections with estimated sizes for table view header. Element of array is equal to `IndexPath.section`
    private var estimatedHeightsForHeader = [CGFloat]()
    
    /// Array of sections with estimated sizes for table view footer. Element of array is equal to `IndexPath.section`
    private var estimatedHeightsForFooter = [CGFloat]()
    
    // MARK: Dependency injection
    private unowned var input: TableViewControllerProtocol
    private unowned var output: TableViewPresenterProtocol
    
    // MARK: Initialize
    init(input: TableViewControllerProtocol, output: TableViewPresenterProtocol) {
        self.input = input
        self.output = output
    }
    
    // MARK: Reload
    
    /// Reload all (remove cache) table view data
    func reloadAll() {
        self.estimatedHeightsForRow.removeAll()
        self.estimatedHeightsForHeader.removeAll()
        self.estimatedHeightsForFooter.removeAll()
    }
    
    // MARK: Sections
    
    /// Reload (remove cache) for specific section of table view data
    func reloadSection(_ section: Int) {
        if self.estimatedHeightsForRow.indices.contains(section) {
            self.estimatedHeightsForRow[section].removeAll()
        }
        if self.estimatedHeightsForHeader.indices.contains(section) {
            self.estimatedHeightsForHeader[section] = UITableView.automaticDimension
        }
        if self.estimatedHeightsForFooter.indices.contains(section) {
            self.estimatedHeightsForFooter[section] = UITableView.automaticDimension
        }
    }
    
    /// Reload (remove cache) for specific sections of table view data. It's the same as `reloadSection(_:)` but for multiple sections
    func reloadSections(_ sections: [Int]) {
        sections.forEach { self.reloadSection($0) }
    }
    
    /// Remove cache for specific section of table view data
    func removeSections(_ sections: [Int]) {
        sections.sorted(by: >).forEach {
            self.estimatedHeightsForRow.remove(at: $0)
            self.estimatedHeightsForHeader.remove(at: $0)
            self.estimatedHeightsForFooter.remove(at: $0)
        }
    }
    
    /// Insert `UITableView.automaticDimension` cache for specific section of table view data
    func insertSections(_ sections: [Int]) {
        sections.sorted().forEach {
            self.estimatedHeightsForRow.insert([], at: $0)
            self.estimatedHeightsForHeader.insert(UITableView.automaticDimension, at: $0)
            self.estimatedHeightsForFooter.insert(UITableView.automaticDimension, at: $0)
        }
    }
    
    func moveSection(from section: Int, to newSection: Int) {
        self.removeSections([section])
        self.insertSections([section])
    }
    
    // MARK: Rows
    
    /// Reload (remove cache) for specific index path of table view data
    func reloadRow(at indexPath: IndexPath) {
        guard self.estimatedHeightsForRow.indices.contains(indexPath.section) else {
            return
        }
        guard self.estimatedHeightsForRow[indexPath.section].indices.contains(indexPath.row) else {
            return
        }
        self.estimatedHeightsForRow[indexPath.section][indexPath.row] = UITableView.automaticDimension
    }
    
    /// Reload (remove cache) for specific index paths of table view data. It's the same as `reloadRow(at:)` but for multiple index paths
    func reloadRows(at indexPaths: [IndexPath]) {
        indexPaths.forEach { self.reloadRow(at: $0) }
    }
    
    /// Remove cache for specific index path of table view data
    @discardableResult
    func removeRow(at indexPath: IndexPath) -> CGFloat? {
        guard self.estimatedHeightsForRow.indices.contains(indexPath.section) else {
            return nil
        }
        guard self.estimatedHeightsForRow[indexPath.section].indices.contains(indexPath.row) else {
            return nil
        }
        return self.estimatedHeightsForRow[indexPath.section].remove(at: indexPath.row)
    }
    
    /// Remove cache for specific index paths of table view data. It's the same as `removeRow(at:)` but for multiple index paths
    func removeRows(at indexPaths: [IndexPath]) {
        indexPaths.sorted(by: >).forEach { self.removeRow(at: $0) }
    }
    
    /// Insert with specific height or `UITableView.automaticDimension` (by default) cache for specific index path of table view data
    func insertRow(at indexPath: IndexPath, height: CGFloat = UITableView.automaticDimension) {
        guard self.estimatedHeightsForRow.indices.contains(indexPath.section) else {
            return
        }
        self.estimatedHeightsForRow[indexPath.section].insert(height, at: indexPath.row)
    }
    
    /// Insert `UITableView.automaticDimension` cache for specific index paths of table view data. It's the same as `insertRow(at:)` but for multiple index paths
    func insertRows(at indexPaths: [IndexPath]) {
        indexPaths.sorted().forEach { self.insertRow(at: $0) }
    }
    
    // Delte cache for specific index path of table view data and insert it to new index path.
    func moveRow(from indexPath: IndexPath, to newIndexPath: IndexPath) {
        guard let height = self.removeRow(at: indexPath) else {
            return
        }
        self.insertRow(at: newIndexPath, height: height)
    }
    
    // MARK: Configure
    
    /// Configure table view cell with some model. Cell must implement `ConfigurableView` protocol.
    func configureCell(_ cell: UITableViewCell, for indexPath: IndexPath) {
        guard let model = self.output.tableRowModel(for: indexPath) else {
            return
        }
        guard let configurableCell = cell as? ConfigurableView else {
            assertionFailure("For use `TableViewData.configureCell(_:for:)`and configure cell you must implement `ConfigurableView` protocol for cell type `\(type(of: cell))`")
            return
        }
        configurableCell.configure(model)
    }
    
    /// Configure table header view with some model. Header view must implement `ConfigurableView` protocol.
    func configureHeaderView(_ view: UITableViewHeaderFooterView, for section: Int) {
        guard let model = self.output.tableHeaderModel(for: section) else {
            return
        }
        guard let configurableView = view as? ConfigurableView else {
            assertionFailure("For use `TableViewData.configureHeaderView(_:for:)`and configure header view you must implement `ConfigurableView` protocol for header view type `\(type(of: view))`")
            return
        }
        configurableView.configure(model)
    }
    
    /// Configure table footer view with some model. Footer view must implement `ConfigurableView` protocol.
    func configureFooterView(_ view: UITableViewHeaderFooterView, for section: Int) {
        guard let model = self.output.tableFooterModel(for: section) else {
            return
        }
        guard let configurableView = view as? ConfigurableView else {
            assertionFailure("For use `TableViewData.configureFooterView(_:for:)`and configure footer view you must implement `ConfigurableView` protocol for footer view type `\(type(of: view))`")
            return
        }
        configurableView.configure(model)
    }
    
}

// MARK: UITableViewDataSource
extension TableViewData: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = self.output.tableSections
        self.estimatedHeightsForRow = [[CGFloat]](repeating: [], count: sections)
        self.estimatedHeightsForHeader = [CGFloat](repeating: UITableView.automaticDimension, count: sections)
        self.estimatedHeightsForFooter = [CGFloat](repeating: UITableView.automaticDimension, count: sections)
        return self.output.tableSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.output.tableRows(for: section)
        self.estimatedHeightsForRow[section] = [CGFloat](repeating: UITableView.automaticDimension, count: rows)
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewIdentifier = self.output.tableRowIdentifier(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: viewIdentifier, for: indexPath)
        self.configureCell(cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let hasLeadingActions = self.tableView(tableView, leadingSwipeActionsConfigurationForRowAt: indexPath) != nil
        let hasTrailingActions = self.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath) != nil
        return hasLeadingActions || hasTrailingActions
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.output.tableSectionIndexTitles(for: tableView)
    }
    
}

// MARK: UITableViewDelegate
extension TableViewData: UITableViewDelegate {
    
    // MARK: Cell
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // Check is table view has correct width. Because if width invalid size for row be invalid too
        if tableView.frame.width == self.preferredTableViewWidthForRow {
            if let height = self.estimatedHeightsForRow[safe: indexPath.section]?[safe: indexPath.row], height != UITableView.automaticDimension {
                return height
            }
        }
        
        switch self.output.tableRowHeight(for: indexPath) {
        case .fixed(let height):
            return height
            
        case .flexible:
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, estimatedHeightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.preferredTableViewWidthForRow = tableView.frame.width
        self.estimatedHeightsForRow[indexPath.section][indexPath.row] = cell.frame.height
        self.tableViewDelegate?.tableViewWillDisplayCell(cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Resave estimated height if it's not correct. Usually it happened for first visible rows when it rendered first time
        if let height = self.estimatedHeightsForRow[safe: indexPath.section]?[safe: indexPath.row], height != cell.frame.height {
            self.estimatedHeightsForRow[indexPath.section][indexPath.row] = cell.frame.height
        }
        self.tableViewDelegate?.tableViewDidEndDisplayingCell(cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return self.output.tableRowShouldHighlight(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let highlightableView = tableView.cellForRow(at: indexPath) as? HighlightableView {
            highlightableView.didSetHighlighted(true, animated: UIView.areAnimationsEnabled)
        }
        self.output.tableDidHighlight(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let highlightableView = tableView.cellForRow(at: indexPath) as? HighlightableView {
            highlightableView.didSetHighlighted(false, animated: UIView.areAnimationsEnabled)
        }
        self.output.tableDidUnhighlight(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return output.tableRowShouldSelect(at: indexPath) ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectableView = tableView.cellForRow(at: indexPath) as? SelectableView {
            selectableView.didSetSelected(true, animated: UIView.areAnimationsEnabled)
        }
        self.output.tableRowDidSelect(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let selectableView = tableView.cellForRow(at: indexPath) as? SelectableView {
            selectableView.didSetSelected(false, animated: UIView.areAnimationsEnabled)
        }
        self.output.tableRowDidDeselect(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return self.output.tableLeadingSwipeActionsConfiguration(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return self.output.tableTrailingSwipeActionsConfiguration(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.tableViewDelegate?.tableViewWillBeginEditingRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.tableViewDelegate?.tableViewDidEndEditingRow(at: indexPath)
    }
    
    // MARK: Header
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        // Check is table view has correct width. Because if width invalid size for header be invalid too
        if tableView.frame.width == self.preferredTableViewWidthForHeader {
            if let height = self.estimatedHeightsForHeader[safe: section], height != UITableView.automaticDimension {
                return height
            }
        }
        
        switch self.output.tableHeaderHeight(for: section) {
        case .none:
            return 0
            
        case .fixed(let height):
            return height
            
        case .flexible:
            guard let view = self.tableView(tableView, viewForHeaderInSection: section), tableView.frame.width > 0 else {
                return 0
            }
            let targetSize = CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude)
            let preferedSize = view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            return preferedSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, estimatedHeightForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let identifier = self.output.tableHeaderIdentifier(for: section) else {
            return nil
        }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) else {
            assertionFailure("Table view data can't dequeue reusable header view with identifier `\(identifier)`. Maybe table view not register header with identifier `\(identifier)`")
            return nil
        }
        self.configureHeaderView(view, for: section)
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        self.preferredTableViewWidthForHeader = tableView.frame.width
        self.estimatedHeightsForHeader[section] = view.frame.height
        self.tableViewDelegate?.tableViewWillDisplayHeaderView(view, forSection: section)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let height = self.estimatedHeightsForHeader[safe: section], height != view.frame.height {
            self.estimatedHeightsForHeader[section] = view.frame.height
        }
        self.tableViewDelegate?.tableViewDidEndDisplayingHeaderView(view, forSection: section)
    }
    
    // MARK: Footer
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        // Check is table view has correct width. Because if width invalid size for footer be invalid too
        if tableView.frame.width == self.preferredTableViewWidthForFooter {
            if let height = self.estimatedHeightsForFooter[safe: section], height != UITableView.automaticDimension {
                return height
            }
        }
        switch self.output.tableFooterHeight(for: section) {
        case .none:
            return 0
        case .fixed(let height):
            return height
        case .flexible:
            guard let view = self.tableView(tableView, viewForFooterInSection: section), tableView.frame.width > 0 else {
                return 0
            }
            let targetSize = CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude)
            let prefferedSize = view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            return prefferedSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.tableView(tableView, estimatedHeightForFooterInSection: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let identifier = self.output.tableFooterIdentifier(for: section) else {
            return nil
        }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) else {
            assertionFailure("Table view data can't dequeue reusable footer view with identifier `\(identifier)`. Maybe table view not register footer with identifier `\(identifier)`")
            return nil
        }
        self.configureFooterView(view, for: section)
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        self.preferredTableViewWidthForFooter = tableView.frame.height
        self.estimatedHeightsForFooter[section] = view.frame.height
        self.tableViewDelegate?.tableViewWillDisplayFooterView(view, forSection: section)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let height = self.estimatedHeightsForFooter[safe: section], height != view.frame.height {
            self.estimatedHeightsForFooter[section] = view.frame.height
        }
        self.tableViewDelegate?.tableViewDidEndDisplayingFooterView(view, forSection: section)
    }
    
}

// MARK: - UIScrollViewDelegate
extension TableViewData: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tableViewDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.tableViewDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.tableViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.tableViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.tableViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.tableViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.tableViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.tableViewDelegate?.viewForZooming?(in: scrollView)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.tableViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.tableViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.tableViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.tableViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
}
