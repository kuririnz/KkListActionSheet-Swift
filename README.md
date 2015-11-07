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
 pod 'KkListActionSheet-Swift'
end

target 'yourtargetTests' do
  pod 'KkListActionSheet-Swift'
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

#### create instance
```
var kkListActionSheet : KkListActionSheet?

override func viewDidLoad () {
    kkListActionSheet = KkListActionSheet.createInit(self)
    kkListActionSheet!.delegate = self
}
```

#### show KkListActionSheet
```
kkListActionSheet.showHide()
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
in preparation

## Licence
[MIT](https://github.com/kuririnz/KkListActionSheet-SWIFT/blob/develop/LICENSE)

## Author
[kuririnz](https://github.com/kuririnz)
