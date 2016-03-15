//
//  YRPageRectItem.swift
//  QminiFund
//
//  Created by zhangyr on 15/10/20.
//  Copyright © 2015年 quchaogu. All rights reserved.
//

import UIKit

class YRPageRectItem: YRPageItem {

    override func didSelected() {
        
        UIView.animateWithDuration(duration) { () -> Void in
            self.backgroundColor = self.didselectedColor
            self.transform       = CGAffineTransformMakeScale(1, 1.05)
        }
        
    }
    
    override func didNotSelected() {
        self.backgroundColor = didNotSelectedColor
        self.transform       = CGAffineTransformIdentity
    }

}
