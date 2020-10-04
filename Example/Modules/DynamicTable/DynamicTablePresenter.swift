//
//  DynamicTablePresenter.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation
import Source

protocol DynamicTableViewOutput: TableViewPresenterProtocol {

}

final class DynamicTablePresenter {
    
    // MARK: Stored properties
    private let sections: [Section] = Section.allCases
    
    private let users: [User] = [
        User(name: "Jason"),
        User(name: "Andrew"),
        User(name: "David")
    ]
    
    private let stories: [Story] = [
        Story(title: "The Bogey Beast", text: "A woman finds a pot of treasure on the road while she is returning from work. Delighted with her luck, she decides to keep it. As she is taking it home, it keeps changing. However, her enthusiasm refuses to fade away."),
        Story(title: "The Tortoise and the Hare", text: "This classic fable tells the story of a very slow tortoise (another word for turtle) and a speedy hare (another word for rabbit). The tortoise challenges the hare to a race. The hare laughs at the idea that a tortoise could run faster than him, but when the two actually race, the results are surprising."),
        Story(title: "The Night Train at Deoli", text: "Ruskin Bond used to spend his summer at his grandmother’s house in Dehradun. While taking the train, he always had to pass through a small station called Deoli. No one used to get down at the station and nothing happened there. Until one day he sees a girl selling fruit and he is unable to forget her")
    ]
    
    // MARK: Dependency properties
    private unowned let view: DynamicTableViewInput
    
    // MARK: Lifecycle
    init(view: DynamicTableViewInput) {
        self.view = view
    }
    
    // MARK: Helpers
    private enum Section: Int, CaseIterable {
        case users
        case stories
    }
    
}

// MARK: - HomeViewOutput
extension DynamicTablePresenter: DynamicTableViewOutput {
    
    var tableSections: Int {
        return self.sections.count
    }
    
    func tableRows(for section: Int) -> Int {
        switch self.sections[section] {
        case .users:
            return self.users.count
        case .stories:
            return self.stories.count
        }
    }
    
    func tableRowIdentifier(for indexPath: IndexPath) -> String {
        switch self.sections[indexPath.section] {
        case .users, .stories:
            return DynamicTitleDescriptionTableViewCell.viewIdentifier
        }
    }
    
    func tableRowHeight(for indexPath: IndexPath) -> TableViewRowHeight {
        return .flexible
    }
    
    func tableRowModel(for indexPath: IndexPath) -> Any? {
        switch self.sections[indexPath.section] {
        case .users:
            let user = self.users[indexPath.row]
            return DynamicTitleDescriptionTableViewCell.Model(title: user.name, description: nil)
        case .stories:
            let story = self.stories[indexPath.row]
            return DynamicTitleDescriptionTableViewCell.Model(title: story.title, description: story.text)
        }
    }
    
    func tableRowDidSelect(at indexPath: IndexPath) {
        self.view.deselectTableViewRow(at: indexPath, animated: true)
        switch self.sections[indexPath.section] {
        case .users:
            let user = self.users[indexPath.row]
            self.view.showUser(user)
        case .stories:
            let story = self.stories[indexPath.row]
            self.view.showStory(story)
        }
    }
    
}

