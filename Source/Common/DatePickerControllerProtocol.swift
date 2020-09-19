//
//  DatePickerControllerProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 19.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

public protocol DatePickerControllerProtocol: class {
    /// Return an instanse of the date picker presented
    var datePickerPresenter: DatePickerPresenterProtocol { get }
}

public protocol TextFieldDatePickerControllerProtocol: DatePickerControllerProtocol, TextFieldDatePickerDelegate {
    
}
