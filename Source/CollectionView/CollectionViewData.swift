//
//  CollectionViewData.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct Foundation.IndexPath
import struct Foundation.IndexSet
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
import struct UIKit.UIEdgeInsets
import struct UIKit.UILayoutPriority
import class Foundation.NSObject
import class UIKit.UIView
import class UIKit.UIScrollView
import class UIKit.UICollectionView
import class UIKit.UICollectionViewCell
import class UIKit.UICollectionReusableView
import class UIKit.UICollectionViewLayout
import class UIKit.UICollectionViewFlowLayout
import protocol UIKit.UICollectionViewDataSource
import protocol UIKit.UIScrollViewDelegate
import protocol UIKit.UICollectionViewDelegate
import protocol UIKit.UICollectionViewDelegateFlowLayout

class CollectionViewData: NSObject {

    // MARK: Stored properties
    weak var collectionViewDelegate: CollectionViewDelegate?
    
    /// Cached collection view size for items
    private var preferredCollectionViewSizeForItems: CGSize = .zero
    
    /// Cached collection view size for supplementary view
    private var preferredCollectionViewSizeForSupplementaryView: CGSize = .zero
    
    /// Array of sections (array of items) with estimated sizes for collection view cell. First array is equal to `IndexPath.section`, second to `IndexPath.row`
    private var estimatedSizeForItems = [[CGSize]]()
    
    /// Array of sections with estimated sizes for collection view header. Element of array is equal to `IndexPath.section`
    private var estimatedSizeForHeaders = [CGSize]()
    
    /// Array of sections with estimated sizes for collection view footer. Element of array is equal to `IndexPath.section`
    private var estimatedSizeForFooters = [CGSize]()
    
    /// Cached collection view cell implementation for identifiers. Need for optimization when calculate dynamic cell size with similar type
    private var cachedReusableCell = [String : UICollectionViewCell]()
    
    // MARK: Dependency injection
    private unowned let input: CollectionViewControllerProtocol
    private unowned let output: CollectionViewPresenterProtocol
    
    // MARK: Initialize
    init(input: CollectionViewControllerProtocol, output: CollectionViewPresenterProtocol) {
        self.input = input
        self.output = output
    }
    
    // MARK: Reload
    
    /// Reload all (remove cache) collection view data
    func reloadAll() {
        self.estimatedSizeForItems.removeAll()
        self.estimatedSizeForHeaders.removeAll()
        self.estimatedSizeForFooters.removeAll()
        self.cachedReusableCell.removeAll()
    }
    
    // MARK: Sections
    
    /// Reload (remove cache) for specific section of collection view data
    func reloadSection(_ section: Int) {
        if self.estimatedSizeForItems.indices.contains(section) {
            self.estimatedSizeForItems[section].removeAll()
        }
        if self.estimatedSizeForHeaders.indices.contains(section) {
            self.estimatedSizeForHeaders[section] = UICollectionViewFlowLayout.automaticSize
        }
        if self.estimatedSizeForFooters.indices.contains(section) {
            self.estimatedSizeForFooters[section] = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    /// Reload (remove cache) for specific sections of collection view data. It's the same as `reloadSection(_:)` but for multiple sections
    func reloadSections(_ sections: [Int]) {
        sections.forEach { self.reloadSection($0) }
    }

    /// Remove cache for specific section of collection view data
    func removeSections(_ sections: [Int]) {
        sections.sorted(by: >).forEach {
            self.estimatedSizeForItems.remove(at: $0)
            self.estimatedSizeForHeaders.remove(at: $0)
            self.estimatedSizeForFooters.remove(at: $0)
        }
    }

    /// Insert `UICollectionViewFlowLayout.automaticSize` cache for specific section of collection view data
    func insertSections(_ sections: [Int]) {
        sections.sorted().forEach {
            self.estimatedSizeForItems.insert([], at: $0)
            self.estimatedSizeForHeaders.insert(UICollectionViewFlowLayout.automaticSize, at: $0)
            self.estimatedSizeForFooters.insert(UICollectionViewFlowLayout.automaticSize, at: $0)
        }
    }
    
    /// Replace cache for specific section of collection view data
    func moveSection(from section: Int, to newSection: Int) {
        self.removeSections([section])
        self.insertSections([section])
    }

    // MARK: Items

    /// Reload (remove cache) for specific index path of collection view data
    func reloadItem(at indexPath: IndexPath) {
        guard self.estimatedSizeForItems.indices.contains(indexPath.section) else {
            return
        }
        guard self.estimatedSizeForItems[indexPath.section].indices.contains(indexPath.row) else {
            return
        }
        self.estimatedSizeForItems[indexPath.section][indexPath.row] = UICollectionViewFlowLayout.automaticSize
    }

    /// Reload (remove cache) for specific index paths of collection view data. It's the same as `reloadItem(at:)` but for multiple index paths
    func reloadItems(at indexPaths: [IndexPath]) {
        indexPaths.forEach { self.reloadItem(at: $0) }
    }

    /// Remove cache for specific index path of collection view data and retun it size
    @discardableResult
    func removeItem(at indexPath: IndexPath) -> CGSize? {
        guard self.estimatedSizeForItems.indices.contains(indexPath.section) else {
            return nil
        }
        guard self.estimatedSizeForItems[indexPath.section].indices.contains(indexPath.row) else {
            return nil
        }
        return self.estimatedSizeForItems[indexPath.section].remove(at: indexPath.row)
    }

    /// Remove cache for specific index paths of collection view data. It's the same as `removeItem(at:)` but for multiple index paths
    func removeItems(at indexPaths: [IndexPath]) {
        indexPaths.sorted(by: >).forEach { self.removeItem(at: $0) }
    }
    
    /// Insert with specific height or `UITableView.automaticDimension` (by default) cache for specific index path of collection view data
    func insertItem(at indexPath: IndexPath, size: CGSize = UICollectionViewFlowLayout.automaticSize) {
        guard self.estimatedSizeForItems.indices.contains(indexPath.section) else {
            return
        }
        self.estimatedSizeForItems[indexPath.section].insert(size, at: indexPath.row)
    }

    /// Insert `UICollectionViewFlowLayout.automaticSize` cache for specific index paths of collection view data. It's the same as `insertItem(at:)` but for multiple index paths
    func insertItems(at indexPaths: [IndexPath]) {
        indexPaths.sorted().forEach { self.insertItem(at: $0) }
    }

    // Delte cache for specific index path of collection view data and insert it to new index path.
    func moveItem(from indexPath: IndexPath, to newIndexPath: IndexPath) {
        guard let size = self.removeItem(at: indexPath) else {
            return
        }
        self.insertItem(at: newIndexPath, size: size)
    }
    
    // MARK: Configure
    func configureCell(_ cell: UICollectionViewCell, for indexPath: IndexPath) {
        guard let model = self.output.collectionItemModel(for: indexPath) else {
            return
        }
        guard let configurableCell = cell as? ConfigurableView else {
            assertionFailure("For use `CollectionViewData.configureCell(_:for:)`and configure cell you must implement `ConfigurableView` protocol for item type `\(type(of: cell))`")
            return
        }
        configurableCell.configure(model)
    }

    func configureHeaderView(_ view: UICollectionReusableView, for section: Int) {
        guard let model = self.output.collectionHeaderModel(for: section) else {
            return
        }
        guard let configurableView = view as? ConfigurableView else {
            assertionFailure("For use `CollectionViewData.configureHeaderView(_:for:)`and configure header view you must implement `ConfigurableView` protocol for header view type `\(type(of: view))`")
            return
        }
        configurableView.configure(model)
    }

    func configureFooterView(_ view: UICollectionReusableView, for section: Int) {
        guard let model = self.output.collectionFooterModel(for: section) else {
            return
        }
        guard let configurableView = view as? ConfigurableView else {
            assertionFailure("For use `CollectionViewData.configureFooterView(_:for:)`and configure footer view you must implement `ConfigurableView` protocol for footer view type `\(type(of: view))`")
            return
        }
        configurableView.configure(model)
    }

}

// MARK: - UICollectionViewDataSource
extension CollectionViewData: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sections = self.output.collectionSections
        self.estimatedSizeForItems = [[CGSize]](repeating: [], count: sections)
        self.estimatedSizeForHeaders = [CGSize](repeating: UICollectionViewFlowLayout.automaticSize, count: sections)
        self.estimatedSizeForFooters = [CGSize](repeating: UICollectionViewFlowLayout.automaticSize, count: sections)
        return sections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = self.output.collectionItems(for: section)
        self.estimatedSizeForItems[section] = [CGSize](repeating: UICollectionViewFlowLayout.automaticSize, count: items)
        return items
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = self.output.collectionItemIdentifier(for: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        self.configureCell(cell, for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let identifier = self.output.collectionHeaderIdentifier(for: indexPath.section) else {
                fallthrough
            }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
            self.configureHeaderView(view, for: indexPath.section)
            return view

        case UICollectionView.elementKindSectionFooter:
            guard let identifier = self.output.collectionFooterIdentifier(for: indexPath.section) else {
                fallthrough
            }
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
            self.configureFooterView(view, for: indexPath.section)
            return view
        default:
            break
        }
        return UICollectionReusableView()
    }
    
}

// MARK: - UIScrollViewDelegate
extension CollectionViewData: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.collectionViewDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.collectionViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.collectionViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.collectionViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.collectionViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.collectionViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.collectionViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.collectionViewDelegate?.viewForZooming?(in: scrollView)
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.collectionViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.collectionViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.collectionViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.collectionViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
}

// MARK: - UICollectionViewDelegate
extension CollectionViewData: UICollectionViewDelegate {
    
    // MARK: Highlight
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return self.output.collectionItemShouldHighlight(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let highlightableView = collectionView.cellForItem(at: indexPath) as? HighlightableView {
            highlightableView.setHighlighted(true, animated: UIView.areAnimationsEnabled)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let highlightableView = collectionView.cellForItem(at: indexPath) as? HighlightableView {
            highlightableView.setHighlighted(false, animated: UIView.areAnimationsEnabled)
        }
    }
    
    // MARK: Selected
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return self.output.collectionItemShouldSelect(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectableView = collectionView.cellForItem(at: indexPath) as? SelectableView {
            selectableView.setSelected(true, animated: UIView.areAnimationsEnabled)
        }
        self.output.collectionItemDidSelect(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectableView = collectionView.cellForItem(at: indexPath) as? SelectableView {
            selectableView.setSelected(false, animated: UIView.areAnimationsEnabled)
        }
        self.output.collectionItemDidDeselect(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.preferredCollectionViewSizeForItems = collectionView.bounds.size
        self.estimatedSizeForItems[indexPath.section][indexPath.row] = cell.bounds.size
        self.collectionViewDelegate?.collectionViewWillDisplayCell(cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Resave estimated size if it's not correct. Usually it happened for first visible items when it rendered first time
        if let height = self.estimatedSizeForItems[safe: indexPath.section]?[safe: indexPath.row], height != cell.bounds.size {
           self.estimatedSizeForItems[indexPath.section][indexPath.row] = cell.bounds.size
        }
        self.collectionViewDelegate?.collectionViewDidEndDisplayingCell(cell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let elementKindSection = CollectionViewElementKindSection(rawValue: elementKind)
        self.preferredCollectionViewSizeForSupplementaryView = collectionView.bounds.size
        switch elementKindSection {
        case .header:
            self.estimatedSizeForHeaders[indexPath.section] = view.bounds.size
        case .footer:
            self.estimatedSizeForFooters[indexPath.section] = view.bounds.size
        }
        self.collectionViewDelegate?.collectionViewWillDisplaySupplementaryView(view, for: elementKindSection, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        let elementKindSection = CollectionViewElementKindSection(rawValue: elementKind)
        switch elementKindSection {
        case .header:
            if let size = self.estimatedSizeForHeaders[safe: indexPath.section], size != view.bounds.size {
                self.estimatedSizeForHeaders[indexPath.section] = view.bounds.size
            }
        case .footer:
            if let size = self.estimatedSizeForFooters[safe: indexPath.section], size != view.bounds.size {
                self.estimatedSizeForFooters[indexPath.section] = view.bounds.size
            }
        }
        self.collectionViewDelegate?.collectionViewDidEndDisplayingSupplementaryView(view, for: elementKindSection, at: indexPath)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewData: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Check is collection view has correct size. Because if size invalid size for item be invalid too
        if collectionView.bounds.size == self.preferredCollectionViewSizeForItems {
            if let size = self.estimatedSizeForItems[safe: indexPath.section]?[safe: indexPath.row], size != UICollectionViewFlowLayout.automaticSize {
                return size
            }
        }
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            assertionFailure("\(#function) support only `UICollectionViewFlowLayout` subclasses to calculate")
            return .zero
        }
        
        // Calculate additional values
        let safeArea = collectionView.safeAreaInsets
        let sectionInset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let minimumVerticalSpacing: CGFloat = {
            switch flowLayout.scrollDirection {
            case .vertical:
                return self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: indexPath.section)
            case .horizontal:
                return self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
            @unknown default:
                return 0
            }
        }()
        let minimumHorizintalSpacing: CGFloat = {
            switch flowLayout.scrollDirection {
            case .vertical:
                return self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
            case .horizontal:
                return self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: indexPath.section)
            @unknown default:
                return 0
            }
        }()
        let itemSize = self.output.collectionItemSize(for: indexPath)
        
        // Calculate item width
        let width: CGFloat
        let flexibleWidth: Bool
        let aspectRatioWidth: Bool
        switch itemSize.width {
        case .fixed(let value):
            width = value
            flexibleWidth = false
            aspectRatioWidth = false
        case .fillEquall(let items):
            let horizontallyInsets = safeArea.left + safeArea.right + sectionInset.left + sectionInset.right
            let horizontallySpace = horizontallyInsets + (minimumHorizintalSpacing * (items - 1))
            width = (collectionView.frame.width - horizontallySpace) / items
            flexibleWidth = false
            aspectRatioWidth = false
        case .aspectRatio(let multiplier):
            width = multiplier
            flexibleWidth = false
            aspectRatioWidth = true
        case .flexible:
            width = 0
            flexibleWidth = true
            aspectRatioWidth = false
        }
        
        // Calculate item height
        let height: CGFloat
        let flexibleHeight: Bool
        let aspectRatioHeight: Bool
        switch itemSize.height {
        case .fixed(let value):
            height = value
            flexibleHeight = false
            aspectRatioHeight = false
        case .fillEquall(let items):
            let verticallyInsets = safeArea.top + safeArea.bottom + sectionInset.top + sectionInset.bottom
            let verticallySpace = verticallyInsets + (minimumVerticalSpacing * (items - 1))
            height = (collectionView.frame.height - verticallySpace) / items
            flexibleHeight = false
            aspectRatioHeight = false
        case .aspectRatio(let multiplier):
            height = multiplier
            flexibleHeight = false
            aspectRatioHeight = true
        case .flexible:
            height = 0
            flexibleHeight = true
            aspectRatioHeight = false
        }
        
        // Create items size
        var targetSize = CGSize(width: width, height: height)
        
        // Calculate dynamic width and/or height
        if flexibleWidth || flexibleHeight {
            // Get dequeue reusable cell or get from cache
            let cell: UICollectionViewCell = {
                let identifier = self.output.collectionItemIdentifier(for: indexPath)
                if let cachedCell = self.cachedReusableCell[identifier] {
                    return cachedCell
                }
                let cell = self.collectionView(collectionView, cellForItemAt: indexPath)
                self.cachedReusableCell[identifier] = cell
                return cell
            }()
            
            // Configure cell for actual data
            self.configureCell(cell, for: indexPath)
            
            // Calculate dynamic size for item
            let horizontalFittingPriority: UILayoutPriority = flexibleWidth ? .fittingSizeLevel : .required
            let verticalFittingPriority: UILayoutPriority = flexibleHeight ? .fittingSizeLevel : .required
            targetSize = cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        }
        
        if aspectRatioWidth && aspectRatioHeight {
            // Throw fatal error if both sides use aspect ratio
            fatalError("\(#function) `.aspectRatio(multiplier:)` don't support for both sides")
        } else if aspectRatioWidth {
            // Calculate width with multiplier
            targetSize.width = targetSize.height * targetSize.width
        } else if aspectRatioHeight {
            // Calculate height with multiplier
            targetSize.height = targetSize.width * targetSize.height
        }
        
        return targetSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Check is collection view has correct size. Because if size invalid size for item be invalid too
        if collectionView.bounds.size == self.preferredCollectionViewSizeForSupplementaryView {
            if let size = self.estimatedSizeForHeaders[safe: section], size != UICollectionViewFlowLayout.automaticSize {
                return size
            }
        }
        let preferredHeight = self.output.collectionHeaderHeight(for: section)
        return self.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForSupplementaryViewInSection: section, kind: UICollectionView.elementKindSectionHeader, preferredHeight: preferredHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // Check is collection view has correct size. Because if size invalid size for item be invalid too
        if collectionView.bounds.size == self.preferredCollectionViewSizeForSupplementaryView {
            if let size = self.estimatedSizeForFooters[safe: section], size != UICollectionViewFlowLayout.automaticSize {
                return size
            }
        }
        let preferredHeight = self.output.collectionFooterHeight(for: section)
        return self.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForSupplementaryViewInSection: section, kind: UICollectionView.elementKindSectionFooter, preferredHeight: preferredHeight)
    }
    
        private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForSupplementaryViewInSection section: Int, kind: String, preferredHeight: CollectionViewSupplementaryViewHeight) -> CGSize {
        switch preferredHeight {
        case .none:
            return CGSize.zero
            
        case .flexible:
            // Get supplementary view
            let indexPath = IndexPath(item: 0, section: section)
            let view = self.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
            // Get target size and calulate optimal size
            var targetSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height)
            targetSize = view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            return targetSize

        case .fixedHeight(let height):
            guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
                assertionFailure("Collection flow layout must be `UICollectionViewFlowLayout` type for using `fixedHeight` size")
                return CGSize.zero
            }
            switch flowLayout.scrollDirection {
            case .horizontal:
                return CGSize(width: height, height: collectionView.bounds.height)

            case .vertical:
                return CGSize(width: collectionView.bounds.width, height: height)

            @unknown default:
                assertionFailure("Unknown collection view layout scroll direction")
                return CGSize.zero
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.output.collectionInset(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.output.collectionMinimumLineSpacing(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.output.collectionMinimumInteritemSpacing(for: section)
    }
    
}
