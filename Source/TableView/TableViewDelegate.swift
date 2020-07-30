//
//  TableViewDelegate.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 30.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import class UIKit.UIView
import class UIKit.UITableView
import class UIKit.UITableViewCell
import protocol UIKit.UIScrollViewDelegate

/// Delegate tells about table view rows, header and footer displayed state and proxy all methods from `UIScrollViewDelegate`
public protocol TableViewDelegate: UIScrollViewDelegate {
    
    /// Tells the delegate the table view is about to draw a cell for a particular row.
    func tableViewWillDisplayCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
    /// Tells the delegate that the specified cell was removed from the table.
    func tableViewDidEndDisplayingCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
    /// Tells the delegate that the table view is about to go into editing mode.
    func tableViewWillBeginEditingRow(at indexPath: IndexPath)
    
    /// Tells the delegate that the table view has left editing mode
    func tableViewDidEndEditingRow(at indexPath: IndexPath?)
    
    /// Tells the delegate that the table is about to display the header view for the specified section.
    func tableViewWillDisplayHeaderView(_ view: UIView, forSection section: Int)
    
    /// Tells the delegate that the specified header view was removed from the table.
    func tableViewDidEndDisplayingHeaderView(_ view: UIView, forSection section: Int)
    
    /// Tells the delegate that the table is about to display the footer view for the specified section.
    func tableViewWillDisplayFooterView(_ view: UIView, forSection section: Int)
    
    /// Tells the delegate that the specified footer view was removed from the table.
    func tableViewDidEndDisplayingFooterView(_ view: UIView, forSection section: Int)
    
}

public extension TableViewDelegate {
    
    func tableViewWillDisplayCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableViewDidEndDisplayingCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableViewWillBeginEditingRow(at indexPath: IndexPath) {
        
    }
    
    func tableViewDidEndEditingRow(at indexPath: IndexPath?) {
        
    }
    
    func tableViewWillDisplayHeaderView(_ view: UIView, forSection section: Int) {
        
    }
    
    func tableViewDidEndDisplayingHeaderView(_ view: UIView, forSection section: Int) {
        
    }
    
    func tableViewWillDisplayFooterView(_ view: UIView, forSection section: Int) {
        
    }
    
    func tableViewDidEndDisplayingFooterView(_ view: UIView, forSection section: Int) {
        
    }
    
}
