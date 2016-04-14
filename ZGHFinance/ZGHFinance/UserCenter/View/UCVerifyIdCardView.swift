//
//  UCVerifyIdCardView.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/14.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCVerifyIdCardView: UIView {

    var name                : String? {
        didSet {
            nameLabel.text  = name
        }
    }
    
    var id                  : String? {
        didSet{
            idCard.text     = id
        }
    }
    private var nameLabel   : UILabel!
    private var idCard      : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor    = UIColor.whiteColor()
        self.layer.cornerRadius = 5
        self.layer.borderColor  = UtilTool.colorWithHexString("#53a0e3").CGColor
        self.layer.borderWidth  = 1
        
        let avatar              = UIImageView(image: UIImage(named: "uc_login_icon.jpg"))
        self.addSubview(avatar)
        
        avatar.mas_makeConstraints { (maker) in
            maker.centerY.equalTo()(self)
            maker.left.equalTo()(24)
            maker.width.equalTo()(50)
            maker.height.equalTo()(50)
        }
        
        nameLabel               = UILabel()
        nameLabel.font          = UIFont.systemFontOfSize(14)
        nameLabel.textColor     = UtilTool.colorWithHexString("#666")
        self.addSubview(nameLabel)
        nameLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(avatar.mas_right).offset()(30)
            maker.top.equalTo()(avatar)
            maker.height.equalTo()(14)
        }
        
        idCard                  = UILabel()
        idCard.font             = UIFont.systemFontOfSize(12)
        idCard.textColor        = UtilTool.colorWithHexString("#a8a8a9")
        self.addSubview(idCard)
        idCard.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.nameLabel)
            maker.bottom.equalTo()(avatar)
            maker.height.equalTo()(12)
        }
        
        let statusImg           = UIImageView(image: UIImage(named: "uc_icon_verified"))
        self.addSubview(statusImg)
        statusImg.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.nameLabel.mas_right).offset()(10)
            maker.centerY.equalTo()(self.nameLabel)
        }
        
        let statusLabel         = UILabel()
        statusLabel.font        = UIFont.systemFontOfSize(12)
        statusLabel.textColor   = UIColor.greenColor()
        statusLabel.text        = "已认证"
        self.addSubview(statusLabel)
        statusLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(statusImg.mas_right).offset()(4)
            maker.centerY.equalTo()(statusImg)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
