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
    
}
