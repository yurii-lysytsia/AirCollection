//
//  HighlightableView.swift
//  Source
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation

public protocol HighlightableView: class {
    
    /// Sets the highlighted state of the cell, optionally animating the transition between states.
    /// - Parameters:
    ///   - highlighted: `true` to set the cell as highlighted, `false` to set it as unhighlighted.
    ///   - animated: `true` to animate the transition between highlighted states, `false` to make the transition immediate.
    func setHighlighted(_ highlighted: Bool, animated: Bool)
    
}
