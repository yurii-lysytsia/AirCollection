//
//  New.swift
//  Source
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import Foundation

public protocol SelectableView: class {
    
    /// A Boolean value that indicates whether the view is selected.
    var isSelected: Bool { get }
    
    /// Sets the selected state of the cell, optionally animating the transition between states.
    /// - Parameters:
    ///   - selected: `true` to set the cell as selected, `false` to set it as unselected.
    ///   - animated: `true` to animate the transition between selected states, `false` to make the transition immediate.
    func didSetSelected(_ selected: Bool, animated: Bool)
    
}
