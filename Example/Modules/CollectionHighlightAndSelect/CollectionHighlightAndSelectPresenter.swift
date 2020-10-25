//
//  CollectionHighlightAndSelectPresenter.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

protocol CollectionHighlightAndSelectViewOutput: CollectionViewPresenterProtocol {
    func didLoad()
}

final class CollectionHighlightAndSelectPresenter: NSObject {
    
    // MARK: Dependency properties
    private unowned let view: CollectionHighlightAndSelectViewInput
    
    // MARK: Lifecycle
    init(view: CollectionHighlightAndSelectViewInput) {
        self.view = view
    }
    
    func didLoad() {
        [50, 20, 10, 5, 2, 0].forEach { (index) in
            let indexPath = IndexPath(row: index, section: 0)
            self.view.selectCollectionViewItem(at: indexPath, animated: false, scrollPosition: .top)
        }
    }
    
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
        return CollectionHighlightAndSelectCollectionViewCell.viewIdentifier
    }
    
    func collectionItemSize(for indexPath: IndexPath) -> CollectionViewItemSize {
        return .flexibleItems(horizontally: 3, vertically: 5)
    }
    
    func collectionItemModel(for indexPath: IndexPath) -> Any? {
        let title = "\(indexPath.row)"
        return CollectionHighlightAndSelectCollectionViewCell.Model(title: title)
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
