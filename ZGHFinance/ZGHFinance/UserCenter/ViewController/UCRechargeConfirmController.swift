//
//  UCRechargeConfirmController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/21.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

struct RechargeData {
    var bankInfo    : UCBankCardInfo!
    var amount      : String!
    var cellPhone   : String!
}

class UCRechargeConfirmController: BaseViewController {

    var rechargeInfo                    : RechargeData!
    private var scrollView              : UIScrollView!
    private var amountLabel             : UILabel!
    private var cardNameLabel           : UILabel!
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
        scrollView.contentSize                  = CGSizeMake(self.view.bounds.width, 350)
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
            maker.height.equalTo()(320)
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
        contentView.addSubview(hint1)
        
        hint1.mas_makeConstraints { (maker) in
            maker.left.equalTo()(warnningLabel)
            maker.top.equalTo()(warnningLabel.mas_bottom).offset()(30)
            maker.width.equalTo()(75)
            maker.height.equalTo()(14)
        }
        
        amountLabel                             = UILabel()
        amountLabel.font                        = UIFont.systemFontOfSize(14)
        amountLabel.textColor                   = UtilTool.colorWithHexString("#666")
        contentView.addSubview(amountLabel)
        
        amountLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(hint1.mas_right).offset()(50)
            maker.right.equalTo()(contentView).offset()(-16)
            maker.centerY.equalTo()(hint1)
            maker.height.equalTo()(14)
        }
        
        let hint2                               = UILabel()
        hint2.font                              = UIFont.systemFontOfSize(14)
        hint2.textColor                         = UtilTool.colorWithHexString("#666")
        hint2.text                              = "充值银行卡"
        contentView.addSubview(hint2)
        
        hint2.mas_makeConstraints { (maker) in
            maker.left.equalTo()(warnningLabel)
            maker.top.equalTo()(hint1.mas_bottom).offset()(20)
            maker.width.equalTo()(75)
            maker.height.equalTo()(14)
        }
        
        cardNameLabel                           = UILabel()
        cardNameLabel.font                      = UIFont.systemFontOfSize(14)
        cardNameLabel.textColor                 = UtilTool.colorWithHexString("#666")
        contentView.addSubview(cardNameLabel)
        
        cardNameLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.amountLabel)
            maker.right.equalTo()(self.amountLabel)
            maker.centerY.equalTo()(hint2)
            maker.height.equalTo()(14)
        }
        
        let hint3                               = UILabel()
        hint3.font                              = UIFont.systemFontOfSize(14)
        hint3.textColor                         = UtilTool.colorWithHexString("#666")
        hint3.text                              = "预留手机号"
        contentView.addSubview(hint3)
        
        hint3.mas_makeConstraints { (maker) in
            maker.left.equalTo()(warnningLabel)
            maker.top.equalTo()(hint2.mas_bottom).offset()(20)
            maker.width.equalTo()(75)
            maker.height.equalTo()(14)
        }
        
        phoneLabel                              = UILabel()
        phoneLabel.font                         = UIFont.systemFontOfSize(14)
        phoneLabel.textColor                    = UtilTool.colorWithHexString("#666")
        contentView.addSubview(phoneLabel)
        
        phoneLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.amountLabel)
            maker.right.equalTo()(self.amountLabel)
            maker.centerY.equalTo()(hint3)
            maker.height.equalTo()(14)
        }
        
        let hint4                               = UILabel()
        hint4.font                              = UIFont.systemFontOfSize(14)
        hint4.textColor                         = UtilTool.colorWithHexString("#666")
        hint4.text                              = "短信验证码"
        contentView.addSubview(hint4)
        
        hint4.mas_makeConstraints { (maker) in
            maker.left.equalTo()(warnningLabel)
            maker.top.equalTo()(hint3.mas_bottom).offset()(20)
            maker.width.equalTo()(75)
            maker.height.equalTo()(14)
        }
        
        
        codeInput                               = UITextField()
        codeInput.font                          = UIFont.systemFontOfSize(14)
        codeInput.textColor                     = UtilTool.colorWithHexString("#666")
        codeInput.placeholder                   = " 验证码"
        codeInput.keyboardType                  = .NumberPad
        codeInput.layer.cornerRadius            = 2
        codeInput.layer.masksToBounds           = true
        codeInput.layer.borderColor             = UtilTool.colorWithHexString("#a8a8a9").CGColor
        codeInput.layer.borderWidth             = 0.5
        contentView.addSubview(codeInput)
        
        codeInput.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.amountLabel)
            maker.right.equalTo()(self.amountLabel)
            maker.centerY.equalTo()(hint4)
            maker.height.equalTo()(25)
        }
        
        let hint5                               = UILabel()
        hint5.font                              = UIFont.systemFontOfSize(10)
        hint5.textColor                         = UtilTool.colorWithHexString("#a8a8a9")
        hint5.textAlignment                     = .Right
        hint5.text                              = "验证码已发送至预留手机号"
        contentView.addSubview(hint5)
        
        hint5.mas_makeConstraints { (maker) in
            maker.right.equalTo()(self.codeInput)
            maker.top.equalTo()(self.codeInput.mas_bottom).offset()(10)
            maker.height.equalTo()(10)
        }
        
        let okBtn                               = BaseButton()
        okBtn.titleLabel?.font                  = UIFont.systemFontOfSize(15)
        okBtn.backgroundColor                   = UtilTool.colorWithHexString("#ff6600")
        okBtn.layer.cornerRadius                = 4
        okBtn.layer.masksToBounds               = true
        okBtn.setTitle("确认支付", forState: UIControlState.Normal)
        okBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        okBtn.addTarget(self, action: #selector(UCRechargeConfirmController.commitAction), forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(okBtn)
        
        okBtn.mas_makeConstraints { (maker) in
            maker.left.equalTo()(warnningLabel)
            maker.right.equalTo()(warnningLabel)
            maker.top.equalTo()(hint5.mas_bottom).offset()(23)
            maker.height.equalTo()(40)
        }
        
        showInfo()
        
    }
    
    private func showInfo() {
        if rechargeInfo != nil {
            amountLabel.attributedText          = UtilTool.colorString(desString: rechargeInfo.amount, color: UtilTool.colorWithHexString("#ff6600"), util: "元")
            var cardNo                          = ""
            if rechargeInfo.bankInfo.cardNo.length() < 4 {
                cardNo                          = "(\(rechargeInfo.bankInfo.cardNo))"
            }else{
                let len                         = rechargeInfo.bankInfo.cardNo.length() - 4
                cardNo                          = "(尾号\((rechargeInfo.bankInfo.cardNo as NSString).substringFromIndex(len)))"
            }
            cardNameLabel.attributedText        = UtilTool.attributeString("", desString: rechargeInfo.bankInfo.cardName, afterString: cardNo, dic: ["desColor" : UtilTool.colorWithHexString("#666") , "desFont" : UIFont.systemFontOfSize(14) , "afterColor" : UtilTool.colorWithHexString("#a8a8a9") , "afterFont" : UIFont.systemFontOfSize(11)])
            phoneLabel.text                     = rechargeInfo.cellPhone
        }
    }
    
    @objc private func commitAction() {
        print("确认充值")
    }

}
