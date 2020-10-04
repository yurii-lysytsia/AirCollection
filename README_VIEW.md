# AirCollection.View

All `AirCollection` views (include cells) based on few protocols. View can implement several protocols to describe needed functionality

## IdentificableView
Protocol needed for implement unique view identifier and defines only one property `viewIdentifier`. By default this property is equal to `String(describing: self)`
```swift
public protocol IdentificableView: class {
    static var viewIdentifier: String { get }   
}
```

## NibLoadableView
Protocol needed for implement view nib instantiate and defines only one property `viewNib`
```swift
public protocol NibLoadableView {
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

`ConfigurableView` will be described here

Not available now but will be fixed soon


