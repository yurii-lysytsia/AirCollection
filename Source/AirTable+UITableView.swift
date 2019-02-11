//
//  AirTable+UITableView.swift
//  AirCollection
//
//  Created by Yuri Fox on 2/11/19.
//  Copyright © 2019 Developer Lysytsia. All rights reserved.
//

import UIKit

fileprivate var InstanceKey = "AirTableInstance"

extension UITableView {
    
    /// Returns the associated **AirTable** with this table view.
    ///
    /// If associated object not exist or has another generic types will be created a new one
    ///
    /// - Returns: Associated **AirTable**
    public func air<Cell: UITableViewCell, Item>() -> AirTable<Cell, Item> {
        
        if let object = objc_getAssociatedObject(self, &InstanceKey) {
            if let air = object as? AirTable<Cell, Item> {
                return air
            } else {
                objc_setAssociatedObject(self, &InstanceKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        
        let air = AirTable<Cell, Item>(tableView: self)
        objc_setAssociatedObject(self, &InstanceKey, air, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return air
        
    }
    
}
