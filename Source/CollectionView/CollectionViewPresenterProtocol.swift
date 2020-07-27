//
//  CollectionViewPresenterProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct CoreGraphics.CGFloat
import struct UIKit.UIEdgeInsets
import class UIKit.UICollectionView

public protocol CollectionViewPresenterProtocol: class {
    
    /// Number of sections in the collection view
    var collectionSections: Int { get }
    
    /// Number of items in a given section of a collection view
    func collectionItems(for section: Int) -> Int
    
    /// Cell identifier to insert in a particular location of the collection view for index path
    func collectionItemIdentifier(for indexPath: IndexPath) -> String
    
    /// Size to use for a item in a specified location of the collection view for index path
    func collectionItemSize(for indexPath: IndexPath) -> UICollectionView.ItemSize
    
    /// Model to use for a row in a specified location of the table view for index path
    func collectionItemModel(for indexPath: IndexPath) -> Any?
    
    /// Tells when the specified item is now selected
    func collectionItemDidSelect(at indexPath: IndexPath)
    
    /// Tells when the specified item is now deselected
    func collectionItemDidDeselect(at indexPath: IndexPath)
    
    /// View identifier to display in the header of the specified section of the collection view
    func collectionHeaderIdentifier(for section: Int) -> String?
    
    /// Height to use for the header of a particular section of the collection view
    func collectionHeaderHeight(for section: Int) -> UICollectionView.ViewHeight
    
    /// Model to use for the header of a particular section of the collection view
    func collectionHeaderModel(for section: Int) -> Any?
    
    /// View identifier to display in the footer of the specified section of the collection view
    func collectionFooterIdentifier(for section: Int) -> String?
    
    /// Height to use for the footer of a particular section of the collection view
    func collectionFooterHeight(for section: Int) -> UICollectionView.ViewHeight
    
    /// Model to use for the footer of a particular section of the collection view
    func collectionFooterModel(for section: Int) -> Any?
    
    /// Margins to apply to content in the specified section
    func collectionInset(for section: Int) -> UIEdgeInsets
    
    /// Spacing between successive rows or columns of a section
    func collectionMinimumLineSpacing(for section: Int) -> CGFloat
    
    /// Spacing between successive items in the rows or columns of a section
    func collectionMinimumInteritemSpacing(for section: Int) -> CGFloat
    
}

public extension CollectionViewPresenterProtocol {
    
    // MARK: Item
    func collectionItemDidSelect(at indexPath: IndexPath) {
        
    }
    
    func collectionItemDidDeselect(at indexPath: IndexPath) {
        
    }
    
    // MARK: Header
    func collectionHeaderIdentifier(for section: Int) -> String? {
        return nil
    }
    
    func collectionHeaderHeight(for section: Int) -> UICollectionView.ViewHeight {
        return self.collectionHeaderIdentifier(for: section) == nil ? .none : .flexible
    }
    
    func collectionHeaderModel(for section: Int) -> Any? {
        return nil
    }
    
    // MARK: Footer
    func collectionFooterIdentifier(for section: Int) -> String? {
        return nil
    }
    
    func collectionFooterHeight(for section: Int) -> UICollectionView.ViewHeight {
        return self.collectionFooterIdentifier(for: section) == nil ? .none : .flexible
    }
    
    func collectionFooterModel(for section: Int) -> Any? {
        return nil
    }
    
    // MARK: Spacing
    func collectionInset(for section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionMinimumLineSpacing(for section: Int) -> CGFloat {
        return 0
    }
    
    func collectionMinimumInteritemSpacing(for section: Int) -> CGFloat {
        return 0
    }
    
}
