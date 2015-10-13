//
//  KkListCloseButton.swift
//  KkListActionSheet-SwiftDemo
//
//  Created by keisuke kuribayashi on 2015/10/11.
//  Copyright © 2015年 keisuke kuribayashi. All rights reserved.
//

import UIKit

class KkListCloseButton: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        // Instance BezierPath
        let bezierLine = UIBezierPath()
        
        // Instance BezierPoint
        let myFrame = self.frame
        let display = UIScreen.mainScreen().bounds.size
        var correctionY :CGFloat = 0.0
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            correctionY = display.width > display.height ? display.width * 0.04 : display.height * 0.06
        } else {
            correctionY = display.width > display.height ? display.width * 0.01 : display.height * 0.04
        }
        let leftPoint = CGPointMake(myFrame.size.width /  2 - 15, 15)
        let centerPoint = CGPointMake(myFrame.size.width / 2, myFrame.size.height - correctionY)
        let rightPoint = CGPointMake(myFrame.size.width / 2 + 15, 15)
        
        // write stroke
        UIColor.lightGrayColor().setStroke()
        
        bezierLine.lineWidth = 6.0
        bezierLine.lineCapStyle = CGLineCap.Round
        bezierLine.lineJoinStyle = CGLineJoin.Round
        bezierLine.moveToPoint(leftPoint)
        bezierLine.addLineToPoint(centerPoint)
        bezierLine.addLineToPoint(rightPoint)
        bezierLine.stroke()
    }
    
}
