//
//  AirTableProtocol.swift
//  AirCollection
//
//  Created by Yuri Fox on 2/11/19.
//  Copyright © 2019 Developer Lysytsia. All rights reserved.
//

import UIKit

public protocol AirTableProtocol: class, UITableViewDataSource, UITableViewDelegate {
    
//    // MARK: UITableViewDataSource
//    var numberOfSectionsHandler: (UITableView) -> Int { get set }
//    var numberOfRowsInSectionHandler: (UITableView, Int) -> Int { get set }
//    var cellForRowAtIndexPathHandler: (UITableView, IndexPath) -> UITableViewCell { get set }
//    var titleForHeaderInSectionHandler: (UITableView, Int) -> String? { get set }
//    var titleForFooterInSectionHandler: (UITableView, Int) -> String? { get set }
//    var canEditRowAtIndexPathHandler: (UITableView, IndexPath) -> Bool { get set }
//    var canMoveRowAtIndexPathHandler: (UITableView, IndexPath) -> Bool { get set }
//    var sectionIndexTitlesHandler: (UITableView) -> [String]? { get set }
//    var sectionForSectionIndexTitleHandler: (UITableView, String, Int) -> Int { get set }
//    var commitEditingStyleAtIndexPathHandler: (UITableView, UITableViewCell.EditingStyle, IndexPath) -> Void { get set }
//    var moveRowAtIndexPathToDestinationIndexPathHandler: (UITableView, IndexPath, IndexPath) -> IndexPath { get set }
//
//    // MARK: UITableViewDelegate
//    var willDisplayCellAtIndexPathHandler: (UITableView, UITableViewCell, IndexPath) -> Void { get set }
//    var willDisplayHeaderViewForSectionHandler: (UITableView, UIView, Int) -> Void { get set }
//    var willDisplayFooterViewForSectionHandler: (UITableView, UIView, Int) -> Void { get set }
//    var didEndDisplayingCellForRowAtIndexPathHandler: (UITableView, UITableViewCell, IndexPath) -> Void { get set }
//    var didEndDisplayingHeaderViewForSectionHandler: (UITableView, UIView, Int) -> Void { get set }
//    var didEndDisplayingFooterViewForSectionHandler: (UITableView, UIView, Int) -> Void { get set }
//    var heightForRowAtIndexPathHandler: (UITableView, IndexPath) -> CGFloat { get set }
//    var heightForFooterInSectionHandler: (UITableView, Int) -> CGFloat { get set }
//    var estimatedHeightForRowAtIndexPathHandler: (UITableView, IndexPath) -> CGFloat { get set }
//    var estimatedHeightForHeaderInSectionHandler: (UITableView, Int) -> CGFloat { get set }
//    var estimatedHeightForFooterInSectionHandler: (UITableView, Int) -> CGFloat { get set }
//    var viewForHeaderInSectionHandler: (UITableView, Int) -> UIView? { get set }
//    var viewForFooterInSectionHandler: (UITableView, Int) -> UIView? { get set }
//    var accessoryButtonTappedForRowWithIndexPathHandler: (UITableView, IndexPath) -> Void { get set }
//    var shouldHighlightRowAtIndexPathHandler: (UITableView, IndexPath) -> Bool { get set }
//    var didHighlightRowAtIndexPathHandler: (UITableView, IndexPath) -> Void { get set }
//    var didUnhighlightRowAtIndexPathHandler: (UITableView, IndexPath) -> Void { get set }
//    var willSelectRowAtIndexPathHandler: (UITableView, IndexPath) -> IndexPath? { get set }
//    var willDeselectRowAtIndexPathHandler: (UITableView, IndexPath) -> IndexPath? { get set }
//    var didSelectRowAtIndexPathHandler: (UITableView, IndexPath) -> Void { get set }
//    var didDeselectRowAtIndexPathHandler: (UITableView, IndexPath) -> Void { get set }
//    var editingStyleForRowAtIndexPathHandler: (UITableView, IndexPath) -> UITableViewCell.EditingStyle { get set }
//    var titleForDeleteConfirmationButtonForRowAtIndexPathHandler: (UITableView, IndexPath) -> String? { get set }
//    var editActionsForRowAtIndexPathHandler: (UITableView, IndexPath) -> [UITableViewRowAction]? { get set }
//    @available(iOS 11.0, *)
//    var leadingSwipeActionsConfigurationForRowAtIndexPathHandler: (UITableView, IndexPath) -> UISwipeActionsConfiguration? { get set }
//    @available(iOS 11.0, *)
//    var trailingSwipeActionsConfigurationForRowAtIndexPathHandler: (UITableView, IndexPath) -> UISwipeActionsConfiguration? { get set }
//    var shouldIndentWhileEditingRowAtIndexPathHandler: (UITableView, IndexPath) -> Bool { get set }
//    var willBeginEditingRowAtIndexPathHandler: (UITableView, IndexPath) -> Void { get set }
//    var didEndEditingRowAtIndexPathHander: (UITableView, IndexPath) -> Void { get set }
//    var targetIndexPathForMoveFromRowAtSourceIndexPathToProposedIndexPathHandler: (UITableView, IndexPath, IndexPath) -> IndexPath { get set }
//    var indentationLevelForRowAtIndexPathHandler: (UITableView, IndexPath) -> Int { get set }
//    var shouldShowMenuForRowAtIndexPathHandler: (UITableView, IndexPath) -> Bool { get set }

//    @available(iOS 5.0, *)
//    optional public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool
//
//    @available(iOS 5.0, *)
//    optional public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)
//
//    @available(iOS 9.0, *)
//    optional public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
//
//    @available(iOS 9.0, *)
//    optional public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool
//
//    @available(iOS 9.0, *)
//    optional public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
//
//    @available(iOS 9.0, *)
//    optional public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
//
//    @available(iOS 11.0, *)
//    optional public func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool

    // MARK: UIScrollViewDelegate

//    @available(iOS 2.0, *)
//    optional public func scrollViewDidScroll(_ scrollView: UIScrollView) // any offset changes
//
//    @available(iOS 3.2, *)
//    optional public func scrollViewDidZoom(_ scrollView: UIScrollView) // any zoom scale changes
//
//
//    // called on start of dragging (may require some time and or distance to move)
//    @available(iOS 2.0, *)
//    optional public func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
//
//    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
//    @available(iOS 5.0, *)
//    optional public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
//
//    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//    @available(iOS 2.0, *)
//    optional public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
//
//
//    @available(iOS 2.0, *)
//    optional public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) // called on finger up as we are moving
//
//    @available(iOS 2.0, *)
//    optional public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) // called when scroll view grinds to a halt
//
//
//    @available(iOS 2.0, *)
//    optional public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
//
//
//    @available(iOS 2.0, *)
//    optional public func viewForZooming(in scrollView: UIScrollView) -> UIView? // return a view that will be scaled. if delegate returns nil, nothing happens
//
//    @available(iOS 3.2, *)
//    optional public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) // called before the scroll view begins zooming its content
//
//    @available(iOS 2.0, *)
//    optional public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) // scale between minimum and maximum. called after any 'bounce' animations
//
//
//    @available(iOS 2.0, *)
//    optional public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES
//
//    @available(iOS 2.0, *)
//    optional public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) // called when scrolling animation finished. may be called immediately if already at top
//
//
//    /* Also see -[UIScrollView adjustedContentInsetDidChange]
//     */
//    @available(iOS 11.0, *)
//    optional public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
    
}
