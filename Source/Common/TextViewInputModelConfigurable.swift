//
//  TextViewInputModelConfigurable.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import enum UIKit.UIKeyboardType
import struct UIKit.UITextContentType
import class UIKit.UITextView
import protocol UIKit.UITextViewDelegate

// MARK: - TextViewInputModelConfigurable
public protocol TextViewInputModelConfigurable {
    var textViewConfiguration: TextViewInputModelConfiguration { get }
}

// MARK: - TextViewInputModelConfiguration
public enum TextViewInputModelConfiguration {
    case `default`
    case keyboard(type: UIKeyboardType, textContentType: UITextContentType?, delegate: UITextViewDelegate?)
}

// MARK: - InputModelConfigurableView
public extension TextInputConfigurableView where Model: TextViewInputModelConfigurable, TextInputView: UITextView {
    
    func configureTextInputView(model: Model) {
        let textView = self.textInputView
        let configuration = model.textViewConfiguration
        
        switch configuration {
        case .default:
            break
        case .keyboard(let type, let textContentType, let delegate):
            textView.keyboardType = type
            textView.textContentType = textContentType
            textView.delegate = delegate
        }
    }
    
}

