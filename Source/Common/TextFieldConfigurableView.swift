//
//  TextFieldConfigurableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 14.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import class UIKit.UITextField

public struct TextFieldConfiguration: TextInputConfiguration {
    
    public init() {
        
    }
    
    public func configure(textInputView: UITextField) {
        fatalError()
    }
    
}

// MARK: - TextFieldInputModelConfiguration
//public enum TextFieldInputModelConfiguration {
//    case `default`
//    case keyboard(type: UIKeyboardType, textContentType: UITextContentType?, delegate: UITextFieldDelegate?)
//    case pickerView(dataSouce: UIPickerViewDataSource, delegate: UIPickerViewDelegate)
//    case datePicker(mode: UIDatePicker.Mode, date: Date, minimumDate: Date?, maximumDate: Date?, delegate: UIDatePickerDelegate?)
//}

//public extension TextInputConfigurableView where Model.Configuration == TextFieldConfiguration, TextInputView == UITextField  {
//
//    func configureTextInputView(model: Model) {
//        let textField = self.textInputView
//        let configuration = model.textInputConfiguration
//        configuration.configure(textInputView: textField)
//
//    }
//
//}
