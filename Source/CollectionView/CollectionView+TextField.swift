//
//  CollectionView+TextField.swift
//  Source
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import class UIKit.UITextField

extension CollectionViewControllerProtocol where Self: TextFieldControllerProtocol {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return true
        }
        return self.textFieldPresenter.textFieldShouldBeginEditing(at: indexPath)
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return
        }
        self.textFieldPresenter.textFieldDidBeginEditing(at: indexPath)
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return true
        }
        return self.textFieldPresenter.textFieldShouldEndEditing(at: indexPath)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return
        }
        self.textFieldPresenter.textFieldDidEndEditing(at: indexPath)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: Range<String.Index>, replacementString string: String) -> Bool {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return true
        }
        return self.textFieldPresenter.textField(at: indexPath, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return true
        }
        return self.textFieldPresenter.textFieldShouldClear(at: indexPath)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return true
        }
        return self.textFieldPresenter.textFieldShouldReturn(at: indexPath)
    }
    
    public func textFieldEditingChanged(_ textField: UITextField) {
        guard let indexPath = self.indexPathForItem(with: textField) else {
            assertionFailure("\(#function) called but `textField` didn't find on `collectionView` items. Please don't use this method for other destination")
            return
        }
        self.textFieldPresenter.textFieldTextDidChanged(textField.text, at: indexPath)
    }
    
}

