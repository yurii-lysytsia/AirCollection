//
//  TextFieldConfiguration.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 14.09.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import protocol UIKit.UITextFieldDelegate
import class Foundation.NSObject
import class UIKit.UITextField
import class UIKit.UIView
import class UIKit.UIColor
import struct Foundation.NSRange
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
import func Foundation.objc_getAssociatedObject
import func Foundation.objc_setAssociatedObject

public protocol TextFieldDelegate: AnyObject {
    /// Asks the delegate if editing should begin in the specified text field
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    
    /// Tells the delegate that editing began in the specified text field
    func textFieldDidBeginEditing(_ textField: UITextField)

    /// Asks the delegate if editing should stop in the specified text field
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool

    /// Tells the delegate that editing stopped for the specified text field
    func textFieldDidEndEditing(_ textField: UITextField)
    
    /// Asks the delegate if the specified text should be changed
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: Range<String.Index>, replacementString string: String) -> Bool

    /// Asks the delegate if the text field’s current contents should be removed
    func textFieldShouldClear(_ textField: UITextField) -> Bool

    /// Asks the delegate if the text field should process the pressing of the return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    
    /// Tells the delegate that editing text changed for the specified text field.
    func textFieldEditingChanged(_ textField: UITextField)
}

public extension TextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: Range<String.Index>, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldEditingChanged(_ textField: UITextField) {
        
    }
    
}

open class TextFieldConfiguration: TextInputConfiguration {
    
    /// The auto-capitalization style for the text object. Default is `UITextAutocapitalizationType.sentences`
    public var autocapitalizationType: UITextAutocapitalizationType = .sentences
    /// The autocorrection style for the text object. Default is `UITextAutocorrectionType.default`
    public var autocorrectionType: UITextAutocorrectionType = .default
    /// Controls when the standard clear button appears in the text field. Default is `UITextField.ViewMode.never`
    public var clearButtonMode: UITextField.ViewMode = .never
    /// The custom input view to display when the text field becomes the first responder. Default is nil
    public var inputView: UIView? = nil
    /// Identifies whether the text object should disable text copying and in some cases hide the text being entered. Default is `false`
    public var isSecureTextEntry: Bool = false
    /// The appearance style of the keyboard that is associated with the text object. Default is `UIKeyboardAppearance.default`
    public var keyboardAppearance: UIKeyboardAppearance = .default
    /// The keyboard style associated with the text object. Default is `UIKeyboardType.default`
    public var keyboardType: UIKeyboardType = .default
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
    
    /// The receiver’s delegate
    public unowned let textFieldDelegate: TextFieldDelegate
    
    public init(keyboardType: UIKeyboardType = .default, textContentType: UITextContentType? = nil, delegate: TextFieldDelegate) {
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.textFieldDelegate = delegate
    }
    
    public func configure(textInputView: UITextField) {
        let textFieldData = TextFieldData(textField: textInputView, delegate: self.textFieldDelegate)
        textInputView.delegate = textFieldData
        textInputView.textFieldData = textFieldData
        textInputView.autocapitalizationType = self.autocapitalizationType
        textInputView.autocorrectionType = self.autocorrectionType
        textInputView.clearButtonMode = self.clearButtonMode
        textInputView.inputView = self.inputView
        textInputView.isSecureTextEntry = self.isSecureTextEntry
        textInputView.keyboardAppearance = self.keyboardAppearance
        textInputView.keyboardType = self.keyboardType
        textInputView.returnKeyType = self.returnKeyType
        textInputView.smartDashesType = self.smartDashesType
        textInputView.smartQuotesType = self.smartQuotesType
        textInputView.smartInsertDeleteType = self.smartInsertDeleteType
        textInputView.spellCheckingType = self.spellCheckingType
        textInputView.textContentType = self.textContentType
    }
    
}

// MARK: - TextFieldData
fileprivate class TextFieldData: NSObject, UITextFieldDelegate {
    
    private unowned let textField: UITextField
    private unowned let delegate: TextFieldDelegate
    
    init(textField: UITextField, delegate: TextFieldDelegate) {
        self.textField = textField
        self.delegate = delegate
        super.init()
        self.textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        guard textField == self.textField else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return
        }
        self.delegate.textFieldEditingChanged(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField == self.textField else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return true
        }
        return self.delegate.textFieldShouldBeginEditing(textField)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == self.textField else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return
        }
        self.delegate.textFieldDidBeginEditing(textField)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard textField == self.textField else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return true
        }
        return self.delegate.textFieldShouldEndEditing(textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == self.textField else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return
        }
        self.delegate.textFieldDidEndEditing(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == self.textField else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return true
        }
        let text = textField.text ?? ""
        guard let stringRange = Range<String.Index>.init(range, in: text) else {
            assertionFailure("\(#function) something went wrong and `Swift.Range` didn't evaluate with `NSRange`. Please don't use this method for other destination")
            return true
        }
        return self.delegate.textField(textField, shouldChangeCharactersIn: stringRange, replacementString: string)
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        guard textField == self.textField else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return true
        }
        return self.delegate.textFieldShouldClear(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField == self.textField else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return true
        }
        return self.delegate.textFieldShouldReturn(textField)
    }
    
}

// MARK: - Wrapper Associated Object
fileprivate var textFieldDataKey: String = "UITextField.textFieldData"
fileprivate extension UITextField {
    
    /// Get associated `TableViewData` object with this text field
    var textFieldData: TextFieldData? {
        set {
            objc_setAssociatedObject(self, &textFieldDataKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &textFieldDataKey) as? TextFieldData
        }
    }
    
}
