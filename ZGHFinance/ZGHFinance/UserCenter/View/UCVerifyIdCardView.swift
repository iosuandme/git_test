//
//  UCVerifyIdCardView.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/14.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCVerifyIdCardView: UIView {

    private var avatar      : UIImageView!
    private var nameLabel   : UILabel!
    private var idCard      : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor    = UIColor.whiteColor()
        self.layer.cornerRadius = 5
        self.layer.borderColor  = UtilTool.colorWithHexString("#ddd").CGColor
        self.layer.borderWidth  = 1
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
