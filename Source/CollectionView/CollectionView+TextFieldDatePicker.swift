//
//  CollectionViewController+TextFieldDatePicker.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 20.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct Foundation.Date
import class UIKit.UITextField
import class UIKit.UIDatePicker

// MARK: - TextFieldPickerViewDelegate
public extension CollectionViewControllerProtocol where Self: DatePickerControllerProtocol & TextFieldDatePickerDelegate {

    func textField(_ textField: UITextField, datePicker: UIDatePicker, didSelectDate date: Date) {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return
        }
        self.datePickerPresenter.datePickerDidSelectDate(date, at: indexPath)
    }
    
    /// Called by the text field picker view when the user selectes a row with, and text field text should update `text` as formatted date view title. Nothing happens if return `nil`
    func textField(_ textField: UITextField, datePicker: UIDatePicker, shouldUpdateTextFromDate date: Date) -> String? {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return nil
        }
        return self.datePickerPresenter.datePickerShouldUpdateTextFromDate(date, at: indexPath)
    }
    
}


