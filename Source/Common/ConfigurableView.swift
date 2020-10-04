//
//  ConfigurableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

// MARK: - ConfigurableView
public protocol ConfigurableView: class {
    
    /// Configure view with some non specific model
    func configure(model: Any?)
    
}

// MARK: - ModelConfigurableView
public protocol ModelConfigurableView: ConfigurableView {
    
    /// Configure view with some specific model type
    func configure(model: Model)
    
    associatedtype Model
    
}

extension ModelConfigurableView {
    
    public func configure(model: Any?) {
        guard let configurableModel = model as? Model else {
            assertionFailure("Invalid model for configure view of type `\(type(of: self))`. Model is not confirm to model type \(Model.self)")
            return
        }
        self.configure(model: configurableModel)
    }
    
}
