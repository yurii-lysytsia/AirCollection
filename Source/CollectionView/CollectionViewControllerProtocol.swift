//
//  CollectionViewControllerProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct Foundation.IndexPath
import struct Foundation.IndexSet
import struct CoreGraphics.CGPoint
import class UIKit.UIView
import class UIKit.UICollectionView
import protocol UIKit.UIScrollViewDelegate
import func Foundation.objc_getAssociatedObject
import func Foundation.objc_setAssociatedObject

public protocol CollectionViewControllerProtocol: AnyObject {

    /// Return an instanse of the collection view. This collection view will be use by presenter
    var collectionViewSource: UICollectionView { get }
    
    /// Return an instanse of the collection view present
    var collectionViewPresenter: CollectionViewPresenterProtocol { get }
    
    /// Configure `UICollectionViewDataSource` and `UICollectionViewDelegate` for specific collection view and presenter. Also automatically add `CollectionViewDelegate` to current view controller if implemented.
    /// - Parameter configurator: Use this block to set up the collection view. You should register collection view cell, headers and footer is this block
    func configureCollectionView(configurator: (UICollectionView) -> Void)
    
    /// Reloads all of the data for the collection view
    func reloadCollectionView()
    
    /// Begin update collection view data, items, headers and footers
    /// - Parameters:
    ///   - updates: Use this block to call update methods for table view. You should call `reloadCollectionViewRows(at:with:)`, `deleteCollectionViewRows(at:with:)`, `insertCollectionViewRows(at:with:)`
    ///   - completion: A completion handler block to execute when all of the operations are finished
    func updateCollectionView(updates: () -> Void, completion: ((Bool) -> Void)?)
    
    /// Update collection view items for specific item and section.
    /// - Parameters:
    ///   - deletions: Items that will be delete
    ///   - insertions: Items that will be insert
    ///   - modifications: Items that will be reload
    ///   - section: Section where this items will updated. For exaple for `deletions = [0]` and `section = 1` will removed item at `IndexPath(row: 0, section: 1)`
    func updateCollectionView(deletions: [Int], insertions: [Int], modifications: [Int], forSection section: Int, completion: ((Bool) -> Void)?)
    
    /// Reloads just the collection view items at the specified index paths
    func reloadCollectionViewItems(at indexPaths: [IndexPath])
    
    /// Deletes the collection view items at the specified index paths
    func deleteCollectionViewItems(at indexPaths: [IndexPath])

    /// Inserts new collection view items at the specified index paths
    func insertCollectionViewItems(at indexPaths: [IndexPath])
    
    /// Moves an item from one location to another in the collection view
    func moveCollectionViewItem(at indexPath: IndexPath, to newIndexPath: IndexPath)
    
    /// Selects the collection item at the specified index path and optionally scrolls it into view.
    func selectCollectionViewItem(at indexPath: IndexPath, animated: Bool, scrollPosition: UICollectionView.ScrollPosition)

    /// Deselects the collection view item at the specified index.
    func deselectCollectionViewItem(at indexPath: IndexPath, animated: Bool)
    
    /// Make an item input view in the collection view identified by index path the first responder in its window at.
    func becomeCollectionViewItemFirstResponder(at indexPath: IndexPath)
    
    /// Notifies an item input view in the collection view identified by index path that it has been asked to relinquish its status as first responder in its window.
    func resignCollectionViewItemFirstResponder(at indexPath: IndexPath)
    
    /// Reloads the data in the specified sections of the collection view.
    func reloadCollectionViewSections(_ sections: [Int])
    
    /// Deletes the collection view sections at the specified indexes.
    func deleteCollectionViewSections(_ sections: [Int])
    
    /// Inserts new sections at the specified indexes.
    func insertCollectionViewSections(_ sections: [Int])
    
    /// Moves a section from one location to another in the collection view.
    func moveCollectionViewSection(from section: Int, to newSection: Int)
    
    /// Scrolls the collection view contents until the specified item is visible.
    func scrollCollectionViewToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool)
    
    /// Call `configureCell(_:for)` method for cell at specified index path of the collection view
    func reconfigureCollectionViewCellForItem(at indexPath: IndexPath)
    
    /// Returns an index path identifying the subview
    func indexPathForItem(with view: UIView) -> IndexPath?
    
}

public extension CollectionViewControllerProtocol {

    // MARK: Configure
    func configureCollectionView(configurator: (UICollectionView) -> Void) {
        self.collectionViewSource.dataSource = self.collectionViewData
        self.collectionViewSource.delegate = self.collectionViewData
        if let delegate = self as? CollectionViewDelegate {
            // Forward available collection view delegate to current view controller.
            self.collectionViewData.collectionViewDelegate = delegate
        }
        configurator(self.collectionViewSource)
    }

    // MARK: Reload
    func reloadCollectionView() {
        self.collectionViewData.reloadAll()
        self.collectionViewSource.reloadData()
    }
    
    // MARK: Update
    func updateCollectionView(updates: () -> Void, completion: ((Bool) -> Void)?) {
        self.collectionViewSource.performBatchUpdates({
            updates()
        }, completion: { (finished) in
            completion?(finished)
        })
    }

    func updateCollectionView(updates: () -> Void) {
        self.updateCollectionView(updates: updates, completion: nil)
    }
    
    func updateCollectionView(deletions: [Int], insertions: [Int], modifications: [Int], forSection section: Int, completion: ((Bool) -> Void)?) {
        if deletions.isEmpty, insertions.isEmpty, modifications.isEmpty {
            assertionFailure("\(#function) deletions, insertions or modifications can't be empty. One of them must contains element")
            return
        }
        self.updateCollectionView(updates: {
            if !deletions.isEmpty {
                let indexPaths = deletions.map { IndexPath(row: $0, section: section) }
                self.deleteCollectionViewItems(at: indexPaths)
            }
            if !insertions.isEmpty {
                let indexPaths = insertions.map { IndexPath(row: $0, section: section) }
                self.insertCollectionViewItems(at: indexPaths)
            }
            if !modifications.isEmpty {
                let indexPaths = modifications.map { IndexPath(row: $0, section: section) }
                self.reloadCollectionViewItems(at: indexPaths)
            }
        }, completion: completion)
    }
    
    // MARK: Items
    func reloadCollectionViewItems(at indexPaths: [IndexPath]) {
        self.collectionViewData.reloadItems(at: indexPaths)
        self.collectionViewSource.reloadItems(at: indexPaths)
    }
    
    func deleteCollectionViewItems(at indexPaths: [IndexPath]) {
        self.collectionViewData.removeItems(at: indexPaths)
        self.collectionViewSource.deleteItems(at: indexPaths)
    }

    func insertCollectionViewItems(at indexPaths: [IndexPath]) {
        self.collectionViewData.insertItems(at: indexPaths)
        self.collectionViewSource.insertItems(at: indexPaths)
    }

    func moveCollectionViewItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        self.collectionViewData.moveItem(from: indexPath, to: newIndexPath)
        self.collectionViewSource.moveItem(at: indexPath, to: newIndexPath)
    }

    func selectCollectionViewItem(at indexPath: IndexPath, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        self.collectionViewSource.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }

    func deselectCollectionViewItem(at indexPath: IndexPath, animated: Bool) {
        self.collectionViewSource.deselectItem(at: indexPath, animated: animated)
    }

    func becomeCollectionViewItemFirstResponder(at indexPath: IndexPath) {
        guard let cell = self.collectionViewSource.cellForItem(at: indexPath) as? InputConfigurableView else {
            return
        }
        cell.becomeInputViewFirstResponder()
    }
    
    func resignCollectionViewItemFirstResponder(at indexPath: IndexPath) {
        guard let cell = self.collectionViewSource.cellForItem(at: indexPath) as? InputConfigurableView else {
            return
        }
        cell.resignInputViewFirstResponder()
    }
    
    // MARK: Sections
    func reloadCollectionViewSections(_ sections: [Int]) {
        self.collectionViewData.reloadSections(sections)
        let indexSet = IndexSet(sections)
        self.collectionViewSource.reloadSections(indexSet)
    }

    func deleteCollectionViewSections(_ sections: [Int]) {
        self.collectionViewData.removeSections(sections)
        let indexSet = IndexSet(sections)
        self.collectionViewSource.deleteSections(indexSet)
    }

    func insertCollectionViewSections(_ sections: [Int]) {
        self.collectionViewData.insertSections(sections)
        let indexSet = IndexSet(sections)
        self.collectionViewSource.insertSections(indexSet)
    }

    func moveCollectionViewSection(from section: Int, to newSection: Int) {
        self.collectionViewData.moveSection(from: section, to: newSection)
        self.collectionViewSource.moveSection(section, toSection: newSection)
    }

    // MARK: Scroll
    func scrollCollectionViewToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        self.collectionViewSource.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        
    }

    // MARK: Configuration
    func reconfigureCollectionViewCellForItem(at indexPath: IndexPath) {
        guard let cell = self.collectionViewSource.cellForItem(at: indexPath) else {
            return
        }
        self.collectionViewData.configureCell(cell, for: indexPath)
    }
    
    func indexPathForItem(with view: UIView) -> IndexPath? {
        let rect = view.convert(view.bounds, to: self.collectionViewSource)
        return self.collectionViewSource.indexPathForItem(at: rect.origin)
    }
}

// MARK: - CollectionViewData
fileprivate var collectionViewDataKey: String = "TableViewControllerProtocol.tableViewData"
fileprivate extension CollectionViewControllerProtocol {
    
    /// Get associated `CollectionViewData` object with this table view controller. Will create new one if associated object is nil
    var collectionViewData: CollectionViewData {
        if let data = objc_getAssociatedObject(self, &collectionViewDataKey) as? CollectionViewData {
            return data
        } else {
            // Create new `collectionViewData` model
            let collectionViewData = CollectionViewData(input: self, output: self.collectionViewPresenter)
            objc_setAssociatedObject(self, &collectionViewDataKey, collectionViewData, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return collectionViewData
        }
    }
    
}
