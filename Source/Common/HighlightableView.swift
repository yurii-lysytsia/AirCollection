//
//  HighlightableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation

/// Protocol for views that need observe highlight state and defines one property `isHighlight` and one method `didSetHighlighted(_:,:)`. **Do not confuse** `didSetHighlighted(_:,:)` method with `UITableViewCell.setHighlighted(_:,animated:)` method.
///
/// You can implement this protocol that observe highlight state change and you can set appearance for your `UITableViewCell` or `UICollectionViewCell`
public protocol HighlightableView: AnyObject {
    
    /// A Boolean value that indicates whether the view is selected.
    var isHighlighted: Bool { get }
    
    /// Sets the highlighted state of the cell, optionally animating the transition between states.
    /// - Parameters:
    ///   - highlighted: `true` to set the cell as highlighted, `false` to set it as unhighlighted.
    ///   - animated: `true` to animate the transition between highlighted states, `false` to make the transition immediate.
    func didSetHighlighted(_ highlighted: Bool, animated: Bool)
    
}
