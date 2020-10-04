# AirCollection.View

All `AirCollection` views (include cells) based on few protocols. View can implement several protocols to describe needed functionality

## IdentificableView
Protocol needed for implement unique view identifier and defines only one property `viewIdentifier`. By default this property is equal to `String(describing: self)`
```swift
public protocol IdentificableView: class {
    static var viewIdentifier: String { get }   
}
```

`NibLoadableView` and `ConfigurableView` will be described here

Not available now but will be fixed soon


