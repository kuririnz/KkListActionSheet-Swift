# KkListActionSheet
The library is like an extension of the tableview to ActionSheet.


## Demo
![KkListActionSheet-Swift Demo](KkListActionSheetExample/SampleMovie.gif)

## Requirement
* iOS 8.0+

## Install
There are two ways to use this in your project:

* Copy KkListActionSheet-Swift directory into your project

* Install with CocoaPods to write Podfile

```
pratform :ios
target 'yourtarget' do
 pod 'KkListActionSheetSwift'
end

target 'yourtargetTests' do
  pod 'KkListActionSheetSwift'
end
```

## Usage
### setDelegate
KkListActionSheet-Swift uses a simple methodology. import header file and It defines a delegate(contains datasource)
, its client implement. KkListActionSheetDelegate are like the combined UITableViewDelegate and UITableViewDatasource.

<kbd>yourViewController.swift</kbd>
```
class ViewController: UIViewController, KkListActionSheetDelegate {...}
```

#### Show Position
```
public class func createInit(parent: UIViewController) -> KkListActionSheet
```
or
```
public class func createInit(parent: UIViewController, style styleIdx:HIGHSTYLE) -> KkListActionSheet
```

**style Pattern in portrait**
* DEFAULT : about 60 percent in screen height
* MIDDLE  : screen height half
* LOW     : about 30 percent in screen height

**style Pattern in Landscape**
* DEFAULT : about 60 percent in screen height
* MIDDLE & LOW : screen height half

#### show KkListActionSheet
```
kkListActionSheet.showHide()
```

#### hide ListTitle
```
public func setHiddenTitle ()
```

#### set ListTitle
```
kkListActionSheet.setTitle("titleString")
```
or
```
var attrTitle = NSMutableAttributedString("titleString")
…
kkListActionSheet.setAttrTitle(attrTitle)
```

### example
* import kkListActionSheetSwift
* implement KkListActionSheetDelegate and Method
```
import kkListActionSheetSwift

class yourViewController: UIViewController, kkListActionSheetDelegate {
  var kkListActionSheet: kkListActionSheet?

  override func viewDidLoad {
    super.viewDidLoad()
    kkListActionSheet = KkListActionSheet.createInit(self)
    kkListActionSheet!.delegate = self
  }

  @IBAction func buttonPushed (button: UIButton) {
    kkListActionSheet.showHide()
  }
}
```

## Licence
[MIT](https://github.com/kuririnz/KkListActionSheet-SWIFT/blob/develop/LICENSE)

## Author
[kuririnz](https://github.com/kuririnz)
