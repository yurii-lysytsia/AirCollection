# AirCollection.View

All `AirCollection` views (include cells) based on few protocols. View able to implement several protocols to describe needed functionality

## Identificable View
Protocol needed for implement unique view identifier and defines only one property `viewIdentifier`. By default this property is equal to `String(describing: self)`
```swift
public protocol IdentificableView: class {
    static var viewIdentifier: String { get }   
}
```

## Nib Loadable View
Protocol needed for implement view nib instantiate and defines only one property `viewNib`
```swift
public protocol NibLoadableView: class {
    static var viewNib: UINib { get }
}
```

This protocol has default implementation for view which implement `IdentificableView` protocol. So when you use both protocols you don't need implement any properties by default
```swift 
static var viewNib: UINib {
    let nibName = self.viewIdentifier
    let bundle = Bundle(for: Self.self)
    return UINib(nibName: nibName, bundle: bundle)
}
```

## Configurable View
Abstract protocol needed for implement configure view method and defines one method `configure(_:)`. You shouldn't use this protocol for your views (include cells) implementation, but you able to create additional protocol that implement default implementation. Read about [ModelConfigurableView](#model-configurable-view) for additional information
``` swift
public protocol ConfigurableView: class {
    func configure(_ model: Any)
}
```

## Model Configurable View
Base `ConfigurableView` protocol implementation and defines new one safe method `configure(model:)` based on predefined associated `Model` type. You should use this protocol for your views (include cells) implementation instead `ConfigurableView`
```swift
public protocol ModelConfigurableView: ConfigurableView {
    associatedtype Model
    func configure(model: Model)   
}
```
