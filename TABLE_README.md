# AirCollection.TableView

- [Configure module](#configure-module) 
    - [Configure table view cell](#configure-table-view-cell)
    - [Configure view controller](#configure-view-controller)
    - [Configure presenter](#configure-presenter)
- [Usage](#usage)
    - [Reload table view](#reload-table-view)
    - [Action with rows and sections](#reload-table-view-actions)
- [Observe table view delegate](#observe-table-view-delegate)

## Configure module
For using this framework I recommend you use VIPER (View-Interactor-Presenter-Entity-Router) or MVP (Model-View-Presenter) architecture pattern.

### Configure table view cell
First you need implement `NibLoadableView` (if you use *.nib* for layout) and `ModelConfigurableView` (if your cell will be configuring) protocols to your table view cell. After than implement required `ModelConfigurableView` method `func configure(model: Model)` and `associatedtype Model` (I recommend create stucture)
```swift
import UIKit
import AirCollection

class TableViewCell: UITableViewCell, NibLoadableView, ModelConfigurableView {

    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(model: Model) {
        self.titleLabel.text = model.title
    }
    
    struct Model {
        let title: String
    }
    
}
```

### Configure view controller
You just need implement `TableViewControllerProtocol` and required get properties (`var tableViewSource: UITableView` and `var tableViewPresenter: TableViewPresenterProtocol`) to your view controller. After that you need to call `self.configureTableView(configurator:)` inside your `viewDidLoad` method. 
```swift
import AirCollection

class ViewController: UIViewController, TableViewControllerProtocol {

    var presenter: Presenter!

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView {
            $0.register(TableViewCell.self)
            $0.tableFooterView = UIView()
        }
    }
    
    // MARK: TableViewControllerProtocol
    var tableViewSource: UITableView {
        return self.tableView
    }
    
    var tableViewPresenter: TableViewPresenterProtocol {
        return self.presenter
    }
    
}
```

### Configure presenter
Presenter contains main logic to display table view. `TableViewPresenterProtocol` use similar methods to `UITableViewDataSource` and `UITableViewDelegate`. The code below reflects the required protocol methods but you can read more about `TableViewPresenterProtocol`.
```swift
import AirCollection

class Presenter: NSObject, TableViewPresenterProtocol {

    unowned let view: View
   
    // MARK: TableViewPresenterProtocol
    
    var tableSections: Int {
        // Number of sections in the table view
        return 1
    }
    
    func tableRows(for section: Int) -> Int {
        // Number of rows in a given section of a table view
        return 10
    }
    
    func tableRowIdentifier(for indexPath: IndexPath) -> String {
        // Cell identifier to insert in a particular location of the table view for index path
        return "TableViewCell" // You can use String
        return TableViewCell.viewIdentifier // But I recommend use `IdentificableView` protocol and `viewIdentifier` property
    }
    
    func tableRowHeight(for indexPath: IndexPath) -> UITableView.RowHeight {
        // Height to use for a row in a specified location of the table view for index path
        return .flexible // Dynamic table view row height. Not stable for version 1.0-alpha
        retunr .fixed(44) // Fixed table view row height
    }
    
    func tableRowModel(for indexPath: IndexPath) -> Any? {
        // Model to use for a row in a specified location of the table view for index path
        return TableViewCell.Model(title: "Title")
    }

}
```
## Usage
Few advice about advanced use `TableViewControllerProtocol`.

### Reload table view
You can clear all cache and reload table view using `reloadTableView()` method

### Action with rows and sections
You can use all actions with your table view, such as reload, delete, insert, move and select. Before calling these methods do not forget to use `updateTableView(updates:completion:)` method and make all actions inside `updates` block
```swift
    /// Reloads the specified rows using a given animation effect.
    public func reloadTableViewRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)

    /// Deletes the rows specified by an array of index paths, with an option to animate the deletion
    public func deleteTableViewRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)

    /// Inserts rows in the table view at the locations identified by an array of index paths, with an option to animate the insertion
    public func insertTableViewRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)

    /// Moves the row at a specified location to a destination location
    public func moveTableViewRows(at indexPath: IndexPath, to newIndexPath: IndexPath)

    /// Selects a row in the table view identified by index path, optionally scrolling the row to a location in the table view
    public func selectTableViewRow(at indexPath: IndexPath, animated: Bool, scrollPosition: UITableView.ScrollPosition)

    /// Deselects a given row identified by index path, with an option to animate the deselection.
    public func deselectRow(at indexPath: IndexPath, animated: Bool)

    /// Reloads the specified sections using a given animation effect
    public func reloadTableViewSections(_ sections: [Int], with animation: UITableView.RowAnimation)

    /// Deletes one or more sections in the table view, with an option to animate the deletion
    public func deleteTableViewSections(_ sections: [Int], with animation: UITableView.RowAnimation)

    /// Inserts one or more sections in the table view, with an option to animate the insertion
    public func insertTableViewSections(_ sections: [Int], with animation: UITableView.RowAnimation)
```

## Observe table view delegate
For observe table view delegate you can implement `TableViewDelegate` and call `forwardTableViewDelegate()` method. After that all `UIScrollViewDelegate` and some delegate method with `UITableViewDelegate` will tells. Important it's not `UITableViewDelegate`!
```swift
import AirCollection

class ViewController: UIViewController, TableViewControllerProtocol, TableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ...
        self.forwardTableViewDelegate()
        ...
    }
    
}
```
