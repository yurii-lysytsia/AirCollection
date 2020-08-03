//
//  CollectionViewDelegate.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 03.08.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionReusableView
import protocol UIKit.UIScrollViewDelegate

/// Delegate tells about collection view items, header and footer displayed state and proxy all methods from `UIScrollViewDelegate`
public protocol CollectionViewDelegate: UIScrollViewDelegate {
    
    /// Tells the delegate that the specified cell is about to be displayed in the collection view
    func collectionViewWillDisplayCell(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    
    /// Tells the delegate that the specified cell was removed from the collection view
    func collectionViewDidEndDisplayingCell(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    
    /// Tells the delegate that the specified supplementary view is about to be displayed in the collection view
    func collectionViewWillDisplaySupplementaryView(_ view: UICollectionReusableView, for elementKind: UICollectionView.ElementKindSection, at indexPath: IndexPath)
    
    /// Tells the delegate that the specified supplementary view was removed from the collection view
    func collectionViewDidEndDisplayingSupplementaryView(_ view: UICollectionReusableView, for elementKind: UICollectionView.ElementKindSection, at indexPath: IndexPath)
    
}

public extension CollectionViewDelegate {
    
    func collectionViewWillDisplayCell(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionViewDidEndDisplayingCell(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionViewWillDisplaySupplementaryView(_ view: UICollectionReusableView, for elementKind: UICollectionView.ElementKindSection, at indexPath: IndexPath) {
        
    }
    
    func collectionViewDidEndDisplayingSupplementaryView(_ view: UICollectionReusableView, for elementKind: UICollectionView.ElementKindSection, at indexPath: IndexPath) {
        
    }
    
}

