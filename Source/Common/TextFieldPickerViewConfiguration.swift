//
//  TextFieldPickerViewConfiguration.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 18.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import protocol UIKit.UIPickerViewDataSource
import protocol UIKit.UIPickerViewDelegate
import class UIKit.UITextField
import class UIKit.UIPickerView

// MARK: - TextFieldPickerViewDataSource
public protocol TextFieldPickerViewDataSource: class {
    /// Called by the text field picker view when it needs the number of components
    func textField(_ textField: UITextField, numberOfComponentsInPickerView pickerView: UIPickerView) -> Int
    
    /// Called by the text field picker view when it needs the number of rows for a specified component
    func textField(_ textField: UITextField, pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    
    /// Called by the text field picker view when it needs the title to use for a given row in a given component
    func textField(_ textField: UITextField, pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> PickerViewTitle?
}

// MARK: - TextFieldPickerViewDelegate
public protocol TextFieldPickerViewDelegate: class {
    /// Called by the text field picker view when the user selects a row in a component
    func textField(_ textField: UITextField, pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    
    /// Called by the text field picker view when the user selectes a row in a component, and text field text should set the same `text` or `attributedText` as picker view title. Default `true`
    func textField(_ textField: UITextField, pickerView: UIPickerView, shouldUpdateTextFromRow row: Int, inComponent component: Int) -> Bool
    
    /// Called by the text field picker view when the text field begin editing for select correct row in component
    func textField(_ textField: UITextField, pickerView: UIPickerView, selectedRowInComponent component: Int) -> Int
}

public extension TextFieldPickerViewDelegate {
    
    func textField(_ textField: UITextField, pickerView: UIPickerView, shouldUpdateTextFromRow row: Int, inComponent component: Int) -> Bool {
        return true
    }
    
}

// MARK: - TextFieldPickerViewConfiguration
open class TextFieldPickerViewConfiguration: TextFieldConfiguration {
    
    /// Picker view which will use as text field `inputView`
    public let pickerView: UIPickerView
    
    /// Methods will call by picker view for needed actions
    public unowned let pickerViewDataSource: TextFieldPickerViewDataSource
    public unowned let pickerViewDelegate: TextFieldPickerViewDelegate
    
    /// Create configuration for text field that will be with picker view instead keyboard. Please set `dataSource` and `delegate` as a reference for strong object because are will be unowned property. Default `pickerView` is `UIPickerView()`
    public init(pickerView: UIPickerView = UIPickerView(), dataSource: TextFieldPickerViewDataSource, delegate: TextFieldPickerViewDelegate) {
        self.pickerView = pickerView
        self.pickerViewDataSource = dataSource
        self.pickerViewDelegate = delegate
    }
    
    /// Create configuration for text field that will be with picker view instead keyboard. Please set `controller` as a reference for strong object because are will be unowned property. Default `pickerView` is `UIPickerView()`
    public convenience init(pickerView: UIPickerView = UIPickerView(), controller: TextFieldPickerViewControllerProtocol) {
        self.init(pickerView: pickerView, dataSource: controller, delegate: controller)
    }
    
    public override func configure(textInputView: UITextField) {
        let data = TextFieldPickerViewData(textField: textInputView, pickerView: self.pickerView, dataSource: self.pickerViewDataSource, delegate: self.pickerViewDelegate)
        self.pickerView.dataSource = data
        self.pickerView.delegate = data
        self.inputView = self.pickerView
        textInputView.pickerViewWrapper = data
        super.configure(textInputView: textInputView)
    }
    
}

// MARK: - TextFieldPickerViewData
fileprivate class TextFieldPickerViewData: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private unowned let textField: UITextField
    private unowned let pickerView: UIPickerView
    private unowned let dataSource: TextFieldPickerViewDataSource
    private unowned let delegate: TextFieldPickerViewDelegate
    
    init(textField: UITextField, pickerView: UIPickerView, dataSource: TextFieldPickerViewDataSource, delegate: TextFieldPickerViewDelegate) {
        self.textField = textField
        self.pickerView = pickerView
        self.dataSource = dataSource
        self.delegate = delegate
        super.init()
        self.textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
    }
    
    @objc private func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == self.textField else {
            assertionFailure("\(#function) called for other text field. Please don't use this wrapper for other destination")
            return
        }
        self.pickerView.reloadAllComponents()
        
        // Get number of components and select correct row for each
        var component: Int = 0
        while component < self.pickerView.numberOfComponents {
            let row = self.delegate.textField(self.textField, pickerView: self.pickerView, selectedRowInComponent: component)
            self.pickerView.selectRow(row, inComponent: component, animated: false)
            component += 1
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard pickerView == self.pickerView else {
            assertionFailure("\(#function) called for other picker view. Please don't use this wrapper for other destination")
            return 0
        }
        return self.dataSource.textField(self.textField, numberOfComponentsInPickerView: self.pickerView)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard pickerView == self.pickerView else {
            assertionFailure("\(#function) called for other picker view. Please don't use this wrapper for other destination")
            return 0
        }
        return self.dataSource.textField(self.textField, pickerView: self.pickerView, numberOfRowsInComponent: component)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard pickerView == self.pickerView else {
            assertionFailure("\(#function) called for other picker view. Please don't use this wrapper for other destination")
            return nil
        }
        let title = self.dataSource.textField(self.textField, pickerView: self.pickerView, titleForRow: row, forComponent: component)
        return title?.title
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard pickerView == self.pickerView else {
            assertionFailure("\(#function) called for other picker view. Please don't use this wrapper for other destination")
            return nil
        }
        let title = self.dataSource.textField(self.textField, pickerView: self.pickerView, titleForRow: row, forComponent: component)
        return title?.attributedTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard pickerView == self.pickerView else {
            assertionFailure("\(#function) called for other picker view. Please don't use this wrapper for other destination")
            return
        }
        if self.delegate.textField(self.textField, pickerView: self.pickerView, shouldUpdateTextFromRow: row, inComponent: component) {
            let title = self.dataSource.textField(self.textField, pickerView: self.pickerView, titleForRow: row, forComponent: component)
            if let title = title?.title {
                self.textField.text = title
            } else if let attributedTitle = title?.attributedTitle {
                self.textField.attributedText = attributedTitle
            } else {
                self.textField.text = nil
            }
        }
        self.delegate.textField(self.textField, pickerView: self.pickerView, didSelectRow: row, inComponent: component)
    }
    
}

// MARK: - Wrapper Associated Object
fileprivate var textFieldPickerViewWrapperKey: String = "TextFieldPickerViewWrapper.textField"
fileprivate extension UITextField {
    
    /// Get associated `TableViewData` object with this table view controller. Will create new one if associated object is nil
    var pickerViewWrapper: TextFieldPickerViewData? {
        set {
            objc_setAssociatedObject(self, &textFieldPickerViewWrapperKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &textFieldPickerViewWrapperKey) as? TextFieldPickerViewData
        }
    }
    
}
