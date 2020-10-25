//
//  TextViewPresenterProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import enum UIKit.UITextItemInteraction
import struct Foundation.IndexPath
import struct Foundation.URL
import class UIKit.NSTextAttachment

public protocol TextViewPresenterProtocol: class {

    /// Asks by controller (`TextViewControllerProtocol`) if editing should begin in the specified index path
    func textViewShouldBeginEditing(at indexPath: IndexPath) -> Bool

    /// Asks by controller (`TextViewControllerProtocol`) if editing should stop in the specified index path
    func textViewShouldEndEditing(at indexPath: IndexPath) -> Bool

    /// Tells by controller (`TextViewControllerProtocol`) that editing of the specified text view has begun in the specified index path
    func textViewDidBeginEditing(at indexPath: IndexPath)

    /// Tells by controller (`TextViewControllerProtocol`) that editing of the specified text view has ended in the specified index path
    func textViewDidEndEditing(at indexPath: IndexPath)

    /// Asks by controller (`TextViewControllerProtocol`) whether the specified text should be replaced in the specified index path
    func textView(at indexPath: IndexPath, shouldChangeTextIn range: Range<String.Index>, replacementText text: String) -> Bool

    /// Tells by controller (`TextViewControllerProtocol`) that the text or attributes in the specified text view were changed by the user in the specified index path
    func textViewDidChange(text: String, at indexPath: IndexPath)

    /// Asks by controller (`TextViewControllerProtocol`) if the specified text view should allow the specified type of user interaction with the given URL in the given range of text in the specified index path
    func textView(at indexPath: IndexPath, shouldInteractWith URL: URL, in characterRange: Range<String.Index>, interaction: UITextItemInteraction) -> Bool

    /// Asks by controller (`TextViewControllerProtocol`) if the specified text view should allow the specified type of user interaction with the provided text attachment in the given range of text in the specified index path
    func textView(at indexPath: IndexPath, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: Range<String.Index>, interaction: UITextItemInteraction) -> Bool
    
}

public extension TextViewPresenterProtocol {
    
    func textViewShouldBeginEditing(at indexPath: IndexPath) -> Bool {
        return true
    }

    func textViewShouldEndEditing(at indexPath: IndexPath) -> Bool {
        return true
    }

    func textViewDidBeginEditing(at indexPath: IndexPath) {
        
    }

    func textViewDidEndEditing(at indexPath: IndexPath) {
        
    }

    func textView(at indexPath: IndexPath, shouldChangeTextIn range: Range<String.Index>, replacementText text: String) -> Bool {
        return true
    }

    func textViewDidChange(text: String, at indexPath: IndexPath) {
        
    }

    func textView(at indexPath: IndexPath, shouldInteractWith URL: URL, in characterRange: Range<String.Index>, interaction: UITextItemInteraction) -> Bool {
        return true
    }

    func textView(at indexPath: IndexPath, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: Range<String.Index>, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
}

