//
//  PickerViewPresenterProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 19.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

public protocol PickerViewPresenterProtocol: class {
    /// Called by controller (`PickerViewControllerProtocol`) when picker view needs the number of components for index path
    func pickerViewNumberOfComponents(at indexPath: IndexPath) -> Int
    
    /// Called by controller (`PickerViewControllerProtocol`) when picker view needs the number of rows for a specified component and index path
    func pickerViewNumberOfRows(inComponent component: Int, at indexPath: IndexPath) -> Int
    
    /// Called by controller (`PickerViewControllerProtocol`) when picker view needs the title to use for a given row in a given component and index path
    func pickerViewTitle(for row: Int, inComponent component: Int, at indexPath: IndexPath) -> PickerViewTitle
    
    /// Called by controller (`PickerViewControllerProtocol`) when the user selects picker view row in a component for index path
    func pickerViewDidSelectRow(_ row: Int, inComponent component: Int, at indexPath: IndexPath)
    
    /// Called by controller (`PickerViewControllerProtocol`) when the text field with picker view begin editing for select correct row in component and index path
    func pickerViewSelectedRow(inComponent component: Int, at indexPath: IndexPath) -> Int
}
