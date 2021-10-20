//
//  DynamicUserTableViewCell.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

class DynamicUserTableViewCell: UITableViewCell, TextInputConfigurableView {
    
    // MARK: Outlet properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: Computed properties
    var textInputView: UITextField {
        return self.textField
    }
    
    // MARK: Functions
    func configure(model: Model) {
        self.titleLabel.text = model.title
        self.textField.text = model.text
        self.textField.placeholder = model.title
    }
    
    // MARK: Helpers
    struct Model: TextInputConfigurableModel {
        let title: String
        let text: String
        let textInputConfiguration: TextFieldConfiguration
    }
    
}
