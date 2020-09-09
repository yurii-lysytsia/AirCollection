//
//  CollectionViewControllerProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct CoreGraphics.CGPoint
import class UIKit.UIView
import class UIKit.UICollectionView
import protocol UIKit.UIScrollViewDelegate

public protocol CollectionViewControllerProtocol: class {

    /// Return an instanse of the collection view. This collection view will be use by presenter
    var collectionViewSource: UICollectionView { get }
    
    /// Return an instanse of the collection view present
    var collectionViewPresenter: CollectionViewPresenterProtocol { get }
    
    /// Configure `UICollectionViewDataSource` and `UICollectionViewDelegate` for specific collection view data model
    /// - Parameter configurator: Use this block to set up the collection view. You should register collection view cell, headers and footer is this block
    func configureCollectionView(configurator: (UICollectionView) -> Void)
    
    /// Reloads all of the data for the collection view
    func reloadCollectionView()
    
    /// Begin update collection view data, items, headers and footers
    /// - Parameters:
    ///   - updates: Use this block to call update methods for table view. You should call `reloadCollectionViewRows(at:with:)`, `deleteCollectionViewRows(at:with:)`, `insertCollectionViewRows(at:with:)`
    ///   - completion: A completion handler block to execute when all of the operations are finished
    func updateCollectionView(updates: () -> Void, completion: ((Bool) -> Void)?)
    
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
        configurator(self.collectionViewSource)
    }

    // MARK: Reload
    func reloadCollectionView() {
        self.collectionViewData.reloadAll()
        self.collectionViewSource.reloadData()
    }
    
    // MARK: Update
    func updateCollectionView(updates: () -> Void, completion: ((Bool) -> Void)?) {
        if self.isPerformBatchUpdatesCalled {
            assertionFailure("`updateCollectionView(updates:completion:)` was called befor. Please check your logic because it the feature it can be fatal error")
            return
        }
        self.isPerformBatchUpdatesCalled = true
        self.collectionViewSource.performBatchUpdates({
            updates()
        }, completion: { (finished) in
            completion?(finished)
            self.isPerformBatchUpdatesCalled = false
        })
    }

    func updateCollectionView(updates: () -> Void) {
        self.updateCollectionView(updates: updates, completion: nil)
    }
    
    // MARK: Items
    func reloadCollectionViewItems(at indexPaths: [IndexPath]) {
        guard self.isPerformBatchUpdatesCalled else {
            assertionFailure("You must call `updateTableView(updates:completion:)` and call this method inside `updates` block")
            return
        }
        self.collectionViewData.reloadItems(at: indexPaths)
        self.collectionViewSource.reloadItems(at: indexPaths)
    }
    
    func deleteCollectionViewItems(at indexPaths: [IndexPath]) {
        guard self.isPerformBatchUpdatesCalled else {
            assertionFailure("You must call `updateCollectionView(updates:completion:)` and call this method inside `updates` block")
            return
        }
        self.collectionViewData.removeItems(at: indexPaths)
        self.collectionViewSource.deleteItems(at: indexPaths)
    }

    func insertCollectionViewItems(at indexPaths: [IndexPath]) {
        guard self.isPerformBatchUpdatesCalled else {
            assertionFailure("You must call `updateTableView(updates:completion:)` and call this method inside `updates` block")
            return
        }
        self.collectionViewData.insertItems(at: indexPaths)
        self.collectionViewSource.insertItems(at: indexPaths)
    }

    func moveCollectionViewItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        guard self.isPerformBatchUpdatesCalled else {
            assertionFailure("You must call `updateTableView(updates:completion:)` and call this method inside `updates` block")
            return
        }
        self.collectionViewData.moveItem(from: indexPath, to: newIndexPath)
        self.collectionViewSource.moveItem(at: indexPath, to: newIndexPath)
    }

    func selectCollectionViewItem(at indexPath: IndexPath, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        self.collectionViewSource.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }

    func deselectCollectionViewItem(at indexPath: IndexPath, animated: Bool) {
        self.collectionViewSource.deselectItem(at: indexPath, animated: animated)
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
        let point = view.convert(CGPoint.zero, to: self.collectionViewSource)
        return self.collectionViewSource.indexPathForItem(at: point)
    }
}

// MARK: - CollectionViewDelegateForward
public extension CollectionViewControllerProtocol where Self: CollectionViewDelegate {
    
    /// Forward all collection view `UIScrollViewDelegate` to current view controller.
    func forwardCollectionViewDelegate() {
        self.collectionViewData.collectionViewDelegate = self
    }
    
}

// MARK: - CollectionViewData
fileprivate var collectionViewDataKey: String = "TableViewControllerProtocol.tableViewData"
fileprivate var isPerformBatchUpdatesCalledKey: String = "TableViewControllerProtocol.isPerformBatchUpdatesCalled"
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
    
    var isPerformBatchUpdatesCalled: Bool {
        set {
            if newValue {
                let object = NSObject()
                objc_setAssociatedObject(self, &isPerformBatchUpdatesCalledKey, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                objc_setAssociatedObject(self, &isPerformBatchUpdatesCalledKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get {
            let object = objc_getAssociatedObject(self, &isPerformBatchUpdatesCalledKey) as? NSObject
            return object != nil
        }
    }
    
}
