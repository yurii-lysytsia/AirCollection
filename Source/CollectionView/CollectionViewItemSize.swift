//
//  CollectionViewItemSize.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct CoreGraphics.CGSize
import struct CoreGraphics.CGFloat
import class UIKit.UICollectionView

extension UICollectionView {

    public enum ItemSize {
        
        /// Fixed collection view item size
        case fixedSize(CGSize)
        
        /// Flexible collection view item size. Size for item will be calulated automatically based on the parameters `horizontally` and `vertically` count. Than save to cache. For example if `horizontally` is `3` and `vertically` is `4`, collection view will display a grid (3 x 4) with equal items size and spaces. Counts is `CGFloat` and contains floating point, so when you set `horizontally` is `1.5` and `vertically` is `1`, collection view will display horizontal line items when first items will display and second will display only half item
        case flexibleItems(horizontally: CGFloat, vertically: CGFloat)
    }
    
}
