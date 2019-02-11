//
//  AirTable.swift
//  AirCollection
//
//  Created by Yuri Fox on 2/11/19.
//  Copyright © 2019 Developer Lysytsia. All rights reserved.
//

import UIKit

// TODO: UITableViewDataSource
// - canEditRowAt
// - canMoveRowAt

// TODO: UITableViewDelegate

// TODO: UIScrollViewDelegate

/// Manager to create simple table view data
///
/// This manager based on array of items array. Which items array it's section.
public class AirTable<CellType: UITableViewCell, ItemType>: NSObject, AirTableProtocol {

    /// Items to create table view cells
    private var items: Items = []
    
    /// Configuration handler to configure table view cell
    private var configurationHandler: ConfigurationHandler = { (cell, item) in
        fatalError("\(#file) \(#function) must be implemented.")
    }
    
    private var titleForHeaderInSectionHandler: SectionTitleHandler?
    private var titleForFooterInSectionHandler: SectionTitleHandler?
    private var willDisplayCellForRowHandler: ConfigurationHandler?
    private var didEndDisplayingCellForRowHandler: ConfigurationHandler?
    private var heightForRowHandler: HeightForRowHandler?
    private var didSelectRowHandler: DidSelectRowHandler?
    private var didDeselectRowHandler: DidSelectRowHandler?
    
//    private var didSelectHandler: DidSelectHandler?
//    private var didDeselectHandler: DidSelectHandler?
//    private var heightForRowHandler: HeightForRowHandler?
    
    /// Reference to the attached table view
    public private(set) weak var tableView: UITableView?
    
    /// Create new table instance with reference to the attached table view
    ///
    /// - Parameter tableView: Reference to the attached table view
    public init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
    }
    
    deinit {
        print("AirTable deinitialized")
    }
    
    /// Set reference to the attached table view and reload data
    ///
    /// - Parameter tableView: Reference to the attached table view
    public func reloadTableView() {
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.reloadData()
    }
    
    /// Replace table view items and change cell configuration.
    ///
    /// **Attention!** table view cell try dequeue reusable cell with describing _CellType_ identefier and converted to _CellType_.
    ///
    /// - Parameters:
    ///   - items: New items to create table view cells
    ///   - configuration: New table view cell configuration closure
    public func setItems(_ items: Items, with configurationHandler: @escaping ConfigurationHandler) {
        self.items = items
        self.configurationHandler = configurationHandler
    }
    
    /// Set title for header in section closure which called when table view will be created
    ///
    /// - Parameter handler: New closure
    public func setTitleForHeaderInSection(handler: SectionTitleHandler?) {
        self.titleForHeaderInSectionHandler = handler
    }
    
    /// Set title for footer in section closure which called when table view will be created
    ///
    /// - Parameter handler: New closure
    public func setTitleForFooterInSection(handler: SectionTitleHandler?) {
        self.titleForFooterInSectionHandler = handler
    }
    
    /// Set will display cell for row closure which called  when table view will be created
    ///
    /// - Parameter handler: New closure
    public func setWillDisplayCellForRow(handler: ConfigurationHandler?) {
        self.willDisplayCellForRowHandler = handler
    }
    
    /// Set did end displaying cell for row closure which called  when table view will be created
    ///
    /// - Parameter handler: New closure
    public func setDidEndDisplayingCellForRow(handler: ConfigurationHandler?) {
        self.didEndDisplayingCellForRowHandler = handler
    }
    
    /// Set height for row closure which called when table view will be created
    ///
    /// - Parameter handler: New closure
    public func heightForRow(handler: HeightForRowHandler?) {
        self.heightForRowHandler = handler
    }
    
    /// Set did select row handler which called when table view cell will be selected
    ///
    /// - Parameter handler: New closure
    public func didSelectRow(handler: DidSelectRowHandler?) {
        self.didSelectRowHandler = handler
    }
    
    /// Set did deselect row handler which called when table view cell will be deselected
    ///
    /// - Parameter handler: New closure
    public func didDeselectRow(handler: DidSelectRowHandler?) {
        self.didDeselectRowHandler = handler
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: CellType.self)
        let cell: CellType = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! CellType
        let item = self.items[indexPath.section][indexPath.row]
        self.configurationHandler(cell, item)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleForHeaderInSectionHandler?(self.items, section)
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.titleForFooterInSectionHandler?(self.items, section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CellType else {
            return
        }
        let item = self.items[indexPath.section][indexPath.row]
        self.willDisplayCellForRowHandler?(cell, item)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CellType
        let item = self.items[indexPath.section][indexPath.row]
        self.didEndDisplayingCellForRowHandler?(cell, item)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.items[indexPath.section][indexPath.row]
        return self.heightForRowHandler?(item) ?? UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.items[indexPath.section][indexPath.row]
        return self.heightForRowHandler?(item) ?? UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.section][indexPath.row]
        self.didSelectRowHandler?(item)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.section][indexPath.row]
        self.didDeselectRowHandler?(item)
    }
    
    public typealias Items = [[ItemType]]
    public typealias ConfigurationHandler = (CellType, ItemType) -> Void
    public typealias SectionTitleHandler = (Items, Int) -> String?
    public typealias HeightForRowHandler = (ItemType) -> CGFloat
    public typealias DidSelectRowHandler = (ItemType) -> Void
    
}
