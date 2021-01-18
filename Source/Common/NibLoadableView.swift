//
//  NibLoadableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import class UIKit.UINib
import class UIKit.UIView
import class Foundation.Bundle

/// Protocol needed for implement view nib instantiate and defines only one property *viewNib*.
///
/// Read more about [NibLoadableView](https://github.com/YuriFox/AirCollection/blob/master/README_VIEW.md#nib-loadable-view).
public protocol NibLoadableView: IdentificableView {
    
    /// Created nib instance for this view.
    static var viewNib: UINib { get }
    
}

public extension NibLoadableView {
    
    /// Created nib instance for this view. Will use *viewIdentifier* for nibName and *Bundle(for: Self.self)* for bunlde by default.
    static var viewNib: UINib {
        let nibName = self.viewIdentifier
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: nibName, bundle: bundle)
    }
    
    /// Unarchives and instantiates the in-memory contents of the receiver’s nib file, creating a distinct object tree and set of top level objects.
    /// - Parameters:
    ///   - owner: The object to use as the owner of the nib file. If the nib file has an owner, you must specify a valid object for this parameter.
    ///   - options: A dictionary containing the options to use when opening the nib file. For a list of available keys for this dictionary, see NSBundle UIKit Additions.
    static func loadFromNib(owner: Any? = nil, options: [UINib.OptionsKey : Any]? = nil) -> Self {
        return self.viewNib.instantiate(withOwner: owner, options: options).first as! Self
    }
    
}
