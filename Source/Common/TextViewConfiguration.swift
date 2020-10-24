//
//  TextViewConfiguration.swift
//  Source
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import protocol UIKit.UITextViewDelegate
import enum UIKit.UITextItemInteraction
import struct Foundation.URL
import struct Foundation.NSRange
import class UIKit.NSTextAttachment
import class Foundation.NSObject
import class UIKit.UITextView
import func Foundation.objc_getAssociatedObject
import func Foundation.objc_setAssociatedObject

public protocol TextViewDelegate: class {
    
    /// Asks the delegate if editing should begin in the specified text view
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool

    /// Asks the delegate if editing should stop in the specified text view
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool

    /// Tells the delegate that editing of the specified text view has begun
    func textViewDidBeginEditing(_ textView: UITextView)

    /// Tells the delegate that editing of the specified text view has ended
    func textViewDidEndEditing(_ textView: UITextView)

    /// Asks the delegate whether the specified text should be replaced in the text view
    func textView(_ textView: UITextView, shouldChangeTextIn range: Range<String.Index>, replacementText text: String) -> Bool

    /// Tells the delegate that the text or attributes in the specified text view were changed by the user
    func textViewDidChange(_ textView: UITextView)

    /// Asks the delegate if the specified text view should allow the specified type of user interaction with the given URL in the given range of text
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: Range<String.Index>, interaction: UITextItemInteraction) -> Bool

    /// Asks the delegate if the specified text view should allow the specified type of user interaction with the provided text attachment in the given range of text
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: Range<String.Index>, interaction: UITextItemInteraction) -> Bool
    
}

public extension TextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: Range<String.Index>, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: Range<String.Index>, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: Range<String.Index>, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
}


import class UIKit.UIView
import struct UIKit.UITextContentType
import struct UIKit.UIDataDetectorTypes
import enum UIKit.UITextAutocapitalizationType
import enum UIKit.UITextAutocorrectionType
import enum UIKit.UIKeyboardAppearance
import enum UIKit.UIKeyboardType
import enum UIKit.UIReturnKeyType
import enum UIKit.UITextSmartDashesType
import enum UIKit.UITextSmartQuotesType
import enum UIKit.UITextSmartInsertDeleteType
import enum UIKit.UITextSpellCheckingType

open class TextViewConfiguration: TextInputConfiguration {
    
    /// The auto-capitalization style for the text object. Default is `UITextAutocapitalizationType.sentences`
    public var autocapitalizationType: UITextAutocapitalizationType = .sentences
    
    /// The autocorrection style for the text object. Default is `UITextAutocorrectionType.default`
    public var autocorrectionType: UITextAutocorrectionType = .default
    
    /// The types of data converted to tappable URLs in the text view. Default is `UIDataDetectorTypes.all`
    public var dataDetectorTypes: UIDataDetectorTypes = .all
    
    /// The custom input view to display when the text field becomes the first responder. Default is nil
    public var inputView: UIView? = nil
    
    /// Identifies whether the text object should disable text copying and in some cases hide the text being entered. Default is `false`
    public var isSecureTextEntry: Bool = false
    
    /// A Boolean value indicating whether the receiver is selectable. Default is `true`
    public var isSelectable: Bool = true
    
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
    public unowned let textViewDelegate: TextViewDelegate
    
    public init(delegate: TextViewDelegate) {
        self.textViewDelegate = delegate
    }
    
    public func configure(textInputView: UITextView) {
        let textViewData = TextViewData(textView: textInputView, delegate: self.textViewDelegate)
        textInputView.delegate = textViewData
        textInputView.textViewData = textViewData
        textInputView.autocapitalizationType = self.autocapitalizationType
        textInputView.autocorrectionType = self.autocorrectionType
        textInputView.dataDetectorTypes = self.dataDetectorTypes
        textInputView.inputView = self.inputView
        textInputView.isSecureTextEntry = self.isSecureTextEntry
        textInputView.isSelectable = self.isSelectable
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

// MARK: - TextViewData
fileprivate class TextViewData: NSObject, UITextViewDelegate {
    
    private unowned let textView: UITextView
    private unowned let delegate: TextViewDelegate
    
    init(textView: UITextView, delegate: TextViewDelegate) {
        self.textView = textView
        self.delegate = delegate
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard textView == self.textView else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return true
        }
        return self.delegate.textViewShouldBeginEditing(textView)
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard textView == self.textView else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return true
        }
        return self.delegate.textViewShouldEndEditing(textView)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView == self.textView else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return
        }
        self.delegate.textViewDidBeginEditing(textView)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView == self.textView else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return
        }
        self.delegate.textViewDidEndEditing(textView)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard textView == self.textView else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return true
        }
        guard let textRange = Range(range, in: textView.text) else {
            assertionFailure("\(#function) something went wrong and `Swift.Range` didn't evaluate with `NSRange`. Please don't use this method for other destination")
            return true
        }
        return self.delegate.textView(textView, shouldChangeTextIn: textRange, replacementText: text)
    }

    func textViewDidChange(_ textView: UITextView) {
        guard textView == self.textView else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return
        }
        self.delegate.textViewDidChange(textView)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard textView == self.textView else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return true
        }
        guard let characterRange = Range(characterRange, in: textView.text) else {
            assertionFailure("\(#function) something went wrong and `Swift.Range` didn't evaluate with `NSRange`. Please don't use this method for other destination")
            return true
        }
        return self.delegate.textView(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction)
    }

    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard textView == self.textView else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return true
        }
        guard let characterRange = Range(characterRange, in: textView.text) else {
            assertionFailure("\(#function) something went wrong and `Swift.Range` didn't evaluate with `NSRange`. Please don't use this method for other destination")
            return true
        }
        return self.delegate.textView(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction)
    }

    
}

// MARK: - Wrapper Associated Object
fileprivate var textViewDataKey: String = "UITextView.textViewData"
fileprivate extension UITextView {
    
    /// Get associated `TableViewData` object with this text field
    var textViewData: TextViewData? {
        set {
            objc_setAssociatedObject(self, &textViewDataKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &textViewDataKey) as? TextViewData
        }
    }
    
}
