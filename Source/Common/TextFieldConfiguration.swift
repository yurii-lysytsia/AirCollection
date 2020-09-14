//
//  TextFieldConfiguration.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 14.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import protocol UIKit.UITextFieldDelegate
import class UIKit.UITextField
import class UIKit.UIColor
import struct UIKit.UITextContentType
import enum UIKit.UITextAutocapitalizationType
import enum UIKit.UITextAutocorrectionType
import enum UIKit.UIKeyboardAppearance
import enum UIKit.UIKeyboardType
import enum UIKit.UIReturnKeyType
import enum UIKit.UITextSmartDashesType
import enum UIKit.UITextSmartQuotesType
import enum UIKit.UITextSmartInsertDeleteType
import enum UIKit.UITextSpellCheckingType
import enum UIKit.NSTextAlignment

public struct TextFieldConfiguration: TextInputConfiguration {
    
    /// The auto-capitalization style for the text object. Default is `UITextAutocapitalizationType.sentences`
    public var autocapitalizationType: UITextAutocapitalizationType = .sentences
    /// The autocorrection style for the text object. Default is `UITextAutocorrectionType.default`
    public var autocorrectionType: UITextAutocorrectionType = .default
    /// Controls when the standard clear button appears in the text field. Default is `UITextField.ViewMode.never`
    public var clearButtonMode: UITextField.ViewMode = .never
    /// The receiver’s delegate. Default is nil
    public var delegate: UITextFieldDelegate? = nil
    /// Identifies whether the text object should disable text copying and in some cases hide the text being entered. Default is `false`
    public var isSecureTextEntry: Bool = false
    /// The appearance style of the keyboard that is associated with the text object. Default is `UIKeyboardAppearance.default`
    public var keyboardAppearance: UIKeyboardAppearance = .default
    /// The keyboard style associated with the text object. Default is `UIKeyboardType.default`
    public var keyboardType: UIKeyboardType = .default
    /// The string that is displayed when there is no other text in the text field. Default is nil
    public var placeholder: String? = nil
    /// The visible title of the Return key. Default is `UIReturnKeyType.default`
    public var returnKeyType: UIReturnKeyType = .default
    /// The configuration state for smart dashes. Default is `UITextSmartDashesType.default`
    public var smartDashesType: UITextSmartDashesType = .default
    /// The configuration state for smart quotes. Default is `UITextSmartQuotesType.default`
    public var smartQuotesType: UITextSmartQuotesType = .default
    /// The configuration state for the smart insertion and deletion of space characters. Default is `UITextSmartInsertDeleteType.default`
    public var smartInsertDeleteType: UITextSmartInsertDeleteType = .default
    /// The spell-checking style for the text object. Default is `UITextSpellCheckingType.default`
    public var spellCheckingType: UITextSpellCheckingType = .default
    /// The semantic meaning expected by a text input area. Default is nil
    public var textContentType: UITextContentType? = nil
    
    public func configure(textInputView: UITextField) {
        textInputView.autocapitalizationType = self.autocapitalizationType
        textInputView.autocorrectionType = self.autocorrectionType
        textInputView.clearButtonMode = self.clearButtonMode
        textInputView.delegate = self.delegate
        textInputView.isSecureTextEntry = self.isSecureTextEntry
        textInputView.keyboardAppearance = self.keyboardAppearance
        textInputView.keyboardType = self.keyboardType
        textInputView.placeholder = self.placeholder
        textInputView.returnKeyType = self.returnKeyType
        textInputView.smartDashesType = self.smartDashesType
        textInputView.smartQuotesType = self.smartQuotesType
        textInputView.smartInsertDeleteType = self.smartInsertDeleteType
        textInputView.spellCheckingType = self.spellCheckingType
        textInputView.textContentType = self.textContentType
    }
    
    public static func keyboard(keyboardType: UIKeyboardType = .default, textContentType: UITextContentType? = nil, delegate: UITextFieldDelegate? = nil) -> TextFieldConfiguration {
        return TextFieldConfiguration(delegate: delegate, keyboardType: keyboardType, textContentType: textContentType)
    }
    
    //    TODO: STATIC PROPERTIES
    //    case pickerView(dataSouce: UIPickerViewDataSource, delegate: UIPickerViewDelegate)
    //    case datePicker(mode: UIDatePicker.Mode, date: Date, minimumDate: Date?, maximumDate: Date?, delegate: UIDatePickerDelegate?)
    
}
