//
//  TextFieldInputModelConfigurable.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import enum UIKit.UIKeyboardType
import struct UIKit.UITextContentType
import class UIKit.UIView
import class UIKit.UIToolbar
import class UIKit.UIBarButtonItem
import class UIKit.UITextField
import class UIKit.UIPickerView
import class UIKit.UIDatePicker
import protocol UIKit.UITextFieldDelegate
import protocol UIKit.UIPickerViewDelegate
import protocol UIKit.UIPickerViewDataSource

// MARK: - TextFieldInputModelConfigurable
public protocol TextFieldInputModelConfigurable {
    var textFieldConfiguration: TextFieldInputModelConfiguration { get }
}

// MARK: - TextFieldInputModelConfiguration
public enum TextFieldInputModelConfiguration {
    case `default`
    case keyboard(type: UIKeyboardType, textContentType: UITextContentType?, delegate: UITextFieldDelegate?)
    case pickerView(dataSouce: UIPickerViewDataSource, delegate: UIPickerViewDelegate)
    case datePicker(mode: UIDatePicker.Mode, date: Date, minimumDate: Date?, maximumDate: Date?, delegate: UIDatePickerDelegate?)
}

public extension TextInputConfigurableView where Model: TextFieldInputModelConfigurable, TextInputView: UITextField  {
    
    func configureTextInputView(model: Model) {
        let textField = self.textInputView
        let configuration = model.textFieldConfiguration
        
        switch configuration {
        case .default:
            break
            
        case .keyboard(let keyboardType, let textContentType, let delegate):
            textField.keyboardType = keyboardType
            textField.textContentType = textContentType
            textField.delegate = delegate
            
        case .pickerView(let dataSouce, let delegate):
            let pickerView = UIPickerView()
            pickerView.dataSource = dataSouce
            pickerView.delegate = delegate
            textField.inputView = pickerView
            
        case .datePicker(let mode, let date, let minimumDate, let maximumDate, let delegate):
            let datePicker = TextFieldDatePicker(textField: textField)
            datePicker.datePickerMode = mode
            datePicker.date = date
            datePicker.minimumDate = minimumDate
            datePicker.maximumDate = maximumDate
            datePicker.delegate = delegate
            textField.inputView = datePicker
        }
        
    }
    
}

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

// MARK: - TextFieldDatePicker
fileprivate class TextFieldDatePicker: UIDatePicker {
    
    weak var delegate: UIDatePickerDelegate?
    
    unowned let textField: UITextField
    
    init(textField: UITextField) {
        self.textField = textField
        super.init(frame: .zero)
        self.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        textField.inputAccessoryView = self.createToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createToolbar() -> UIView {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTap(_:)))
        ]
        toolbar.sizeToFit()
        return toolbar
    }
    
    @objc private func valueChanged() {
        self.delegate?.datePicker(self, didSelect: self.date)
    }
    
    @objc private func doneButtonDidTap(_ sender: UIBarButtonItem) {
        if self.delegate?.datePickerShouldReturn(self) == true {
            self.textField.resignFirstResponder()
        }
    }
    
}
