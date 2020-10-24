//
//  DynamicStoryTablePresenter.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation
import Source

protocol DynamicStoryTableViewOutput: TableViewPresenterProtocol, TextFieldPresenterProtocol, TextViewPresenterProtocol {
    
}

final class DynamicStoryTablePresenter {
    
    // MARK: Stored properties
    private let rows: [[Row]] = [
        [.title],
        [.text]
    ]
    
    // MARK: Dependency properties
    private unowned let story: Story
    private unowned let view: DynamicStoryTableViewInput
    
    // MARK: Lifecycle
    init(story: Story, view: DynamicStoryTableViewInput) {
        self.story = story
        self.view = view
    }
    
    // MARK: Helpers
    private enum Row: Int {
        case title
        case text
    }
    
}

// MARK: - DynamicStoryTableViewOutput
extension DynamicStoryTablePresenter: DynamicStoryTableViewOutput {
    
    // MARK: TableViewPresenterProtocol
    var tableSections: Int {
        return self.rows.count
    }
    
    func tableRows(for section: Int) -> Int {
        return self.rows[section].count
    }
    
    func tableRowIdentifier(for indexPath: IndexPath) -> String {
        switch self.rows[indexPath.section][indexPath.row] {
        case .title:
            return DynamicUserTableViewCell.viewIdentifier
        case .text:
            return DynamicStoryTableViewCell.viewIdentifier
        }
    }
    
    func tableRowHeight(for indexPath: IndexPath) -> TableViewRowHeight {
        switch self.rows[indexPath.section][indexPath.row] {
        case .title:
            return .flexible
        case .text:
            return .fixed(240)
        }
    }
    
    func tableRowModel(for indexPath: IndexPath) -> Any? {
        switch self.rows[indexPath.section][indexPath.row] {
        case .title:
            let text = self.story.title
            let configuration = TextFieldConfiguration(delegate: self.view)
            return DynamicUserTableViewCell.Model(title: "Title", text: text, textInputConfiguration: configuration)
        case .text:
            let text = self.story.text
            let configuration = TextViewConfiguration(delegate: self.view)
            return DynamicStoryTableViewCell.Model(title: "Text", description: text, textInputConfiguration: configuration)
        }
    }
    
    func tableRowDidSelect(at indexPath: IndexPath) {
        self.view.deselectTableViewRow(at: indexPath, animated: true)
        self.view.becomeTableViewRowFirstResponder(at: indexPath)
    }
    
    // MARK: TextFieldPresenterProtocol
    func textFieldTextDidChanged(_ text: String?, at indexPath: IndexPath) {
        switch self.rows[indexPath.section][indexPath.row] {
        case .title:
            self.story.title = text ?? ""
        default:
            return
        }
    }
    
    func textFieldShouldReturn(at indexPath: IndexPath) -> Bool {
        self.view.resignTableViewRowFirstResponder(at: indexPath)
        return true
    }
    
    // MARK: TextViewPresenterProtocol
    func textViewDidChange(text: String, at indexPath: IndexPath) {
        switch self.rows[indexPath.section][indexPath.row] {
        case .text:
            self.story.text = text
        default:
            return
        }
    }
    
}
