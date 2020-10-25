//
//  ModuleFabric.swift
//  Example
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import UIKit

enum ModuleFabric {
    
    static func createStaticTableModule() -> UIViewController {
        let view = StaticTableViewController()
        let presenter = StaticTablePresenter(view: view)
        view.output = presenter
        return view
    }
    
    static func createDynamicTableModule() -> UIViewController {
        let view = DynamicTableViewController()
        let presenter = DynamicTablePresenter(view: view)
        view.output = presenter
        return view
    }
 
    static func createDynamicUserTableModule(user: User) -> UIViewController {
        let view = DynamicUserTableViewController()
        let presenter = DynamicUserTablePresenter(user: user, view: view)
        view.output = presenter
        return view
    }
    
    static func createDynamicStoryTableModule(story: Story) -> UIViewController {
        let view = DynamicStoryTableViewController()
        let presenter = DynamicStoryTablePresenter(story: story, view: view)
        view.output = presenter
        return view
    }
    
    static func createCollectionHighlightAndSelectModule() -> UIViewController {
        let view = CollectionHighlightAndSelectViewController()
        let presenter = CollectionHighlightAndSelectPresenter(view: view)
        view.output = presenter
        return view
    }
    
}
