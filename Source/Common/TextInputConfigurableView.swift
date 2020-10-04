//
//  TextInputConfigurableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 14.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import class UIKit.UIView

public protocol TextInputConfiguration {
    func configure(textInputView: TextInputView)
    associatedtype TextInputView: UIView
}

public protocol TextInputConfigurableModel {
    var textInputConfiguration: Configuration { get }
    associatedtype Configuration: TextInputConfiguration
}

public protocol TextInputConfigurableView: ModelConfigurableView where Model: TextInputConfigurableModel {
    var textInputView: TextInputView { get }
    associatedtype TextInputView: UIView
}

public extension TextInputConfigurableView where Model: TextInputConfigurableModel, TextInputView == Model.Configuration.TextInputView {

    func configure(_ model: Any) {
        guard let configurableModel = model as? Model else {
            assertionFailure("Invalid model for configure view of type `\(type(of: self))`. Model is not confirm to model type \(Model.self)")
            return
        }
        self.configure(model: configurableModel)
        
        // Configure text input view with configuration
        let configuration = configurableModel.textInputConfiguration
        configuration.configure(textInputView: self.textInputView)
    }
    
    
}
