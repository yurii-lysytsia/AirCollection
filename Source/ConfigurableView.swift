//
//  ConfigurableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

// MARK: - ConfigurableView
public protocol ConfigurableView: IdentificableView {
    
    /// Configure view with some non specific model
    func configure(model: Any?)
    
}

// MARK: - ModelConfigurableView
public protocol ModelConfigurableView: ConfigurableView {
    
    /// Configure view with some specific model type
    func configure(model: Model)
    
    associatedtype Model
    
}

public extension ModelConfigurableView {
    
    func configure(model: Any?) {
        guard let configurableModel = model as? Model else {
            assertionFailure("Invalid model for configure view of type `\(type(of: self))`. Model is not confirm to model type \(Model.self)")
            return
        }
        self.configure(model: configurableModel)
    }
    
}

// MARK: - InputModelConfigurableView
public protocol InputModelConfigurableView: ModelConfigurableView {
    var inputModelView: InputModelView { get }
    func configureInputModel(inputModel: InputModel)
    associatedtype InputModel
    associatedtype InputModelView
}

public extension InputModelConfigurableView {
    
    func configure(model: Any?) {
        if let configurableModel = model as? Model {
            self.configure(model: configurableModel)
        } else {
            assertionFailure("Model is not \(Model.self) type")
        }
        
        if let configurableInputModel = model as? InputModel {
            self.configureInputModel(inputModel: configurableInputModel)
        } else {
            assertionFailure("Input Model is not \(InputModel.self) type")
        }
    }
    
}

