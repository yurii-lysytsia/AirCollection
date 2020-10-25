//
//  UIRefreshControl+Extension.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import class UIKit.UIRefreshControl
import func Foundation.objc_setAssociatedObject
import func Foundation.objc_getAssociatedObject

extension UIRefreshControl {
    
    private var handler: ((UIRefreshControl) -> Void)? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.handler, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.handler) as? ((UIRefreshControl) -> Void)
        }
    }
    
    func setHandler(_ handler: ((UIRefreshControl) -> Void)?) {
        if let handler = handler {
            self.handler = handler
            self.addTarget(self, action: #selector(handleValueChanged(_:)), for: .valueChanged)
        } else {
            self.handler = nil
            self.removeTarget(self, action: #selector(handleValueChanged(_:)), for: .valueChanged)
        }
    }
    
    @objc private func handleValueChanged(_ sender: UIRefreshControl) {
        self.handler?(sender)
    }
 
    private enum AssociatedKeys {
        static var handler = "UIRefreshControl.handler"
    }
    
}
