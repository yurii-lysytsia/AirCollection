//
//  CollectionView+TextView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 05.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import enum UIKit.UITextItemInteraction
import struct Foundation.URL
import class UIKit.UITextView
import class UIKit.NSTextAttachment

extension CollectionViewControllerProtocol where Self: TextViewControllerProtocol {

    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let indexPath = self.indexPathForItem(with: textView) else {
            assertionFailure("\(#function) called but `textView` didn't find on `collectionView` rows. Please don't use this method for other destination")
            return true
        }
        return self.textViewPresenter.textViewShouldBeginEditing(at: indexPath)
    }

    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let indexPath = self.indexPathForItem(with: textView) else {
            assertionFailure("\(#function) called but `textView` didn't find on `collectionView` rows. Please don't use this method for other destination")
            return true
        }
        return self.textViewPresenter.textViewShouldEndEditing(at: indexPath)
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        guard let indexPath = self.indexPathForItem(with: textView) else {
            assertionFailure("\(#function) called but `textView` didn't find on `collectionView` rows. Please don't use this method for other destination")
            return
        }
        self.textViewPresenter.textViewDidBeginEditing(at: indexPath)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        guard let indexPath = self.indexPathForItem(with: textView) else {
            assertionFailure("\(#function) called but `textView` didn't find on `collectionView` rows. Please don't use this method for other destination")
            return
        }
        self.textViewPresenter.textViewDidEndEditing(at: indexPath)
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: Range<String.Index>, replacementText text: String) -> Bool {
        guard let indexPath = self.indexPathForItem(with: textView) else {
            assertionFailure("\(#function) called but `textView` didn't find on `collectionView` rows. Please don't use this method for other destination")
            return true
        }
        return self.textViewPresenter.textView(at: indexPath, shouldChangeTextIn: range, replacementText: text)
    }

    public func textViewDidChange(_ textView: UITextView) {
        guard let indexPath = self.indexPathForItem(with: textView) else {
            assertionFailure("\(#function) called but `textView` didn't find on `collectionView` rows. Please don't use this method for other destination")
            return
        }
        self.textViewPresenter.textViewDidChange(text: textView.text, at: indexPath)
    }

    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: Range<String.Index>, interaction: UITextItemInteraction) -> Bool {
        guard let indexPath = self.indexPathForItem(with: textView) else {
            assertionFailure("\(#function) called but `textView` didn't find on `collectionView` rows. Please don't use this method for other destination")
            return true
        }
        return self.textViewPresenter.textView(at: indexPath, shouldInteractWith: URL, in: characterRange, interaction: interaction)
    }

    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: Range<String.Index>, interaction: UITextItemInteraction) -> Bool {
        guard let indexPath = self.indexPathForItem(with: textView) else {
            assertionFailure("\(#function) called but `textView` didn't find on `collectionView` rows. Please don't use this method for other destination")
            return true
        }
        return self.textViewPresenter.textView(at: indexPath, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction)
    }
    
}

