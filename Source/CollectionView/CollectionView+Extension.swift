//
//  UICollectionView+Extension.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionReusableView

public extension UICollectionView {
    
    /// Register a class for use in creating new collection view cells.
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) where T: IdentificableView {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.viewIdentifier)
    }
    
    /// Register a nib file for use in creating new collection view cells
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) where T: NibLoadableView {
        self.register(cellClass.nib(), forCellWithReuseIdentifier: cellClass.viewIdentifier)
    }
    
    /// Registers a class for use in creating supplementary views for the collection view
    func register<T: UICollectionReusableView>(_ viewClass: T.Type, for kind: CollectionViewElementKindSection) where T: IdentificableView {
        self.register(viewClass, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: viewClass.viewIdentifier)
    }
    
    /// Registers a nib file for use in creating supplementary views for the collection view
    func register<T: UICollectionReusableView>(_ viewClass: T.Type, for kind: CollectionViewElementKindSection) where T: NibLoadableView {
        self.register(viewClass.nib(), forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: viewClass.viewIdentifier)
    }
    
}
