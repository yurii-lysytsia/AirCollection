//
//  TextFieldPresenterProtocol.swift
//  Source
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import struct Foundation.IndexPath

public protocol TextFieldPresenterProtocol: class {
    
    /// Called by controller (`TextFieldControllerProtocol`) if editing should begin in the specified index path
    func textFieldShouldBeginEditing(at indexPath: IndexPath) -> Bool

    /// Called by controller (`TextFieldControllerProtocol`) that editing began in the specified index path
    func textFieldDidBeginEditing(at indexPath: IndexPath)
    
    /// Called by controller (`TextFieldControllerProtocol`) if editing should stop in the specified index path
    func textFieldShouldEndEditing(at indexPath: IndexPath) -> Bool

    /// Called by controller (`TextFieldControllerProtocol`) that editing stopped for the specified index path
    func textFieldDidEndEditing(at indexPath: IndexPath)

    /// Called by controller (`TextFieldControllerProtocol`) if the specified text should be changed at index path
    func textField(at indexPath: IndexPath, shouldChangeCharactersIn range: Range<String.Index>, replacementString string: String) -> Bool

    /// Called by controller (`TextFieldControllerProtocol`) if the current contents at index path should be removed
    func textFieldShouldClear(at indexPath: IndexPath) -> Bool

    /// Called by controller (`TextFieldControllerProtocol`) if the text input should process the pressing of the return button
    func textFieldShouldReturn(at indexPath: IndexPath) -> Bool

    /// Called by controller (`TextFieldControllerProtocol`) that editing text changed for the specified index path
    func textFieldTextDidChanged(_ text: String?, at indexPath: IndexPath)
    
}

public extension TextFieldPresenterProtocol {
    
    func textFieldShouldBeginEditing(at indexPath: IndexPath) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(at indexPath: IndexPath) {
        
    }
    
    func textFieldShouldEndEditing(at indexPath: IndexPath) -> Bool {
        return true
    }

    func textFieldDidEndEditing(at indexPath: IndexPath) {
        
    }

    func textField(at indexPath: IndexPath, shouldChangeCharactersIn range: Range<String.Index>, replacementString string: String) -> Bool {
        return true
    }

    func textFieldShouldClear(at indexPath: IndexPath) -> Bool {
        return true
    }

    func textFieldShouldReturn(at indexPath: IndexPath) -> Bool {
        return true
    }

    func textFieldTextDidChanged(_ text: String, at indexPath: IndexPath) {
        
    }
    
}
