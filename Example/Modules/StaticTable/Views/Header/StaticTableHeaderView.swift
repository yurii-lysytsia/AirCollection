//
//  StaticTableHeaderView.swift
//  Example
//
//  Created by Lysytsia Yurii on 18.01.2021.
//  Copyright © 2021 Lysytsia Yurii. All rights reserved.
//

import UIKit

final class StaticTableHeaderView: UIView {
    
    // MARK: Properties [Outlet]
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        label.textColor = UIColor.darkGray
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
        return label
    }()
    
    
    // MARK: Lifecycle
    
    private func commonInit() {
        // Configure view
        backgroundColor = .clear
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        addSubview(titleLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds.inset(by: layoutMargins)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var fitSize = size
        titleLabel.preferredMaxLayoutWidth = size.width - layoutMargins.left - layoutMargins.right
        fitSize = titleLabel.intrinsicContentSize
        fitSize.height += layoutMargins.top + layoutMargins.bottom
        return fitSize
    }
    
}
