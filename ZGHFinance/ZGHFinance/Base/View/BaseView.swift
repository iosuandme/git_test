//
//  BaseView.swift
//  GaodiLicai
//
//  Created by zhangyr on 15/12/1.
//  Copyright © 2015年 cjxnfs. All rights reserved.
//

import UIKit

class BaseView: UIView
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.initUI()
    }
    
    func initUI()
    {
        self.backgroundColor    = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
