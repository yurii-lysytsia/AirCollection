//
//  CollectionViewController+TextFieldPickerView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 20.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import class UIKit.UITextField
import class UIKit.UIPickerView

// MARK: - TextFieldPickerViewDataSource
extension CollectionViewControllerProtocol where Self: TextFieldPickerViewDataSource & PickerViewControllerProtocol {
    
    public func textField(_ textField: UITextField, numberOfComponentsInPickerView pickerView: UIPickerView) -> Int {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return 0
        }
        return self.pickerViewPresenter.pickerViewNumberOfComponents(at: indexPath)
    }
    
    public func textField(_ textField: UITextField, pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return 0
        }
        return self.pickerViewPresenter.pickerViewNumberOfRows(inComponent: component, at: indexPath)
    }
    
    public func textField(_ textField: UITextField, pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> PickerViewTitle? {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return nil
        }
        return self.pickerViewPresenter.pickerViewTitle(for: row, inComponent: component, at: indexPath)
    }
    
}

// MARK: - TextFieldPickerViewDelegate
extension CollectionViewControllerProtocol where Self: TextFieldPickerViewDelegate & PickerViewControllerProtocol {

    public func textField(_ textField: UITextField, pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return
        }
        self.pickerViewPresenter.pickerViewDidSelectRow(row, inComponent: component, at: indexPath)
    }

    public func textField(_ textField: UITextField, pickerView: UIPickerView, selectedRowInComponent component: Int) -> Int {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return 0
        }
        return self.pickerViewPresenter.pickerViewSelectedRow(inComponent: component, at: indexPath)
    }
    
}
