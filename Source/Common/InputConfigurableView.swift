//
//  TextInputConfigurableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 14.09.2020.
//  Copyright © 2020 Developer Lysytsia. All rights reserved.
//

import Foundation

public protocol TextInputConfigurableView: ModelConfigurableView {
    var textInputView: TextInputView { get }
    func configureTextInputView(model: Model)
    associatedtype TextInputView
}

public extension TextInputConfigurableView {

    func configure(model: Any?) {
        guard let configurableModel = model as? Model else {
            assertionFailure("Invalid model for configure view of type `\(type(of: self))`. Model is not confirm to model type \(Model.self)")
            return
        }
        self.configure(model: configurableModel)
        self.configureTextInputView(model: configurableModel)
    }
    
    
}
