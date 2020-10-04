//
//  NibLoadableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import class UIKit.UINib
import class UIKit.UIView

public protocol NibLoadableView: class {
    /// Created nib instance for this view
    static var viewNib: UINib { get }
}

public extension NibLoadableView where Self: IdentificableView {
    
    /// Created nib instance for this view. Will use `viewIdentifier` for nibName and `Bundle(for: Self.self)` for bunlde by default
    static var viewNib: UINib {
        let nibName = self.viewIdentifier
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: nibName, bundle: bundle)
    }
    
}
