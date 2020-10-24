//
//  DynamicUserTablePresenter.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation
import Source

protocol DynamicUserTableViewOutput: TableViewPresenterProtocol, TextFieldPresenterProtocol, DatePickerPresenterProtocol, PickerViewPresenterProtocol {
    // Add presenter properties which will use by view
}

final class DynamicUserTablePresenter: NSObject {
    
    // MARK: Stored properties
    private let sections: [Section] = Section.allCases
    
    private let birthdateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let availableGenders: [User.Gender?] = {
        var genders: [User.Gender?] = User.Gender.allCases
        genders.insert(nil, at: 0)
        return genders
    }()
    
    // MARK: Dependency properties
    private unowned let user: User
    private unowned let view: DynamicUserTableViewInput
    
    // MARK: Lifecycle
    init(user: User, view: DynamicUserTableViewInput) {
        self.user = user
        self.view = view
    }
    
    // MARK: Helpers
    private enum Section: Int, CaseIterable {
        case name
        case birthdate
        case gender
    }
    
}

// MARK: - DynamicUserTableViewOutput
extension DynamicUserTablePresenter: DynamicUserTableViewOutput {
    
    // MARK: TableViewPresenterProtocol
    var tableSections: Int {
        return self.sections.count
    }
    
    func tableRows(for section: Int) -> Int {
        return 1
    }
    
    func tableRowIdentifier(for indexPath: IndexPath) -> String {
        return DynamicUserTableViewCell.viewIdentifier
    }
    
    func tableRowHeight(for indexPath: IndexPath) -> TableViewRowHeight {
        return .flexible
    }
    
    func tableRowModel(for indexPath: IndexPath) -> Any? {
        switch self.sections[indexPath.section] {
        case .name:
            let configuration = TextFieldConfiguration(delegate: self.view)
            return DynamicUserTableViewCell.Model(title: "Username", text: self.user.name, textInputConfiguration: configuration)
        case .birthdate:
            let text = self.user.birthdate.flatMap({ self.birthdateFormatter.string(from: $0) }) ?? ""
            let date = self.user.birthdate ?? Date()
            let configuration = TextFieldDatePickerConfiguration(mode: .date, date: date, maximumDate: Date(), delegate: self.view)
            return DynamicUserTableViewCell.Model(title: "Birthdate", text: text, textInputConfiguration: configuration)
        case .gender:
            let text = self.user.gender?.rawValue ?? ""
            let configuration = TextFieldPickerViewConfiguration(controller: self.view)
            return DynamicUserTableViewCell.Model(title: "Gender", text: text, textInputConfiguration: configuration)
        }
    }
    
    func tableRowDidSelect(at indexPath: IndexPath) {
        self.view.deselectTableViewRow(at: indexPath, animated: true)
        self.view.becomeTableViewRowFirstResponder(at: indexPath)
    }
    
    func tableFooterIdentifier(for section: Int) -> String? {
        return DynamicUserFooterView.viewIdentifier
    }
    
    func tableFooterHeight(for section: Int) -> TableViewHeaderFooterViewHeight {
        return .flexible
    }
    
    func tableFooterModel(for section: Int) -> Any? {
        switch self.sections[section] {
        case .name:
            return DynamicUserFooterView.Model(title: "You can enter any name you want")
        case .birthdate:
            return DynamicUserFooterView.Model(title: "Please select correct date of birth")
        case .gender:
            return DynamicUserFooterView.Model(title: "Select gender if you want")
        }
    }
    
    // MARK: TextFieldPresenterProtocol
    func textFieldTextDidChanged(_ text: String?, at indexPath: IndexPath) {
        switch self.sections[indexPath.section] {
        case .name:
            self.user.name = text ?? ""
        default:
            return
        }
    }
    
    func textFieldShouldReturn(at indexPath: IndexPath) -> Bool {
        self.view.resignTableViewRowFirstResponder(at: indexPath)
        return true
    }
    
    // MARK: DatePickerPresenterProtocol
    func datePickerDidSelectDate(_ date: Date, at indexPath: IndexPath) {
        switch self.sections[indexPath.section] {
        case .birthdate:
            self.user.birthdate = date
        default:
            return
        }
    }
    
    func datePickerShouldUpdateTextFromDate(_ date: Date, at indexPath: IndexPath) -> String? {
        switch self.sections[indexPath.section] {
        case .birthdate:
            return self.birthdateFormatter.string(from: date)
        default:
            return nil
        }
    }
    
    // MARK: PickerViewPresenterProtocol
    func pickerViewNumberOfComponents(at indexPath: IndexPath) -> Int {
        return 1
    }
    
    func pickerViewNumberOfRows(inComponent component: Int, at indexPath: IndexPath) -> Int {
        switch self.sections[indexPath.section] {
        case .gender:
            return self.availableGenders.count
        default:
            return 0
        }
    }
    
    func pickerViewTitle(for row: Int, inComponent component: Int, at indexPath: IndexPath) -> PickerViewTitle {
        switch self.sections[indexPath.section] {
        case .gender:
            let gender = self.availableGenders[row]?.rawValue ?? ""
            return .title(gender)
        default:
            return .title("")
        }
    }
    
    func pickerViewDidSelectRow(_ row: Int, inComponent component: Int, at indexPath: IndexPath) {
        switch self.sections[indexPath.section] {
        case .gender:
            self.user.gender = self.availableGenders[row]
        default:
            return
        }
    }
    
    func pickerViewSelectedRow(inComponent component: Int, at indexPath: IndexPath) -> Int {
        switch self.sections[indexPath.section] {
        case .gender:
            let gender = self.user.gender
            return self.availableGenders.firstIndex(of: gender) ?? 0
        default:
            return 0
        }
    }
    
}
