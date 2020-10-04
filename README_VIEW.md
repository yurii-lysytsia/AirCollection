# AirCollection.View
All `AirCollection` views (include cells) based on protocols. View able to implement several protocols to describe needed functionality

- [Base protocols](#base-protocols)
    - [Identificable View](#identificable-view)
    - [Nib Loadable View](#nib-loadable-view)
    - [Configurable View](#configurable-view)
    - [Model Configurable View](#model-configurable-view)
    - [Text Input Configurable View](#text-input-configurable-view)
- [Table view cell](#table-view-cell)
    - [Code layouts](#code-layouts)
    - [Xib layouts](#xib-layouts)
- [Collection view cell](#collection-view-cell)

## Base protocols

### Identificable View
Protocol needed for implement unique view identifier and defines only one property `viewIdentifier`. By default this property is equal to `String(describing: self)`
```swift
public protocol IdentificableView: class {
    static var viewIdentifier: String { get }   
}
```

### Nib Loadable View
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

### Configurable View
Abstract protocol needed for implement configure view method and defines one method `configure(_:)`. You shouldn't use this protocol for your views (include cells) implementation, but you able to create additional protocol that implement default implementation. Read about [ModelConfigurableView](#model-configurable-view) for additional information
``` swift
public protocol ConfigurableView: class {
    func configure(_ model: Any)
}
```

### Model Configurable View
Base `ConfigurableView` protocol implementation and defines new one safe method `configure(model:)` based on predefined associated `Model` type. You should use this protocol for your views (include cells) implementation instead `ConfigurableView`
```swift
public protocol ModelConfigurableView: ConfigurableView {
    associatedtype Model
    func configure(model: Model)   
}
```

### Text Input Configurable View
```swift
```

#### TextInputConfigurableModel

#### TextInputConfiguration
#### TextFieldConfiguration
#### TextFieldPickerViewConfiguration
#### TextFieldDatePickerConfiguration
#### TextFieldConfiguration

## Table view cell
Table view cell should implement [Identificable View](#identificable-view), one child implementation of [Configurable View](#configurable-view) and optionally [Nib Loadable View](#nib-loadable-view) if cell layouts have `Xib` file.

### Code layouts
First of all create your `UITableViewCell` class and implement `IdentificableView` and `ModelConfigurableView` protocols.
```swift
class TableViewCell: UITableViewCell, IdentificableView, ModelConfigurableView
```

Than add needed subviews and their layouts. In my example it just `titleLabel`
```swift
private let titleLabel: UILabel = UILabel()

override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.addSubview(self.titleLabel)
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

override func layoutSubviews() {
    super.layoutSubviews()
    self.titleLabel.frame = self.bounds.inset(by: self.layoutMargins)
}
```

Finally implement `ModelConfigurableView`. Create predefined model for configuration (in my example is `struct Model`) with needed primitive properties (in my example is `let title: String`) and add required `configure(model:)` method where configure all needed subviews by predefined model properties. **Caution!** Make sure you are using a `configure(model: Model)` and `configure(_ model: Any)`.
```swift
func configure(model: Model) {
    self.titleLabel.text = model.title
}

struct Model {
    let title: String
}
```

There is the simplest example when you need to create table view cell with code layouts. For more details see [StaticTableViewCell](Example/Modules/StaticTable/Cell/StaticTableViewCell.swift) in my project example

### Xib layouts
First of all create your `UITableViewCell` class and implement `IdentificableView`, `NibLoadableView` and `ModelConfigurableView` protocols.
```swift
class NibTableViewCell: UITableViewCell, IdentificableView, NibLoadableView, ModelConfigurableView
```

Than add outlets for subviews and `.xib` file for layouts. In my example it `titleLabel` and `descriptionLabel`
```swift
@IBOutlet private weak var titleLabel: UILabel!
@IBOutlet private weak var descriptionLabel: UILabel!
```

Finally implement `ModelConfigurableView`. Create predefined model for configuration (in my example is `struct Model`) with needed primitive properties (in my example is `let title: String` and `let description: String?`) and add required `configure(model:)` method where configure all needed subviews by predefined model properties. **Caution!** Make sure you are using a `configure(model: Model)` and `configure(_ model: Any)`.
```swift
func configure(model: Model) {
    self.titleLabel.text = model.title
    self.descriptionLabel.text = model.description
    self.descriptionLabel.isHidden = model.description == nil
}
   
struct Model {
    let title: String
    let description: String?
}
```

## Collection view cell
