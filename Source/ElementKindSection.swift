//
//  ElementKindSection.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import class UIKit.UICollectionView

extension UICollectionView {
 
    public enum ElementKindSection: String {
        /// A supplementary view that identifies the header for a given section. The same as `UICollectionView.elementKindSectionHeader`
        case header
        
        /// A supplementary view that identifies the footer for a given section. The same as `UICollectionView.elementKindSectionFooter`
        case footer
        
        public var rawValue: String {
            switch self {
            case .header: return UICollectionView.elementKindSectionHeader
            case .footer: return UICollectionView.elementKindSectionFooter
            }
        }
        
        public init(rawValue: String) {
            switch rawValue {
            case UICollectionView.elementKindSectionHeader:
                self = .header
            case UICollectionView.elementKindSectionFooter:
                self = .footer
            default:
                fatalError("\(String(describing: UICollectionView.ElementKindSection.self)) can't initialize `init(rawValue:)` with raw value `\(rawValue)`. Please check and use only  `UICollectionView.elementKindSectionHeader` or `UICollectionView.elementKindSectionFooter`")
            }
        }
        
    }

    
}
