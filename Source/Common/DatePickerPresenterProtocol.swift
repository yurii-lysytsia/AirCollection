//
//  DatePickerPresenterProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 19.09.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import struct Foundation.Date
import struct Foundation.IndexPath

public protocol DatePickerPresenterProtocol: AnyObject {
    /// Called by controller (`DatePickerControllerProtocol`) when the user selects a row with date for index path
    func datePickerDidSelectDate(_ date: Date, at indexPath: IndexPath)
    
    /// Called by controller (`DatePickerControllerProtocol`) when the user selectes a row with, and text field text should update `text` as formatted date view title. Nothing happens if return `nil`
    func datePickerShouldUpdateTextFromDate(_ date: Date, at indexPath: IndexPath) -> String?
}
