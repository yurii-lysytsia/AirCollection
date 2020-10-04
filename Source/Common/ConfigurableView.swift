//
//  ConfigurableView.swift
//  AirCollection
//
//  Created by Lysytsia Yurii on 15.07.2020.
//  Copyright © 2020 Lysytsia Yurii. All rights reserved.
//

/// Abstract protocol needed for implement configure view method and defines one method *configure(_:)*.
///
/// You shouldn't use this protocol for your views (include cells) implementation, but you able to create additional protocol that implement default implementation. See [ModelConfigurableView](https://github.com/YuriFox/AirCollection/blob/master/README_VIEW.md#model-configurable-view) for your custom implementation sample.
///
/// Read more about [ConfigurableView](https://github.com/YuriFox/AirCollection/blob/master/README_VIEW.md#configurable-view).
public protocol ConfigurableView: class {
    
    /// Abstract method called when view have to update.
    ///
    /// You shouldn't use this method implementation, but you able to create additional protocol that implement default implementation based on this method. See [ModelConfigurableView](https://github.com/YuriFox/AirCollection/blob/master/README_VIEW.md#model-configurable-view) for your custom implementation sample.
    ///
    /// - Parameter model: any model that will use for update view
    func configure(_ model: Any)
    
}
