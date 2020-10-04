//
//  UITableView+Extension.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 27.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import class UIKit.UITableView
import class UIKit.UITableViewCell
import class UIKit.UITableViewHeaderFooterView

public extension UITableView {
    
    /// Registers a class for use in creating new table cells.
    func register<T: UITableViewCell>(_ cellClass: T.Type) where T: IdentificableView {
        self.register(cellClass, forCellReuseIdentifier: cellClass.viewIdentifier)
    }
    
    /// Registers a nib object containing a cell with the table view under a specified identifier.
    func register<T: UITableViewCell>(_ cellClass: T.Type) where T: NibLoadableView & IdentificableView {
        self.register(cellClass.viewNib, forCellReuseIdentifier: cellClass.viewIdentifier)
    }
    
    /// Registers a class for use in creating new table header or footer views.
    func register<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) where T: IdentificableView {
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: viewClass.viewIdentifier)
    }
    
    /// Registers a nib object containing a header or footer with the table view under a specified identifier.
    func register<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) where T: NibLoadableView & IdentificableView {
        self.register(viewClass.viewNib, forHeaderFooterViewReuseIdentifier: viewClass.viewIdentifier)
    }
    
}
