//
//  HomeRouter.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit

protocol HomeRouterInput: class {
    // Add public presenter flow segues functions
}

final class HomeRouter: HomeRouterInput {
    
    // MARK: Stored properties
    private unowned let viewController: UIViewController
    
    // MARK: Lifecycle
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    class func createModule() -> HomeViewController {
        let view = HomeViewController()
        let interactor = HomeInteractor()
        let router = HomeRouter(viewController: view)
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)
        view.output = presenter
        interactor.output = presenter
        return view
    }
    
    // MARK: Segues

}
