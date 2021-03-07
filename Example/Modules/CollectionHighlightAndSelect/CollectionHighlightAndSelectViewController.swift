//
//  CollectionHighlightAndSelectViewController.swift
//  AirCollection
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
        
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.frame = view.bounds
        collectionView.allowsMultipleSelection = true
        collectionView.register(CollectionHighlightAndSelectCollectionViewCell.self)
        configureCollectionView(collectionView, with: output)
        
        output.didLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
    
}

// MARK: - CollectionHighlightAndSelectViewInput
extension CollectionHighlightAndSelectViewController: CollectionHighlightAndSelectViewInput {
    
}
