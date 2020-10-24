//
//  IdentificableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

/// Protocol needed for implement unique view identifier and defines only one property *viewIdentifier*.
///
/// Read more about [IdentificableView](https://github.com/YuriFox/AirCollection/blob/master/README_VIEW.md#identificable-view).
public protocol IdentificableView: class {
    
    /// Unique view identefier.
    ///
    /// Default is *String.init(describing: self)*.
    static var viewIdentifier: String { get }
    
}

public extension IdentificableView {
    
    static var viewIdentifier: String {
        return String(describing: self)
    }
    
}
