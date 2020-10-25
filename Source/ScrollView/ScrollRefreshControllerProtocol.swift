//
//  ScrollRefreshControllerProtocol.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 25.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import class UIKit.UIScrollView
import class UIKit.UIRefreshControl
import func Foundation.objc_setAssociatedObject
import func Foundation.objc_getAssociatedObject

public protocol ScrollRefreshControllerProtocol: class {
    
    /// Configure refresh control view for scroll view using reference to refresh presenter where will delegate all view action. You can customize refresh control using configuration.
    func configureScrollRefresh(for scrollView: UIScrollView, using presenter: ScrollRefreshPresenterProtocol, configuration: ScrollRefreshConfiguration)
    
    /// Show and start animating refresh activity indicator.
    func showScrollRefreshControl()
    
    /// Hide and stop animating refresh activity indicator.
    func hideScrollRefreshControl()
    
}

public extension ScrollRefreshControllerProtocol {
    
    /// Gets weak reference of scroll view. Return `nil` if reference invalid or `configureScrollRefresh(for:, using:, configuration:)` haven't called.
    private var scrollView: UIScrollView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.scrollView, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.scrollView) as? UIScrollView
        }
    }
    
    /// Gets weak reference of scroll refresh presenter. Return `nil` if reference invalid or `configureScrollRefresh(for:, using:, configuration:)` haven't called.
    private var presenter: ScrollRefreshPresenterProtocol? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.presenter, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.presenter) as? ScrollRefreshPresenterProtocol
        }
    }
    
    private var refreshControl: UIRefreshControl? {
        return self.scrollView?.refreshControl
    }
    
    func configureScrollRefresh(for scrollView: UIScrollView, using presenter: ScrollRefreshPresenterProtocol, configuration: ScrollRefreshConfiguration) {
        let refreshControl = UIRefreshControl()
        if let tintColor = configuration.tintColor {
            refreshControl.tintColor = tintColor
        }
        if let attributedTitle = configuration.attributedTitle {
            refreshControl.attributedTitle = attributedTitle
        }
        refreshControl.setHandler { [weak self] (refreshControl) in
            self?.presenter?.scrollDidShowRefreshControl()
        }
        scrollView.refreshControl = refreshControl
        self.scrollView = scrollView
        self.presenter = presenter
    }
    
    /// Configure refresh control view for scroll view using reference to refresh presenter where will delegate all view action.
    func configureScrollRefresh(for scrollView: UIScrollView, using presenter: ScrollRefreshPresenterProtocol) {
        let configuration = ScrollRefreshConfiguration(tintColor: nil, attributedTitle: nil)
        self.configureScrollRefresh(for: scrollView, using: presenter, configuration: configuration)
    }
    
    func showScrollRefreshControl() {
        self.refreshControl?.beginRefreshing()
    }
    
    func hideScrollRefreshControl() {
        self.refreshControl?.endRefreshing()
        self.presenter?.scrollDidHideRefreshControl()
    }
    
}

// MARK: - AssociatedKeys
fileprivate enum AssociatedKeys {
    static var scrollView = "ScrollRefreshControllerProtocol.scrollView"
    static var presenter = "ScrollRefreshControllerProtocol.presenter"
}
