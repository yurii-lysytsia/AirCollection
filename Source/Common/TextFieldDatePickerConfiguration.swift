//
//  TextFieldDatePickerConfiguration.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 18.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct Foundation.Date
import class Foundation.NSObject
import class UIKit.UITextField
import class UIKit.UIDatePicker
import func Foundation.objc_getAssociatedObject
import func Foundation.objc_setAssociatedObject

// MARK: - TextFieldDatePickerDelegate
public protocol TextFieldDatePickerDelegate: class {
    /// Called by the text field date picker when the user selects a row with date
    func textField(_ textField: UITextField, datePicker: UIDatePicker, didSelectDate date: Date)
    
    /// Called by the text field picker view when the user selectes a row with, and text field text should update `text` as formatted date view title. Nothing happens if return `nil`
    func textField(_ textField: UITextField, datePicker: UIDatePicker, shouldUpdateTextFromDate date: Date) -> String?
}


// MARK: - TextFieldDatePickerConfiguration
public class TextFieldDatePickerConfiguration: TextFieldConfiguration {
    
    /// Picker view which will use as text field `inputView`
    public let datePicker: UIDatePicker

    /// Methods will call by picker view for needed actions
    public unowned let datePickerDelegate: TextFieldDatePickerDelegate

    /// Create configuration for text field that will be with date picker instead keyboard. Please set `delegate` as a reference for strong object because are will be unowned property.
    public init(datePicker: UIDatePicker, delegate: TextFieldDatePickerDelegate) {
        self.datePicker = datePicker
        self.datePickerDelegate = delegate
    }
    
    public convenience init(mode: UIDatePicker.Mode, date: Date = Date(), minimumDate: Date? = nil, maximumDate: Date? = nil, delegate: TextFieldDatePickerDelegate) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.date = date
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        self.init(datePicker: datePicker, delegate: delegate)
    }
    
    public override func configure(textInputView: UITextField) {
        let data = TextFieldDatePickerData(textField: textInputView, datePicker: self.datePicker, delegate: self.datePickerDelegate)
        self.inputView = self.datePicker
        textInputView.datePickerData = data
        super.configure(textInputView: textInputView)
    }
    
}

// MARK: - TextFieldDatePickerData
fileprivate class TextFieldDatePickerData: NSObject {
    
    private unowned let textField: UITextField
    private unowned let datePicker: UIDatePicker
    private unowned let delegate: TextFieldDatePickerDelegate
    
    init(textField: UITextField, datePicker: UIDatePicker, delegate: TextFieldDatePickerDelegate) {
        self.textField = textField
        self.datePicker = datePicker
        self.delegate = delegate
        super.init()
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func datePickerValueChanged(_ datePicker: UIDatePicker) {
        guard datePicker == self.datePicker else {
            assertionFailure("\(#function) called for other date picker. Please don't use this wrapper for other destination")
            return
        }
        let date = datePicker.date
        if let text = self.delegate.textField(self.textField, datePicker: datePicker, shouldUpdateTextFromDate: date) {
            self.textField.text = text
        }
        self.delegate.textField(self.textField, datePicker: self.datePicker, didSelectDate: date)
    }
    
}

// MARK: - Wrapper Associated Object
fileprivate var textFieldDatePickerDataKey: String = "TextFieldDatePickerData.textField"
fileprivate extension UITextField {
    
    /// Get associated `TextFieldDatePickerData` object with this text field
    var datePickerData: TextFieldDatePickerData? {
        set {
            objc_setAssociatedObject(self, &textFieldDatePickerDataKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &textFieldDatePickerDataKey) as? TextFieldDatePickerData
        }
    }
    
}
