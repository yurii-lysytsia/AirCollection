//
//  DisplayRow.swift
//  Source
//
//  Created by Lysytsia Yurii on 19.01.2021.
//  Copyright © 2021 Lysytsia Yurii. All rights reserved.
//

open class DisplayRow<RowKey>: Equatable where RowKey: Equatable {
    
    // MARK: Properties [Public]
    
    public let rowKey: RowKey
    public let cellType: IdentificableView.Type
    public let viewModel: Any?
    
    // MARK: Lifecycle
    
    public init(rowKey: RowKey, cellType: IdentificableView.Type, viewModel: Any? = nil) {
        self.rowKey = rowKey
        self.cellType = cellType
        self.viewModel = viewModel
    }
    
    // MARK: Equatable
    
    public static func == (lhs: DisplayRow, rhs: DisplayRow) -> Bool {
        return lhs.rowKey == rhs.rowKey
    }
    
}
