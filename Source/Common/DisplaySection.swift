//
//  DisplaySection.swift
//  Source
//
//  Created by Lysytsia Yurii on 19.01.2021.
//  Copyright © 2021 Lysytsia Yurii. All rights reserved.
//

open class DisplaySection<SectionKey, RowKey>: Equatable where SectionKey: Equatable, RowKey: Equatable {
    
    // MARK: Properties [Public]
    
    public let sectionKey: SectionKey
    open internal(set) var rows: [Row]
    
    // MARK: Lifecycle
    
    public init(sectionKey: SectionKey, rows: [Row] = []) {
        self.sectionKey = sectionKey
        self.rows = rows
    }
    
    // MARK: Functions
    
    func setRows(_ rows: [Row]) {
        self.rows = rows
    }
    
    func rows(for rowKey: RowKey) -> [Row] {
        return rows.filter({ $0.rowKey == rowKey })
    }
    
    func firstRow(for rowKey: RowKey) -> Row? {
        return rows.first(where: { $0.rowKey == rowKey })
    }
 
    // MARK: Equatable
    
    public static func == (lhs: DisplaySection, rhs: DisplaySection) -> Bool {
        return lhs.sectionKey == rhs.sectionKey
    }
    
    // MARK: Helpers
    
    public typealias Row = DisplayRow<RowKey>
    
}

public extension DisplaySection where RowKey: CaseIterable {
 
    open func configureRows(transform: (RowKey) -> Row) {
        self.rows = RowKey.allCases.map(transform)
    }
    
}
