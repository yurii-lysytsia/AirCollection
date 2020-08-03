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
        
        /// Flexible collection view items size. Size for item will be calulated automatically based on collection view width, items per row and aspect ratio. Than save to cache. Item width will be equal to collection view width minus left and right insets, interitem spacing and devided to items per row. Item height will be equal to item width multiply aspect ratio.
        case flexibleHorizontallyItems(itemsPerRow: CGFloat, aspectRatio: CGFloat)

        /// Flexible collection view items size. Size for item will be calulated automatically based on collection view height, items per row and aspect ratio. Than save to cache. Item height will be equal to collection view height minus top and bottom insets, line spacing and devided to items per row. Item width will be equal to item height multiply aspect ratio.
        case flexibleVerticallyItems(itemsPerRow: CGFloat, aspectRatio: CGFloat)
        
        /// Flixible collection view items size. Size for item will be calulated automatically based on collection view width and aspect ratio. Than save to cache. Item width will be equal to collection view width minus left and right insets. Item height will be equal to item width multiply aspect ratio.
        case flexibleItemsWidth(aspectRatio: CGFloat)
        
        /// Flixible collection view items size. Size for item will be calulated automatically based on collection view height and aspect ratio. Than save to cache. Item height will be equal to collection view hieght minus top and bottom insets. Item width will be equal to item height multiply aspect ratio.
        case flexibleItemsHeight(aspectRatio: CGFloat)
        
    }
    
}
