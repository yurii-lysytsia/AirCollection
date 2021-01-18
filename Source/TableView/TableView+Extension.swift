//
//  UITableView+Extension.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 27.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct CoreGraphics.CGSize
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGFloat
import class UIKit.UIColor
import class UIKit.UIView
import class UIKit.UITableView
import class UIKit.UITableViewCell
import class UIKit.UITableViewHeaderFooterView

// MARK: - Register cell / header / footer

public extension UITableView {
    
    /// Registers a class for use in creating new table cells.
    func register<T: UITableViewCell>(_ cellClass: T.Type) where T: IdentificableView {
        self.register(cellClass, forCellReuseIdentifier: cellClass.viewIdentifier)
    }
    
    /// Registers a nib object containing a cell with the table view under a specified identifier.
    func register<T: UITableViewCell>(_ cellClass: T.Type) where T: NibLoadableView {
        self.register(cellClass.viewNib, forCellReuseIdentifier: cellClass.viewIdentifier)
    }
    
    /// Registers a class for use in creating new table header or footer views.
    func register<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) where T: IdentificableView {
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: viewClass.viewIdentifier)
    }
    
    /// Registers a nib object containing a header or footer with the table view under a specified identifier.
    func register<T: UITableViewHeaderFooterView>(_ viewClass: T.Type) where T: NibLoadableView {
        self.register(viewClass.viewNib, forHeaderFooterViewReuseIdentifier: viewClass.viewIdentifier)
    }
    
}

// MARK: - Empty header / footer

extension UITableView {
    
    private func tableHeaderFooterView(color: UIColor? = nil, hideSeparator: Bool) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: hideSeparator ? 1 : 0)
        let view = UIView(frame: frame)
        view.backgroundColor = self.backgroundColor
        return view
    }
    
    /// Set empty `tableHeaderView` with similar with `tableView` color or custom `color`.
    public final func addTableHeaderView(color: UIColor? = nil, hideFirstSeparator: Bool) {
        let view = self.tableHeaderFooterView(color: color, hideSeparator: hideFirstSeparator)
        self.tableHeaderView = view
    }
    
    /// Set empty `tableFooterView` with similar with `tableView` color or custom `color`.
    public final func addTableFooterView(color: UIColor? = nil, hideLastSeparator: Bool) {
        let view = self.tableHeaderFooterView(color: color, hideSeparator: hideLastSeparator)
        self.tableFooterView = view
    }
    
}

// MARK: - Dynamic header / footer

extension UITableView {
    
    private func resizeView(_ view: UIView?, additionalConstant: CGFloat?) -> UIView? {
        // Check is view valid
        guard let view = view else {
            return nil
        }
        // Calculate optimal size for view
        var size = view.systemLayoutSizeFitting(
            CGSize(width: frame.width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        // Add additional height if need
        if let additionalConstant = additionalConstant {
            size.height += additionalConstant
        }
        // Update view size and return if it changed
        guard view.frame.height != size.height else {
            // Just skip because view size haven't changed
            return nil
        }
        view.frame.size = size
        return view
    }
    
    /// Resize table header view to the optimal size of the view based on its constraints and the specified fitting priorities.
    /// - Parameter additionalConstant: Additional constraints to height.
    public final func fitHeaderTableViewHeight(additionalConstant: CGFloat? = nil) {
        guard let headerView = resizeView(tableHeaderView, additionalConstant: additionalConstant) else {
            return
        }
        tableHeaderView = headerView
    }

    /// Resize table footer view to the optimal size of the view based on its constraints and the specified fitting priorities.
    /// - Parameter additionalConstant: Additional constraints to height.
    public final func fitFooterViewHeight(_ additionalConstant: CGFloat? = nil) {
        guard let footerView = resizeView(tableFooterView, additionalConstant: additionalConstant) else {
            return
        }
        tableFooterView = footerView
    }
    
}
