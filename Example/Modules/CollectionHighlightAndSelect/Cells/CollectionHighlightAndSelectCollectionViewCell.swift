//
//  CollectionHighlightAndSelectCollectionViewCell.swift
//  Example
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

class CollectionHighlightAndSelectCollectionViewCell: UICollectionViewCell, IdentificableView, ModelConfigurableView, HighlightableView, SelectableView {
    
    // MARK: Stored properties
    private let contentViewColor = UIColor.systemBlue.withAlphaComponent(0.1)
    private let contentViewHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
    private let contentViewSelectedColor = UIColor.systemBlue
    
    private let titleLabelColor = UIColor.systemBlue
    private let titleLabelHighlightedColor = UIColor.systemBlue.withAlphaComponent(0.5)
    private let titleLabelSelectedColor = UIColor.white
    
    // MARK: Outlet properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Lifecycle
    private func commonInit() {
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = self.contentViewColor
        self.titleLabel.textColor = self.titleLabelColor
        self.titleLabel.frame = self.bounds
        self.addSubview(self.titleLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = self.contentView.bounds.width * 0.1
    }
    
    // MARK: Functions
    func configure(model: Model) {
        self.titleLabel.text = model.title
    }
    
    func didSetHighlighted(_ highlighted: Bool, animated: Bool) {
        let duration = animated ? CATransaction.animationDuration() : 0
        UIView.animate(withDuration: duration) {
            self.titleLabel.textColor = highlighted ? self.titleLabelHighlightedColor : self.titleLabelColor
            self.contentView.backgroundColor = highlighted ? self.contentViewHighlightedColor : self.contentViewColor
        }
    }
    
    func didSetSelected(_ selected: Bool, animated: Bool) {
        let duration = animated ? CATransaction.animationDuration() : 0
        UIView.animate(withDuration: duration) {
            self.titleLabel.textColor = selected ? self.titleLabelSelectedColor : self.titleLabelColor
            self.contentView.backgroundColor = selected ? self.contentViewSelectedColor : self.contentViewColor
        }
    }
    
    // MARK: Helpers
    struct Model {
        let title: String
    }
}
