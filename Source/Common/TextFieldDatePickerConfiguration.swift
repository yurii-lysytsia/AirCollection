//
//  TextFieldDatePickerConfiguration.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 18.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import Foundation

import class UIKit.UIToolbar
import class UIKit.UIBarButtonItem
import class UIKit.UIDatePicker

// MARK: - UIDatePickerDelegate
public protocol UIDatePickerDelegate: class {
    func datePicker(_ datePicker: UIDatePicker, didSelect date: Date)
    func datePickerShouldReturn(_ datePicker: UIDatePicker) -> Bool
}

public extension UIDatePickerDelegate {
    
    func datePickerShouldReturn(_ datePicker: UIDatePicker) -> Bool {
        return true
    }
    
}

extension TextFieldConfiguration {
    
    public static func datePicker(mode: UIDatePicker.Mode, date: Date, minimumDate: Date? = nil, maximumDate: Date? = nil, delegate: UIDatePickerDelegate?) -> TextFieldConfiguration {
        let datePicker = TextFieldDatePicker()
        datePicker.datePickerMode = mode
        datePicker.date = date
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        datePicker.delegate = delegate
        let config = TextFieldConfiguration()
        config.inputView = datePicker
        return config
    }
    
}

// MARK: - TextFieldDatePicker
fileprivate class TextFieldDatePicker: UIDatePicker {
    
    weak var delegate: UIDatePickerDelegate?
    
    init() {
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
//    unowned let textField: UITextField
//
//    init(textField: UITextField) {
//        self.textField = textField
//        super.init(frame: .zero)
//        self.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
//        textField.inputAccessoryView = self.createToolbar()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func createToolbar() -> UIView {
//        let toolbar = UIToolbar()
//        toolbar.barStyle = .default
//        toolbar.items = [
//            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
//            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTap(_:)))
//        ]
//        toolbar.sizeToFit()
//        return toolbar
//    }
    
    @objc private func valueChanged() {
        self.delegate?.datePicker(self, didSelect: self.date)
    }
    
//    @objc private func doneButtonDidTap(_ sender: UIBarButtonItem) {
//        if self.delegate?.datePickerShouldReturn(self) == true {
//            self.textField.resignFirstResponder()
//        }
//    }
    
}
