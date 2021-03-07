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
import class UIKit.UICollectionViewFlowLayout
import protocol UIKit.UIScrollViewDelegate
import func Foundation.objc_getAssociatedObject
import func Foundation.objc_setAssociatedObject

public protocol CollectionViewControllerProtocol: class {
    
    /// Configure `UICollectionViewDataSource` and `UICollectionViewDelegate` for specific table view and presenter. Also automatically add `CollectionViewDelegate` to current view controller if implemented.
    /// - Parameter collectonView: Instanse of the table view source that will be use by presenter.
    /// - Parameter presenter: Instanse of the table view presenter.
    func configureCollectionView(_ collectonView: UICollectionView, with presenter: CollectionViewPresenterProtocol)
    
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
    
    func configureCollectionView(_ collectonView: UICollectionView, with presenter: CollectionViewPresenterProtocol) {
        collectionViewSource = collectonView
        collectionViewPresenter = presenter
        collectionViewSource.dataSource = collectionViewData
        collectionViewSource.delegate = collectionViewData
        if let delegate = self as? CollectionViewDelegate {
            // Forward available collection view delegate to current view controller.
            collectionViewData.collectionViewDelegate = delegate
        }
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
                deleteCollectionViewItems(at: indexPaths)
            }
            if !insertions.isEmpty {
                let indexPaths = insertions.map { IndexPath(row: $0, section: section) }
                insertCollectionViewItems(at: indexPaths)
            }
            if !modifications.isEmpty {
                let indexPaths = modifications.map { IndexPath(row: $0, section: section) }
                reloadCollectionViewItems(at: indexPaths)
            }
        }, completion: completion)
    }
    
    // MARK: Items
    
    func reloadCollectionViewItems(at indexPaths: [IndexPath]) {
        collectionViewData.reloadItems(at: indexPaths)
        collectionViewSource.reloadItems(at: indexPaths)
    }
    
    func deleteCollectionViewItems(at indexPaths: [IndexPath]) {
        collectionViewData.removeItems(at: indexPaths)
        collectionViewSource.deleteItems(at: indexPaths)
    }

    func insertCollectionViewItems(at indexPaths: [IndexPath]) {
        collectionViewData.insertItems(at: indexPaths)
        collectionViewSource.insertItems(at: indexPaths)
    }

    func moveCollectionViewItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        collectionViewData.moveItem(from: indexPath, to: newIndexPath)
        collectionViewSource.moveItem(at: indexPath, to: newIndexPath)
    }

    func selectCollectionViewItem(at indexPath: IndexPath, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        collectionViewSource.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }

    func deselectCollectionViewItem(at indexPath: IndexPath, animated: Bool) {
        collectionViewSource.deselectItem(at: indexPath, animated: animated)
    }

    func becomeCollectionViewItemFirstResponder(at indexPath: IndexPath) {
        guard let cell = collectionViewSource.cellForItem(at: indexPath) as? InputConfigurableView else {
            return
        }
        cell.becomeInputViewFirstResponder()
    }
    
    func resignCollectionViewItemFirstResponder(at indexPath: IndexPath) {
        guard let cell = collectionViewSource.cellForItem(at: indexPath) as? InputConfigurableView else {
            return
        }
        cell.resignInputViewFirstResponder()
    }
    
    // MARK: Sections
    
    func reloadCollectionViewSections(_ sections: [Int]) {
        collectionViewData.reloadSections(sections)
        let indexSet = IndexSet(sections)
        collectionViewSource.reloadSections(indexSet)
    }

    func deleteCollectionViewSections(_ sections: [Int]) {
        collectionViewData.removeSections(sections)
        let indexSet = IndexSet(sections)
        collectionViewSource.deleteSections(indexSet)
    }

    func insertCollectionViewSections(_ sections: [Int]) {
        collectionViewData.insertSections(sections)
        let indexSet = IndexSet(sections)
        collectionViewSource.insertSections(indexSet)
    }

    func moveCollectionViewSection(from section: Int, to newSection: Int) {
        collectionViewData.moveSection(from: section, to: newSection)
        collectionViewSource.moveSection(section, toSection: newSection)
    }

    // MARK: Scroll
    func scrollCollectionViewToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        collectionViewSource.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        
    }

    // MARK: Configuration
    func reconfigureCollectionViewCellForItem(at indexPath: IndexPath) {
        guard let cell = collectionViewSource.cellForItem(at: indexPath) else {
            return
        }
        collectionViewData.configureCell(cell, for: indexPath)
    }
    
    func indexPathForItem(with view: UIView) -> IndexPath? {
        let rect = view.convert(view.bounds, to: collectionViewSource)
        return collectionViewSource.indexPathForItem(at: rect.origin)
    }
}

// MARK: - CollectionViewData

fileprivate enum CollectionViewControllerProtocolAssociatedKey {
    static var collectionViewSource: String = "CollectionViewControllerProtocol.collectionViewSource"
    static var collectionViewPresenter: String = "CollectionViewControllerProtocol.collectionViewPresenter"
    static var collectionViewData: String = "CollectionViewControllerProtocol.collectionViewData"
}

fileprivate extension CollectionViewControllerProtocol {
    
    /// Get associated `UICollectionView` object with this collection view controller.
    var collectionViewSource: UICollectionView {
        get {
            guard let collectionView = objc_getAssociatedObject(self, &CollectionViewControllerProtocolAssociatedKey.collectionViewSource) as? UICollectionView else {
                assertionFailure("Collection view haven't set for view controller. Please use `configureCollectionView(:,with:)` before use other `CollectionViewControllerProtocol` methods")
                return UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            }
            return collectionView
        }
        set {
            objc_setAssociatedObject(self, &CollectionViewControllerProtocolAssociatedKey.collectionViewSource, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// Get associated `CollectionViewPresenterProtocol` object with this collection view controller
    var collectionViewPresenter: CollectionViewPresenterProtocol {
        get {
            guard let presenter = objc_getAssociatedObject(self, &CollectionViewControllerProtocolAssociatedKey.collectionViewPresenter) as? CollectionViewPresenterProtocol else {
                fatalError("Table view presenter haven't set for view controller. Please use `configureTableView(:,with:)` before use other `TableViewControllerProtocol` methods")
            }
            return presenter
        }
        set {
            objc_setAssociatedObject(self, &CollectionViewControllerProtocolAssociatedKey.collectionViewPresenter, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    /// Get associated `CollectionViewData` object with this table view controller. Will create new one if associated object is nil
    var collectionViewData: CollectionViewData {
        if let data = objc_getAssociatedObject(self, &CollectionViewControllerProtocolAssociatedKey.collectionViewData) as? CollectionViewData {
            return data
        } else {
            // Create new `collectionViewData` model
            let collectionViewData = CollectionViewData(input: self, output: collectionViewPresenter)
            objc_setAssociatedObject(self, &CollectionViewControllerProtocolAssociatedKey.collectionViewData, collectionViewData, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return collectionViewData
        }
    }
    
}
