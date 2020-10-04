//
//  HomeInteractor.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation

protocol HomeInteractorInput: class {
    // Add public methods which will use by presenter
}

final class HomeInteractor {

    // MARK: Stored properties
    weak var output: HomeInteractorOutput?
    
    // MARK: Computed properties
    
    // MARK: Dependency properties
    
    // MARK: Lifecycle
    // init(/* Add required properties */) { }
    
    // MARK: Functions
    
    // MARK: Helpers

}

// MARK: - HomeInteractorInput
extension HomeInteractor: HomeInteractorInput {
    // Implement public methods from `HomeInteractorInput`
}

