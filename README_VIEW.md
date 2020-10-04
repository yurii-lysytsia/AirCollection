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
    - [Implement `TextInputConfigurableView`](#implement-textinputconfigurableview)
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
Child `ModelConfigurableView` protocol implementation and defines new property `textInputView` and associated `TextInputView` type. Use this protocol when you need observe some text input subview (e.g. `UITextField` or `UITextView`) inside your reusable view. **Important!** This protocol is able to implement only for `Model` which implement [TextInputConfigurableModel](#text-input-configurable-model).
```swift
public protocol TextInputConfigurableView: ModelConfigurableView where Model: TextInputConfigurableModel {
    associatedtype TextInputView: UIView
    var textInputView: TextInputView { get }
}
```

#### Text Input Configurable Model
Aditional protocol for `ConfigurableView.Model` that defines new property `textInputConfiguration` and associated `Configuration` type. Read topics below for aditional information
```swift
public protocol TextInputConfigurableModel {
    associatedtype Configuration: TextInputConfiguration
    var textInputConfiguration: Configuration { get }
}
```

Use this protocol for `ConfigurableView.Model` and implement `textInputConfiguration` with type that you need. e.g. `TextFieldConfiguration`:
```Swift
struct Model: TextInputConfigurableModel {
    let textInputConfiguration: TextFieldConfiguration
}
```

#### Text Input Configuration
Abstract protocol needed for implement `TextInputConfigurableView` that defines one method `configure(textInputView:)` and associated `TextInputView` type. You shouldn't use this protocol for your views (include cells) implementation, but you able to create additional protocol that implement default implementation. Read topics below for aditional information.
```swift
public protocol TextInputConfiguration {
    associatedtype TextInputView: UIView
    func configure(textInputView: TextInputView)
}
```

You are able to use already created implementation. But if you won't find anything suitable could create it or write to author.

#### Text Field Configuration
Configuration for `UITextField` with keyboard and some basic configurations. Use it both with `TextFieldDelegate`
```swift
public protocol TextFieldDelegate: UITextFieldDelegate {
    func textFieldDidEditingChanged(_ textField: UITextField)
}
open class TextFieldConfiguration: TextInputConfiguration {
    /// The auto-capitalization style for the text object. Default is `UITextAutocapitalizationType.sentences`
    public var autocapitalizationType: UITextAutocapitalizationType = .sentences
    /// The autocorrection style for the text object. Default is `UITextAutocorrectionType.default`
    public var autocorrectionType: UITextAutocorrectionType = .default
    /// Controls when the standard clear button appears in the text field. Default is `UITextField.ViewMode.never`
    public var clearButtonMode: UITextField.ViewMode = .never
    /// The custom input view to display when the text field becomes the first responder. Default is nil
    public var inputView: UIView? = nil
    /// Identifies whether the text object should disable text copying and in some cases hide the text being entered. Default is `false`
    public var isSecureTextEntry: Bool = false
    /// The appearance style of the keyboard that is associated with the text object. Default is `UIKeyboardAppearance.default`
    public var keyboardAppearance: UIKeyboardAppearance = .default
    /// The keyboard style associated with the text object. Default is `UIKeyboardType.default`
    public var keyboardType: UIKeyboardType = .default
    /// The visible title of the Return key. Default is `UIReturnKeyType.default`
    public var returnKeyType: UIReturnKeyType = .default
    /// The configuration state for smart dashes. Default is `UITextSmartDashesType.default`
    public var smartDashesType: UITextSmartDashesType = .default
    /// The configuration state for smart quotes. Default is `UITextSmartQuotesType.default`
    public var smartQuotesType: UITextSmartQuotesType = .default
    /// The configuration state for the smart insertion and deletion of space characters. Default is `UITextSmartInsertDeleteType.default`
    public var smartInsertDeleteType: UITextSmartInsertDeleteType = .default
    /// The spell-checking style for the text object. Default is `UITextSpellCheckingType.default`
    public var spellCheckingType: UITextSpellCheckingType = .default
    /// The semantic meaning expected by a text input area. Default is nil
    public var textContentType: UITextContentType? = nil
}
```

#### Text Field Picker View Configuration
Configuration for `UITextField` too. But there is `UIPickerView` instead keyboard and some basic configurations. Use it both with `TextFieldPickerViewDelegate` and `TextFieldPickerViewDataSource`
```swift
public protocol TextFieldPickerViewDataSource: class {
    func textField(_ textField: UITextField, numberOfComponentsInPickerView pickerView: UIPickerView) -> Int
    func textField(_ textField: UITextField, pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    func textField(_ textField: UITextField, pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> PickerViewTitle?
}

public protocol TextFieldPickerViewDelegate: TextFieldDelegate {
    func textField(_ textField: UITextField, pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    func textField(_ textField: UITextField, pickerView: UIPickerView, shouldUpdateTextFromRow row: Int, inComponent component: Int) -> Bool
    func textField(_ textField: UITextField, pickerView: UIPickerView, selectedRowInComponent component: Int) -> Int
}

public class TextFieldPickerViewConfiguration: TextFieldConfiguration {
    /// Picker view which will use as text field `inputView`
    public let pickerView: UIPickerView
    /// Methods will call by picker view for needed actions
    public unowned let pickerViewDataSource: TextFieldPickerViewDataSource
    /// Methods will call by picker view for notify about actions actions
    public unowned let pickerViewDelegate: TextFieldPickerViewDelegate
    
    public init(pickerView: UIPickerView = UIPickerView(), dataSource: TextFieldPickerViewDataSource, delegate: TextFieldPickerViewDelegate)
    
    public convenience init(pickerView: UIPickerView = UIPickerView(), controller: TextFieldPickerViewControllerProtocol)
    
}
```

#### Text Field Date Picker Configuration
Configuration for `UITextField` too. But there is `UIDatePicker` instead keyboard and some basic configurations. Use it both with `TextFieldDatePickerDelegate`
```swift
public protocol TextFieldDatePickerDelegate: TextFieldDelegate {
    func textField(_ textField: UITextField, datePicker: UIDatePicker, didSelectDate date: Date)
    func textField(_ textField: UITextField, datePicker: UIDatePicker, shouldUpdateTextFromDate date: Date) -> String?
}

public class TextFieldDatePickerConfiguration: TextFieldConfiguration {
    public let datePicker: UIDatePicker
    public unowned let datePickerDelegate: TextFieldDatePickerDelegate

    public init(datePicker: UIDatePicker, delegate: TextFieldDatePickerDelegate)
    
    public convenience init(mode: UIDatePicker.Mode, date: Date = Date(), minimumDate: Date? = nil, maximumDate: Date? = nil, delegate: TextFieldDatePickerDelegate)
```

- `TextViewConfiguration` for `UITextView` with keyboard and some basic configurations



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

### Implement `TextInputConfigurableView`
Implementation is similar to previous steps but you have to implement `TextInputConfigurableView` instead `ModelConfigurableView` protocol (e.g we create table view cell with text field)
```swift
class TextInputTableViewCell: UITableViewCell, IdentificableView, NibLoadableView, TextInputConfigurableView {
    @IBOutlet private weak var textField: UITextField!
}
```

Next add `textInputView` property implementation and return reference to your text input view (e.g. `textField`)
```swift
var textInputView: UITextField {
    return self.textField
}
```

Finally modify your model implementation and add `textInputConfiguration`. It have to one of implementations of `TextInputConfiguration` protocol (e.g. `TextFieldConfiguration` or `TextViewConfiguration`)
```swift
struct Model: TextInputConfigurableModel {
    ...
    let textInputConfiguration: TextFieldConfiguration
}
```


## Collection view cell
Collection view cell implementation is exactly the same as table view cell. Just use `UICollectionViewCell` instead `UITableViewCell`
