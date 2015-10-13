//
//  KkListActionSheet.swift
//  KkListActionSheet-SwiftDemo
//
//  Created by keisuke kuribayashi on 2015/10/11.
//  Copyright © 2015年 keisuke kuribayashi. All rights reserved.
//

import UIKit

let ANIM_ALPHA_KEY      = "animAlpha"
let ANIM_MOVE_KEY       = "animMove"
let ORIENT_VERTICAL     = "PORTRAIT"
let ORIENT_HORIZONTAL   = "LANDSCAPE"

@objc protocol KkListActionSheetDelegate: class {
    func kkTableView(tableView: UITableView, rowsInSection section: NSInteger) -> NSInteger
    func kkTableView(tableView: UITableView, currentIndx indexPath: NSIndexPath) -> UITableViewCell
    optional func kkTableView(tableView: UITableView, selectIndex indexPath: NSIndexPath)
}

class KkListActionSheet: UIView, UITableViewDelegate, UITableViewDataSource {
    // MARK: self delegate
    weak var delegate : KkListActionSheetDelegate! = nil

    // MARK: Member Variable
    @IBOutlet weak var kkTableView              : UITableView!
    @IBOutlet weak var kkActionSheetBackGround  : UIView!
    @IBOutlet weak var kkActionSheet            : UIView!
    @IBOutlet weak var titleLabel               : UILabel!
    @IBOutlet weak var kkCloseButton            : KkListCloseButton!
    
    var displaySize         : CGRect = CGRectMake(0, 0, 0, 0)
    var centerY             : CGFloat = 0.0
    var orientList          : NSArray = ["Portrait", "PortraitUpsideDown", "", ""]
    var supportOrientList   : NSArray = []
    var animatingFlg       : Bool = false
    
    // MARK: initialized
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // init process
        displaySize = UIScreen.mainScreen().bounds
        orientList = ["UIInterfaceOrientationPortrait",
            "UIInterfaceOrientationPortraitUpsideDown",
            "UIInterfaceOrientationLandscapeLeft",
            "UIInterfaceOrientationLandscapeRight"]
        if Float(UIDevice.currentDevice().systemVersion) > 8.0 {
            supportOrientList = NSBundle.mainBundle().objectForInfoDictionaryKey("UISupportedInterfaceOrientations") as! NSArray
        } else {
            let infoDictionary = NSBundle.mainBundle().infoDictionary! as Dictionary
            supportOrientList = infoDictionary["UISupportedInterfaceOrientations"]! as! NSArray
        }
        self.hidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialKkListActionSheet()
    }
    
    class func createInit(parent: UIViewController) -> KkListActionSheet {
        let className = NSStringFromClass(KkListActionSheet)
        let currentIdx = className.rangeOfString(".")
        let initClass = NSBundle.mainBundle().loadNibNamed(className.substringFromIndex(currentIdx!.endIndex), owner: nil, options: nil).first as! KkListActionSheet
        parent.view.addSubview(initClass)
        return initClass
    }
    
    // initial Method
    func initialKkListActionSheet() {
        animatingFlg = false
        
        // Set BackGround Alpha
        kkActionSheetBackGround.alpha = 0.0
        let largeOrientation = displaySize.size.width > displaySize.size.height ? displaySize.size.width:displaySize.size.height
        
        // Setting BackGround Layout
        kkActionSheetBackGround.translatesAutoresizingMaskIntoConstraints = true
        var kkActionSheetBgRect = kkActionSheetBackGround.frame as CGRect
        kkActionSheetBgRect.size.width = largeOrientation
        kkActionSheetBgRect.size.height = largeOrientation
        kkActionSheetBackGround.frame = kkActionSheetBgRect
        
        // Setting ListActionSheet Layout
        kkActionSheet.translatesAutoresizingMaskIntoConstraints = true
        var kkActionSheetRect = kkActionSheet.frame as CGRect
        kkActionSheetRect.origin = CGPointMake(0, displaySize.size.height / 3)
        kkActionSheetRect.size.width = displaySize.size.width
        kkActionSheetRect.size.height = (displaySize.size.height * 2) / 3
        kkActionSheet.frame = kkActionSheetRect
        
        // Setting CloseButton Layout
        kkCloseButton.translatesAutoresizingMaskIntoConstraints = true
        var closeBtnRect = kkCloseButton.frame
        closeBtnRect.size.width = largeOrientation
        closeBtnRect.size.height = displaySize.size.height * 0.085
        let tmpX = closeBtnRect.size.width - displaySize.size.width
        closeBtnRect.origin = CGPointMake(tmpX > 0 ? tmpX / 2 : 0, 0)
        kkCloseButton.frame = closeBtnRect
        
        centerY = kkActionSheet.center.y
        
        // BackGround TapGesuture Event
        let backGroundGesture = UITapGestureRecognizer(target: self, action: Selector("onTapGesture:"))
        kkActionSheetBackGround.addGestureRecognizer(backGroundGesture)
        
        // Close Button PanGesture Event
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("onPanGesture:"))
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("onTapGesture:"))

        kkCloseButton.addGestureRecognizer(panGesture)
        kkCloseButton.addGestureRecognizer(tapGesture)
        
        // set device change notification center
        if supportOrientList.count > 1 {
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: Selector("didRotation:"),
                name: "UIDeviceOrientationDidChangeNotification",
                object: nil)
        }
    }

    // MARK: Customize Method
    func setTitle (title: String) {
        self.titleLabel.text = title
    }
    
    func setAttrTitle (attrTitle: NSAttributedString) {
        self.titleLabel.attributedText = attrTitle
    }
    
    // MARK: Gesture Recognizer Action
    func onTapGesture(recognizer: UITapGestureRecognizer) {
        self.showHide()
    }
    
    func onPanGesture(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.translationInView(self)
        var moveRect = self.kkActionSheet.frame
        let afterPosition = moveRect.origin.y + location.y

        if recognizer.state == UIGestureRecognizerState.Ended {
            if centerY > afterPosition {
                self.kkListActionSheetReturenAnimation(afterPosition)
            } else {
                self.kkListActionSheetAnimation(afterPosition)
            }
        } else {
            if self.displaySize.size.height / 3 < afterPosition {
                moveRect.origin = CGPointMake(0, afterPosition)
                self.kkActionSheet.frame = moveRect
            }
        }
        recognizer.setTranslation(CGPointZero, inView: self)
    }
    
    // MARK: KkListAction Animation Method
    func showHide () {
        self.kkListActionSheetAnimation(self.kkActionSheet.frame.size.height)
    }
    
    func kkListActionSheetAnimation (param: CGFloat) {
        if animatingFlg { return }
        
        animatingFlg = true
        var fromPositionY   :CGFloat
        var toPositionY     :CGFloat
        var toAlpha         :CGFloat
        let currentAlpha = kkActionSheetBackGround.alpha
        
        if currentAlpha == 0.0 {
            fromPositionY = param
            toPositionY = 0
            toAlpha = 0.8
        } else {
            fromPositionY = 0.0
            toPositionY = param
            toAlpha = 0.0
        }
        
        let moveAnim = CABasicAnimation(keyPath: "transform.translation.y")
        moveAnim.duration = 0.5
        moveAnim.repeatCount = 1
        moveAnim.autoreverses = false
        moveAnim.removedOnCompletion = false
        moveAnim.fillMode = kCAFillModeForwards
        moveAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        moveAnim.fromValue = fromPositionY as NSNumber
        moveAnim.toValue = toPositionY as NSNumber
        
        let alphaAnim = CABasicAnimation(keyPath: "opacity")
        alphaAnim.delegate = self
        alphaAnim.duration = 0.4
        alphaAnim.repeatCount = 1
        alphaAnim.autoreverses = false
        alphaAnim.removedOnCompletion = false
        alphaAnim.fillMode = kCAFillModeForwards
        alphaAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        alphaAnim.fromValue = currentAlpha as NSNumber
        alphaAnim.toValue = toAlpha
        
        self.hidden = false
        kkActionSheet.layer.addAnimation(moveAnim, forKey: ANIM_MOVE_KEY)
        kkActionSheetBackGround.layer.addAnimation(alphaAnim, forKey: ANIM_ALPHA_KEY)
    }
    
    func kkListActionSheetReturenAnimation(param: CGFloat) {
        if animatingFlg { return }
        
        animatingFlg = true
        UIView.animateWithDuration(0.5,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                var tmp = self.kkActionSheet.frame as CGRect
                tmp.origin = CGPointMake(0, self.displaySize.height / 3)
                self.kkActionSheet.frame = tmp
            }, completion: {(finish: Bool) in
                self.animatingFlg = false
            }
        )
    }
    
    // MARK: CABasicAnimation Inheritance Method
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if anim == kkActionSheetBackGround.layer.animationForKey(ANIM_ALPHA_KEY) {
            let currentAnimation = anim as! CABasicAnimation
            kkActionSheetBackGround.alpha = currentAnimation.toValue as! CGFloat
            kkActionSheetBackGround.layer.removeAnimationForKey(ANIM_ALPHA_KEY)
            if kkActionSheetBackGround.alpha == 0.0 {
                self.hidden = true
                var tmpPosition = kkActionSheet.frame
                tmpPosition.origin = CGPointMake(0, displaySize.size.height / 3)
                kkActionSheet.frame = tmpPosition
            }
            animatingFlg = false
        }
    }
    
    // MARK: Change Device Rotate Method
    func didRotation(notification: NSNotification) {
        let orientation = UIDevice.currentDevice().orientation as UIDeviceOrientation
        if !orientation.isPortrait && !orientation.isLandscape { return }
        
        let nowRotate = orientList.objectAtIndex(orientation.rawValue - 1) as! String
        if orientation.isPortrait {
            if self.supportOrientList.indexOfObject(nowRotate) != NSNotFound { self.changeOrientationTransform(nowRotate) }
        } else if orientation.isLandscape {
            if self.supportOrientList.indexOfObject(nowRotate) != NSNotFound { self.changeOrientationTransform(nowRotate) }
        }
    }
 
    func changeOrientationTransform (orientState: String) {
        if !animatingFlg {
            UIView.animateWithDuration(0.5,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    var afterSheetRect = self.kkActionSheet.frame
                    var afterBtnRect = self.kkCloseButton.frame
                    
                    if Float(UIDevice.currentDevice().systemVersion) < 9.0 {
                        self.displaySize.size = UIScreen.mainScreen().bounds.size
                    } else {
                        let afterSize = UIScreen.mainScreen().bounds.size
                        let isLargeWidth = afterSize.width > afterSize.height
                        if orientState == ORIENT_VERTICAL {
                            self.displaySize.size.width = isLargeWidth ? afterSize.height : afterSize.width
                            self.displaySize.size.height = isLargeWidth ? afterSize.width : afterSize.height
                        } else if orientState == ORIENT_HORIZONTAL {
                            self.displaySize.size.width = isLargeWidth ? afterSize.width : afterSize.height
                            self.displaySize.size.height = isLargeWidth ? afterSize.height : afterSize.width
                        }
                    }
                    
                    afterSheetRect.origin = CGPointMake(0, self.displaySize.size.height / 3)
                    afterSheetRect.size.width = self.displaySize.size.width
                    afterSheetRect.size.height = (self.displaySize.size.height * 2) / 3
                    
                    let tmpX = afterBtnRect.size.width - self.displaySize.size.width;
                    afterBtnRect.origin = CGPointMake(tmpX > 0 ? -(tmpX / 2) : 0, 0);
                    
                    self.kkActionSheet.frame = afterSheetRect;
                    self.kkCloseButton.frame = afterBtnRect;
                    self.centerY = self.kkActionSheet.center.y;
                },
                completion: {(finish: Bool) in
                    self.animatingFlg = false
            })
        }
    }
    
    // MARK: UITableView Delegate / Datasource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.delegate.kkTableView(tableView, currentIndx: indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate.kkTableView(tableView, rowsInSection: section)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate.kkTableView!(tableView, selectIndex: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
