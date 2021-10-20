//
//  StaticTableSectionHeaderView.swift
//  Example
//
//  Created by Lysytsia Yurii on 18.01.2021.
//  Copyright © 2021 Lysytsia Yurii. All rights reserved.
//

import UIKit
import Source

class StaticTableSectionHeaderView: UITableViewHeaderFooterView, ModelConfigurableView {

    // MARK: Outlet properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = UIColor.gray
        return label
    }()
    
    // MARK: Lifecycle
    private func commonInit() {
        // Configure view
        contentView.backgroundColor = UIColor.groupTableViewBackground
        contentView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        contentView.addSubview(titleLabel)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = contentView.bounds.inset(by: layoutMargins)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var fitSize = size
        titleLabel.preferredMaxLayoutWidth = size.width - layoutMargins.left - layoutMargins.right
        fitSize = titleLabel.intrinsicContentSize
        fitSize.height += layoutMargins.top + layoutMargins.bottom
        return fitSize
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

