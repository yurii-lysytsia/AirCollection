//
//  CollectionHighlightAndSelectViewController.swift
//  Example
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

protocol CollectionHighlightAndSelectViewInput: CollectionViewControllerProtocol {
    // Add public methods which will use by presenter
}

final class CollectionHighlightAndSelectViewController: UIViewController {
    
    // MARK: Stored properties
    var output: CollectionHighlightAndSelectViewOutput!
    
    // MARK: Outlet properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.frame = self.view.bounds
        self.collectionView.allowsMultipleSelection = true
        self.configureCollectionView { (collectionView) in
            collectionView.register(CollectionHighlightAndSelectCollectionViewCell.self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.frame = self.view.bounds
    }
    
}

// MARK: - CollectionHighlightAndSelectViewInput
extension CollectionHighlightAndSelectViewController: CollectionHighlightAndSelectViewInput {
    
    // MARK: CollectionViewControllerProtocol
    var collectionViewSource: UICollectionView {
        return self.collectionView
    }
    
    var collectionViewPresenter: CollectionViewPresenterProtocol {
        return self.output
    }
    
}
