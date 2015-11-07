//
//  ViewController.swift
//  KkListActionSheet-SwiftDemo
//
//  Created by keisuke kuribayashi on 2015/10/11.
//  Copyright © 2015年 keisuke kuribayashi. All rights reserved.
//

import UIKit
import KkListActionSheetSwift

class ViewController: UIViewController, KkListActionSheetDelegate {

    var kkListActionSheet: KkListActionSheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        kkListActionSheet = KkListActionSheet.createInit(self)
        kkListActionSheet!.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPushed (sender: UIButton) {
            kkListActionSheet!.showHide()
    }
    
    // MARK: KkListActionSheet Delegate Method
    func kkTableView(tableView: UITableView, rowsInSection section: NSInteger) -> NSInteger {
        return 20
    }
    
    func kkTableView(tableView: UITableView, currentIndx indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdenfier = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdenfier)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdenfier)
        }
        
        cell?.textLabel?.text = String(format: "%ld", indexPath.row)
        
        return cell!
    }
}

