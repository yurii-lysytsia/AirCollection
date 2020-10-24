//
//  PickerViewTitle.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 19.09.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation.NSAttributedString

// MARK: - PickerViewTitle
public enum PickerViewTitle {
    case title(String)
    case attributedTitle(NSAttributedString)
    
    public var title: String? {
        switch self {
        case let .title(title):
            return title
        default:
            return nil
        }
    }
    
    public var attributedTitle: NSAttributedString? {
        switch self {
        case let .attributedTitle(attributedTitle):
            return attributedTitle
        default:
            return nil
        }
    }
    
}
