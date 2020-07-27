//
//  NibLoadableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import class UIKit.UINib
import class UIKit.UIView

public protocol NibLoadableView: IdentificableView {
    
    /// Default nib name for this view. Default is `IdentificableView.viewIdentifier`
    static func nibName() -> String
    
    /// Default created nib for this view using bunle for `Self`
    static func nib() -> UINib
    
    /// Unarchives and instantiates the in-memory contents of the receiver’s nib file, creating a distinct object tree and set of top level objects. Caution This method may be unsafe!
    static func loadFromNib() -> Self
    
    /// Unarchives and instantiates the in-memory contents of the receiver’s nib file, creating a distinct object tree and set of top level objects. Caution This method may be unsafe!
    static func loadFromNib(owner: Any) -> Self
    
    /// Unarchives and instantiates the in-memory contents of the receiver’s nib file, creating a distinct object tree and set of top level objects. Caution This method may be unsafe!
    static func loadFromNib(owner: Any, options: [UINib.OptionsKey : Any]?) -> Self
    
}

public extension NibLoadableView {
    
    static func nibName() -> String {
        return self.viewIdentifier
    }
    
}

public extension NibLoadableView where Self: UIView {
    
    static func nib() -> UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: self.nibName(), bundle: bundle)
    }
    
    static func loadFromNib() -> Self {
        return self.loadFromNib(owner: self)
    }
    
    static func loadFromNib(owner: Any) -> Self {
        return self.loadFromNib(owner: owner, options: nil)
    }
    
    static func loadFromNib(owner: Any, options: [UINib.OptionsKey : Any]?) -> Self {
        return nib().instantiate(withOwner: owner, options: options).first as! Self
    }
    
}
