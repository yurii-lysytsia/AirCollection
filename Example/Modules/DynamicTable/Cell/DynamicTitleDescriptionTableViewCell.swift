//
//  DynamicTitleDescriptionTableViewCell.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

class DynamicTitleDescriptionTableViewCell: UITableViewCell, IdentificableView, NibLoadableView, ModelConfigurableView {
    
    // MARK: Outlet properties
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configure title label
        self.titleLabel.numberOfLines = 2
        self.titleLabel.textColor = .black
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        // Configure description label
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.textColor = .darkGray
        self.descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    // MARK: Functions
    func configure(model: Model) {
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.description
        self.descriptionLabel.isHidden = model.description == nil
    }
    
    // MARK: Helpers
    struct Model {
        let title: String
        let description: String?
    }
    
}
