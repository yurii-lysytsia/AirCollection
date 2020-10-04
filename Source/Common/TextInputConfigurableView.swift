//
//  TextInputConfigurableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 14.09.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

import class UIKit.UIView

/// Abstract protocol needed for implement *TextInputConfigurableView* that defines one method *configure(textInputView:)* and associated *TextInputView* type.
///
/// You shouldn't use this protocol for your views (include cells) implementation, but you able to create additional protocol that implement default implementation.
///
/// See [TextFieldConfiguration](https://github.com/YuriFox/AirCollection/blob/master/README_VIEW.md#text-field-configuration) for your custom implementation sample.
public protocol TextInputConfiguration {
    
    /// Predefined text input view type.
    associatedtype TextInputView: UIView
    
    /// Method called when text input view have to update.
    ///
    /// You should use this method for create custom text imput configuration implementation. See [TextFieldConfiguration](https://github.com/YuriFox/AirCollection/blob/master/README_VIEW.md#text-field-configuration) for your custom implementation sample.
    ///
    /// - Parameter textInputView: Predefined text input view which needs to configure
    func configure(textInputView: TextInputView)
    
}

/// Aditional protocol for *ConfigurableView.Model* that defines new property *textInputConfiguration* and associated *Configuration* type.
///
/// Use this protocol for *ConfigurableView.Model* and implement *textInputConfiguration* with type that you need. e.g. *TextFieldConfiguration*
public protocol TextInputConfigurableModel {
    
    /// Predefined *ConfigurableView.Model* text input configuration.
    associatedtype Configuration: TextInputConfiguration
    
    /// Reference for text input configuration.
    var textInputConfiguration: Configuration { get }
    
}

/// Child `ModelConfigurableView` protocol implementation and defines new property *textInputView* and associated *TextInputView* type.
///
/// Use this protocol when you need observe some text input subview (e.g. *UITextField* or *UITextView*) inside your reusable view.
///
/// **Important!** This protocol is able to implement only for `Model` which implement [TextInputConfigurableModel](https://github.com/YuriFox/AirCollection/blob/master/README_VIEW.md#text-input-configurable-model).
public protocol TextInputConfigurableView: ModelConfigurableView where Model: TextInputConfigurableModel {
    
    /// Predefined text input view type for configure this view.
    associatedtype TextInputView: UIView
    
    /// Reference for text input view.
    var textInputView: TextInputView { get }
    
}

public extension TextInputConfigurableView where Model: TextInputConfigurableModel, TextInputView == Model.Configuration.TextInputView {

    /// Overridden abstract method that called when view have to update.
    ///
    /// **Caution!** Don't override this method implementation because it able to break other functionality
    ///
    /// - Parameter model: Any model that will use for update view
    func configure(_ model: Any) {
        guard let predefinedModel = model as? Model else {
            assertionFailure("\(#function). `\(String(reflecting: Self.self))` not able to `configure(model:)` because received model `\(String(reflecting: type(of: model).self))` not confirm to `\(String(reflecting: Model.self))`")
            return
        }
        // Base view configuration
        self.configure(model: predefinedModel)
        // Configure text input view with configuration
        let configuration = predefinedModel.textInputConfiguration
        configuration.configure(textInputView: self.textInputView)
    }
    
}
