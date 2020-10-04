//
//  HomeTableViewCell.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

class HomeTableViewCell: UITableViewCell, IdentificableView, NibLoadableView, ModelConfigurableView {    
        
    // MARK: Outlet properties
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }
    
    // MARK: Functions
    func configure(model: Model) {
        self.titleLabel.text = model.title
    }
    
    // MARK: Helpers
    struct Model {
        let title: String
    }
    
}
