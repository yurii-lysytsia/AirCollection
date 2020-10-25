//
//  CollectionHighlightAndSelectPresenter.swift
//  Example
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

protocol CollectionHighlightAndSelectViewOutput: CollectionViewPresenterProtocol {
    // Add presenter properties which will use by view
}

final class CollectionHighlightAndSelectPresenter: NSObject {
    
    // MARK: Dependency properties
    private unowned let view: DynamicCollectionViewInput
    
    // MARK: Lifecycle
    init(view: DynamicCollectionViewInput) {
        self.view = view
    }
    
    // MARK: Functions
    
    // MARK: Helpers
    
}

// MARK: - CollectionHighlightAndSelectViewOutput
extension CollectionHighlightAndSelectPresenter: CollectionHighlightAndSelectViewOutput {
    
    // MARK: CollectionViewPresenterProtocol
    var collectionSections: Int {
        return 1
    }
    
    func collectionItems(for section: Int) -> Int {
        return 100
    }
    
    func collectionItemIdentifier(for indexPath: IndexPath) -> String {
        return DynamicTitleCollectionViewCell.viewIdentifier
    }
    
    func collectionItemSize(for indexPath: IndexPath) -> CollectionViewItemSize {
        return .flexibleItems(horizontally: 3, vertically: 5)
    }
    
    func collectionItemModel(for indexPath: IndexPath) -> Any? {
        let title = "\(indexPath.row)"
        return DynamicTitleCollectionViewCell.Model(title: title)
    }
    
    func collectionInset(for section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionMinimumLineSpacing(for section: Int) -> CGFloat {
        return 8
    }
    
    func collectionMinimumInteritemSpacing(for section: Int) -> CGFloat {
        return 8
    }
    
}
