//
//  UserCenterViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/8.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UserCenterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title                  = "我的账户"
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UtilTool.addTabBarToController(self)
    }
    
    override func needSetBackIcon() -> Bool {
        return false
    }
    
}
