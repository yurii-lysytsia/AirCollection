//
//  CollectionViewData.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGSize
import struct UIKit.UIEdgeInsets
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
    weak var scrollViewDelegate: UIScrollViewDelegate?
    
    /// Array of sections (array of items) with estimated sizes for collection view cell. First array is equal to `IndexPath.section`, second to `IndexPath.row`
    private var estimatedSizeForItems = [[CGSize]]()
    
    /// Array of sections with estimated sizes for collection view header. Element of array is equal to `IndexPath.section`
    private var estimatedSizeForHeaders = [CGSize]()
    
    /// Array of sections with estimated sizes for collection view footer. Element of array is equal to `IndexPath.section`
    private var estimatedSizeForFooters = [CGSize]()
    
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
        configurableCell.configure(model: model)
    }

    func configureHeaderView(_ view: UICollectionReusableView, for section: Int) {
        guard let model = self.output.collectionHeaderModel(for: section) else {
            return
        }
        guard let configurableView = view as? ConfigurableView else {
            assertionFailure("For use `CollectionViewData.configureHeaderView(_:for:)`and configure header view you must implement `ConfigurableView` protocol for header view type `\(type(of: view))`")
            return
        }
        configurableView.configure(model: model)
    }

    func configureFooterView(_ view: UICollectionReusableView, for section: Int) {
        guard let model = self.output.collectionFooterModel(for: section) else {
            return
        }
        guard let configurableView = view as? ConfigurableView else {
            assertionFailure("For use `CollectionViewData.configureFooterView(_:for:)`and configure footer view you must implement `ConfigurableView` protocol for footer view type `\(type(of: view))`")
            return
        }
        configurableView.configure(model: model)
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
        self.scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.scrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.scrollViewDelegate?.viewForZooming?(in: scrollView)
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.scrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.scrollViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
}

// MARK: - UICollectionViewDelegate
extension CollectionViewData: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.output.collectionItemDidSelect(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.output.collectionItemDidDeselect(at: indexPath)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewData: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let estimatedSize = self.estimatedSizeForItems[safe: indexPath.section]?[safe: indexPath.row], estimatedSize != UICollectionViewFlowLayout.automaticSize {
            return estimatedSize
        }
        
        switch self.output.collectionItemSize(for: indexPath) {
        case .fixedSize(let size):
            return size
            
        case .flexibleItems(let horizontallyItems, let verticallyItems):
            let sectionInset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
            let minimumLineSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: indexPath.section)
            let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
            
            let horizontallySpace = sectionInset.left + sectionInset.right + (minimumInteritemSpacing * (horizontallyItems - 1))
            let width = (collectionView.bounds.width - horizontallySpace) / horizontallyItems
            
            let verticallySpace = sectionInset.top + sectionInset.bottom + (minimumLineSpacing * (verticallyItems - 1))
            let height = (collectionView.bounds.height - verticallySpace) / verticallyItems
            
            let size = CGSize(width: width, height: height)
            self.estimatedSizeForItems[indexPath.section][indexPath.row] = size
            return size
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let estimatedSize = self.estimatedSizeForHeaders[safe: section], estimatedSize != UICollectionViewFlowLayout.automaticSize {
            return estimatedSize
        }
        
        switch self.output.collectionHeaderHeight(for: section) {
        case .none:
            return CGSize.zero
            
        case .flexible:
            let indexPath = IndexPath(row: 0, section: section)
            let view = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            let targetSize = CGSize(width: collectionView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
            let prefferedSize = view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            let size =  CGSize(width: collectionView.bounds.width, height: prefferedSize.height)
            self.estimatedSizeForHeaders[section] = size
            return size

        case .fixedHeight(let height):
            guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                assertionFailure("Collection flow layout must be `UICollectionViewFlowLayout` type for using `fillEqually` size")
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let estimatedSize = self.estimatedSizeForFooters[safe: section], estimatedSize != UICollectionViewFlowLayout.automaticSize {
            return estimatedSize
        }
        
        switch self.output.collectionFooterHeight(for: section) {
        case .none:
            return CGSize.zero
            
        case .flexible:
            let indexPath = IndexPath(row: 0, section: section)
            let view = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionFooter, at: indexPath)
            let targetSize = CGSize(width: collectionView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
            let prefferedSize = view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            let size =  CGSize(width: collectionView.bounds.width, height: prefferedSize.height)
            self.estimatedSizeForFooters[section] = size
            return size

        case .fixedHeight(let height):
            guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                assertionFailure("Collection flow layout must be `UICollectionViewFlowLayout` type for using `fillEqually` size")
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
    
}
