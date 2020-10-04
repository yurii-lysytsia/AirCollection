//
//  HomePresenter.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation
import Source

protocol HomeInteractorOutput: class {
    // Add presenter properties which will use by interactor
}

protocol HomeViewOutput: TableViewPresenterProtocol {
    func didLoad()
}

final class HomePresenter {
    
    // MARK: Stored properties
    private let rows: [[Row]] = [
        [.nib]
    ]
    
    // MARK: Dependency properties
    private unowned let view: HomeViewInput
    private let interactor: HomeInteractorInput
    private let router: HomeRouterInput
    
    // MARK: Lifecycle
    init(view: HomeViewInput, interactor: HomeInteractorInput, router: HomeRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func didLoad() {
        // Called when view did load
    }
    
    func willAppear() {
        // Called when view will apear
    }
    
    func didAppear() {
        // Called when view did apear
    }
    
    // MARK: Functions
    
    // MARK: Helpers
    private enum Row: String, CaseIterable {
        case nib = "Load UIView from Nib"
    }
    
}

// MARK: - HomeInteractorOutput
extension HomePresenter: HomeInteractorOutput {
    // Implement public methods from `HomeInteractorOutput`
}

// MARK: - HomeViewOutput
extension HomePresenter: HomeViewOutput {
    
    var tableSections: Int {
        return self.rows.count
    }
    
    func tableRows(for section: Int) -> Int {
        return self.rows[section].count
    }
    
    func tableRowIdentifier(for indexPath: IndexPath) -> String {
        return HomeTableViewCell.viewIdentifier
    }
    
    func tableRowHeight(for indexPath: IndexPath) -> TableViewRowHeight {
        return .fixed(44)
    }
    
    func tableRowModel(for indexPath: IndexPath) -> Any? {
        let row = self.rows[indexPath.section][indexPath.row]
        return HomeTableViewCell.Model(title: row.rawValue)
    }
    
    func tableRowDidSelect(at indexPath: IndexPath) {
        self.view.deselectTableViewRow(at: indexPath, animated: true)
    }
    
}
