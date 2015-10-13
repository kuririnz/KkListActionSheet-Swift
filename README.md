# KkListActionSheet
The library is like an extension of the tableview to ActionSheet.


## Demo
in preparation

## Requirement
* iOS 6.0+
* ARC

## Install
There are two ways to use this in your project:

* Copy KkListActionSheet directory into your project

* Install with CocoaPods to write Podfile

```
pratform :ios
pod 'KkListActionSheet-swift'
```

## Usage
### setDelegate
KkListActionSheet uses a simple methodology. import header file and It defines a delegate(contains datasource)
, its client implement. KkListActionSheetDelegate are like the combined UITableViewDelegate and UITableViewDatasource.

<kbd>yourViewController.h</kbd>
```
#import "KkListActionSheet"


@interfase yourViewController : supperViewController <KkListActionSheetDelegate>
```

#### create instance
```KkListActionSheet *varName = [KkListActionSheet createInit:uiViewController]```

#### show KkListActionSheet
```[kkListActionSheet showHide]```

#### set ListTitle
```[kkListActionSheet setTitle:@"title]```
or
```[kkListActionSheet setAttrTitle:@"attributeTitle"]```

### example
in preparation

## Licence
[MIT](https://github.com/kuririnz/KkListActionSheet/blob/develop/LICENSE)

## Author
[kuririnz](https://github.com/kuririnz)
