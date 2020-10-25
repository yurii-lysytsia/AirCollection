//
//  TableHightlightAndSelectTableViewCell.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

class TableHightlightAndSelectTableViewCell: UITableViewCell, IdentificableView, ModelConfigurableView, HighlightableView, SelectableView {

    // MARK: Stored properties
    private let contentViewColor = UIColor.white
    private let contentViewHighlightedColor = UIColor.white
    private let contentViewSelectedColor = UIColor.white
    
    private let titleLabelColor = UIColor.black
    private let titleLabelHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
    private let titleLabelSelectedColor = UIColor.systemBlue
    
    // MARK: Outlet properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    // MARK: Lifecycle
    private func commonInit() {
        self.selectionStyle = .none
        self.backgroundColor = self.contentViewColor
        self.contentView.backgroundColor = self.contentViewColor
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.textColor = self.titleLabelColor
        self.addSubview(self.titleLabel)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.bounds.inset(by: self.layoutMargins)
    }
    
    func didSetHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
            self.titleLabel.textColor = highlighted ? self.titleLabelHighlightedColor : self.titleLabelColor
            self.backgroundColor = highlighted ? self.contentViewHighlightedColor : self.contentViewColor
            self.contentView.backgroundColor = highlighted ? self.contentViewHighlightedColor : self.contentViewColor
        })
    }
    
    func didSetSelected(_ selected: Bool, animated: Bool) {
        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
            self.titleLabel.textColor = selected ? self.titleLabelSelectedColor : self.titleLabelColor
            self.backgroundColor = selected ? self.contentViewSelectedColor : self.contentViewColor
            self.contentView.backgroundColor = selected ? self.contentViewSelectedColor : self.contentViewColor
        })
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
