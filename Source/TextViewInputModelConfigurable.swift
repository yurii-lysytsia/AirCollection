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
protocol TextViewInputModelConfigurable {
    var textViewConfiguration: TextViewInputModelConfiguration { get }
}

// MARK: - TextViewInputModelConfiguration
enum TextViewInputModelConfiguration {
    case `default`
    case keyboard(type: UIKeyboardType, textContentType: UITextContentType?, delegate: UITextViewDelegate?)
}

// MARK: - InputModelConfigurableView
extension InputModelConfigurableView where InputModel: TextViewInputModelConfigurable, InputModelView: UITextView {
    
    func configureInputModel(inputModel: InputModel) {
        let textView = self.inputModelView
        let configuration = inputModel.textViewConfiguration
        
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

