//
//  DynamicStoryTableViewCell.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

class DynamicStoryTableViewCell: UITableViewCell, IdentificableView, NibLoadableView, TextInputConfigurableView {
    
    // MARK: Outlet properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    // MARK: Computed property
    var textInputView: UITextView {
        return self.descriptionTextView
    }
    
    // MARK: Functions
    func configure(model: Model) {
        self.titleLabel.text = model.title
        self.descriptionTextView.text = model.description
    }
    
    // MARK: Helpers
    struct Model: TextInputConfigurableModel {
        let title: String
        let description: String
        let textInputConfiguration: TextViewConfiguration
    }
    
}
