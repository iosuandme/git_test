//
//  MultiTouchEnableButton.swift
//  GaodiLicai
//
//  Created by zhangyr on 16/1/6.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class BaseButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.exclusiveTouch         = enableMultiTouch
    }
    
    var enableMultiTouch = true {
        didSet {
            self.exclusiveTouch     = enableMultiTouch
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
