//
//  ModelConfigurableView.swift
//  Source
//
//  Created by Lysytsia Yurii on 04.10.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

/// Base *ConfigurableView* protocol implementation and defines new one safe method *configure(model:)* based on predefined associated *Model* type.
///
/// You should use this protocol for your views (include cells) implementation instead *ConfigurableView*.
///
/// Read more about [ModelConfigurableView](https://github.com/YuriFox/AirCollection/blob/master/README_VIEW.md#model-configurable-view).
public protocol ModelConfigurableView: ConfigurableView {
    
    /// Predefined model type for configure this view.
    associatedtype Model
    
    /// Configure view with predefined model type.
    ///
    /// By default this method use as delegate and called when abstract *configure(_:)* method called with similar *Model* type parameter.
    ///
    /// - Parameter model: Predefined model that will use for update view.
    func configure(model: Model)
    
}

extension ModelConfigurableView {
    
    /// Overridden abstract method that called when view have to update.
    ///
    /// **Caution!** Don't override this method implementation because it able to break other functionality
    ///
    /// - Parameter model: Any model that will use for update view
    public func configure(_ model: Any) {
        guard let predefinedModel = model as? Model else {
            assertionFailure("\(#function). `\(String(reflecting: Self.self))` not able to `configure(model:)` because received model `\(String(reflecting: type(of: model).self))` not confirm to `\(String(reflecting: Model.self))`")
            return
        }
        self.configure(model: predefinedModel)
    }
    
}
