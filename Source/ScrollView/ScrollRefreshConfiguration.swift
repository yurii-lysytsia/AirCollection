//
//  ScrollRefreshConfiguration.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import class UIKit.UIColor
import class Foundation.NSAttributedString

public struct ScrollRefreshConfiguration {
    
    /// The tint color for the refresh control.
    public let tintColor: UIColor?
    
    /// The styled title text to display in the refresh control.
    public let attributedTitle: NSAttributedString?
    
    public init(tintColor: UIColor? = nil, attributedTitle: NSAttributedString? = nil) {
        self.tintColor = tintColor
        self.attributedTitle = attributedTitle
    }
    
}
