//
//  UCRechargeConfirmController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/21.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCRechargeConfirmController: BaseViewController {

    private var scrollView              : UIScrollView!
    private var amountLabel             : UILabel!
    private var cardNameLabel           : UILabel!
    private var cardNoLabel             : UILabel!
    private var phoneLabel              : UILabel!
    private var codeInput               : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title                  = "充值确认"
    }
    
    override func initUI() {
        super.initUI()
        scrollView                              = UIScrollView()
        scrollView.alwaysBounceVertical         = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize                  = CGSizeMake(self.view.bounds.width, 400)
        scrollView.keyboardDismissMode          = .OnDrag
        self.view.addSubview(scrollView)
        
        scrollView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.view)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(self.view)
            maker.bottom.equalTo()(self.view)
        }
        
        let contentView                         = UIView()
        contentView.backgroundColor             = UIColor.whiteColor()
        scrollView.addSubview(contentView)
        
        contentView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.scrollView)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(self.scrollView)
            maker.height.equalTo()(400)
        }
        
        let warnningLabel                       = UILabel()
        warnningLabel.backgroundColor           = UtilTool.colorWithHexString("#fcf7e3")
        warnningLabel.layer.borderColor         = UtilTool.colorWithHexString("#fbf0d5").CGColor
        warnningLabel.layer.borderWidth         = 1
        warnningLabel.layer.cornerRadius        = 3
        warnningLabel.layer.masksToBounds       = true
        warnningLabel.font                      = UIFont.systemFontOfSize(12)
        warnningLabel.textColor                 = UtilTool.colorWithHexString("#bca982")
        warnningLabel.textAlignment             = .Center
        warnningLabel.text                      = "您正在使用快捷支付为以下订单付款，确认支付？"
        contentView.addSubview(warnningLabel)
        
        warnningLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(contentView).offset()(16)
            maker.right.equalTo()(contentView).offset()(-16)
            maker.top.equalTo()(contentView).offset()(18)
            maker.height.equalTo()(40)
        }
        
        let hint1                               = UILabel()
        hint1.font                              = UIFont.systemFontOfSize(14)
        hint1.textColor                         = UtilTool.colorWithHexString("#666")
        hint1.text                              = "订单金额"
        
        
        
        
        
        
    }

}
