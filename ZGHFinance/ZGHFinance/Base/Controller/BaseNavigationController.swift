//
//  BaseNavigationController.swift
//  GaodiLicai
//
//  Created by zhangyr on 15/12/1.
//  Copyright © 2015年 cjxnfs. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate                                       = self
        self.navigationItem.backBarButtonItem?.tintColor    = UIColor.clearColor()
        self.navigationBar.barTintColor                     = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes              = [NSFontAttributeName : UIFont(name: "Avenir", size: NAVI_FONT_SIZE)!,NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationBar.tintColor                        = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle    = UIStatusBarStyle.Default
        self.navigationBar.translucent                      = false
        
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        let back = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = back
        navigationBar.barTintColor = UtilTool.colorWithHexString("#53a0e3")
        navigationBar.tintColor    = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(NAVI_FONT_SIZE),NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationBar.translucent = false
        if navigationController.respondsToSelector(Selector("interactivePopGestureRecognizer"))
        {
            navigationController.interactivePopGestureRecognizer?.enabled   = true
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

