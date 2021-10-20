//
//  DisplayCollection.swift
//  Source
//
//  Created by Lysytsia Yurii on 19.01.2021.
//  Copyright © 2021 Lysytsia Yurii. All rights reserved.
//

import struct Foundation.IndexPath
import class Foundation.NSObject

// TODO: - Сделать протокол DisplayCollection в него вынести обязательные методы

/// Нужно наследовать и при помощи массива моделей или ключей создавать массив секций со всеми данными. Так же возвращать все нужные данные по индексу или наоборот.
open class DisplayCollection<SectionKey, RowKey>: NSObject where SectionKey: Equatable, RowKey: Equatable {
    
    // MARK: Properties [Public]
    
    open internal(set) var sections: [Section]
    
    // MARK: Lifecycle
    
    public init(sections: [Section] = []) {
        self.sections = sections
    }
    
    // MARK: Functions
    
    open func setSections(_ sections: [Section]) {
        self.sections = sections
    }
    
    open func numberOfSection() -> Int {
        return sections.count
    }
    
    open func numberOfRows(in section: Int) -> Int {
        return sections[section].rows.count
    }
    
    open func row(at indexPath: IndexPath) -> Section.Row {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    open func rowKey(for indexPath: IndexPath) -> RowKey {
        return row(at: indexPath).rowKey
    }
    
    open func rowIdentifier(for indexPath: IndexPath) -> String {
        return row(at: indexPath).cellType
    }
 
    open func rowViewModel(for indexPath: IndexPath) -> Any? {
        return row(at: indexPath).viewModel
    }
    
    // MARK: Helpers
    
    public typealias Section = DisplaySection<SectionKey, RowKey>
    
}

public extension DisplayCollection where SectionKey: CaseIterable {
 
    func configureSections(transform: (SectionKey) -> Section) {
        self.sections = SectionKey.allCases.map(transform)
    }
    
}
