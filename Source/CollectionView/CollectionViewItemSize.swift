//
//  CollectionViewItemSize.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct CoreGraphics.CGSize
import struct CoreGraphics.CGFloat

public struct CollectionViewItemSize {
    
    public let width: Distribution
    public let height: Distribution
    
    init(width: Distribution, height: Distribution) {
        self.width = width
        self.height = height
    }
    
    public enum Distribution {
        
        /// Fixed item size for width or height
        case fixed(CGFloat)
        
        /// Fill item size for full available width or height and divided for `items` count
        case fillEquall(items: CGFloat)
        
        /// Item width will calculate relative height or height will calculated relative widht multiplier. Don't use for both because it will fatal error.
        case aspectRatio(multiplier: CGFloat)
        
        /// Item size will calculete based on autolayouts
        case flexible
        
        /// Fill item size for full available width or height. The same as `fillEquall(items: 1)`
        static let fill = Distribution.fillEquall(items: 1)
        
    }
    
    /// Fixed collection view item size
    public static func fixedSize(_ size: CGSize) -> CollectionViewItemSize {
        return CollectionViewItemSize(width: .fixed(size.width), height: .fixed(size.height))
    }
    
    /// Flexible collection view item size. Size for item will be calulated automatically based on the parameters `horizontally` and `vertically` count. Than save to cache. For example if `horizontally` is `3` and `vertically` is `4`, collection view will display a grid (3 x 4) with equal items size and spaces. Counts is `CGFloat` and contains floating point, so when you set `horizontally` is `1.5` and `vertically` is `1`, collection view will display horizontal line items when first items will display and second will display only half item
    public static func flexibleItems(horizontally: CGFloat, vertically: CGFloat) -> CollectionViewItemSize {
        return CollectionViewItemSize(width: .fillEquall(items: horizontally), height: .fillEquall(items: vertically))
    }
    
    /// Flexible collection view items size. Size for item will be calulated automatically based on collection view width, items per row and height. Than save to cache. Item width will be equal to collection view width minus left and right insets, interitem spacing and devided to items per row. Item height will be equal to `height`.
    public static func flexibleHorizontallyItems(itemsPerRow: CGFloat, height: CGFloat) -> CollectionViewItemSize {
        return CollectionViewItemSize(width: .fillEquall(items: itemsPerRow), height: .fixed(height))
    }
    
    /// Flexible collection view items size. Size for item will be calulated automatically based on collection view height, items per row and width. Than save to cache. Item height will be equal to collection view height minus top and bottom insets, line spacing and devided to items per row. Item width will be equal to `width`.
    public static func flexibleVerticallyItems(itemsPerRow: CGFloat, width: CGFloat) -> CollectionViewItemSize {
        return CollectionViewItemSize(width: .fixed(width), height: .fillEquall(items: itemsPerRow))
    }
    
    /// Flixible collection view items size. Size for item will be calulated automatically based on collection view width, items per row and aspect ratio. Than save to cache. Item width will be equal to collection view width minus left and right insets, interitem spacing and devided to items per row. Item height will be equal to item width multiply aspect ratio.
    public static func flexibleHorizontallyItems(itemsPerRow: CGFloat, heightAspectRatioMultiplier: CGFloat) -> CollectionViewItemSize {
        return CollectionViewItemSize(width: .fillEquall(items: itemsPerRow), height: .aspectRatio(multiplier: heightAspectRatioMultiplier))
    }
    
    /// Flixible collection view items size. Size for item will be calulated automatically based on collection view height, items per row and aspect ratio. Than save to cache. Item height will be equal to collection view height minus top and bottom insets, line spacing and devided to items per row. Item width will be equal to item height multiply aspect ratio.
    public static func flexibleVerticallyItems(itemsPerRow: CGFloat, widthAspectRatioMultiplier: CGFloat)  -> CollectionViewItemSize {
        return CollectionViewItemSize(width: .aspectRatio(multiplier: widthAspectRatioMultiplier), height: .fillEquall(items: itemsPerRow))
    }
    
    /// Flexible collection view items size. Size for item will be calulated automatically based on collection view width and items per row. Than save to cache. Item width will be equal to collection view width minus left and right insets, interitem spacing and devided to items per row. Item height will be calculated based on autolayouts.
    public static func flexibleHorizontallyItems(itemsPerRow: CGFloat) -> CollectionViewItemSize {
        return CollectionViewItemSize(width: .fillEquall(items: itemsPerRow), height: .flexible)
    }
    
    /// Flexible collection view items size. Size for item will be calulated automatically based on collection view height, items per row and width. Than save to cache. Item height will be equal to collection view height minus top and bottom insets, line spacing and devided to items per row. Item width will be calculated based on autolayouts.
    public static func flexibleVerticallyItems(itemsPerRow: CGFloat) -> CollectionViewItemSize {
        return CollectionViewItemSize(width: .flexible, height: .fillEquall(items: itemsPerRow))
    }
    
}
