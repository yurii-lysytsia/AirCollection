//
//  IdentificableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

public protocol IdentificableView: class {
    
    /// Unique view identefier. Default is `String(describing: self)`
    static var viewIdentifier: String { get }
    
}

public extension IdentificableView {
    
    static var viewIdentifier: String {
        return String(describing: self)
    }
    
}
