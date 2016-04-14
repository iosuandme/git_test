//
//  UCVerifyViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/12.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCVerifyViewController: BaseViewController , UCInputViewDelegate {
    
    private var scrollView      : UIScrollView!
    private var optionView      : UIView!
    private var realName        : UCInputView!
    private var idCard          : UCInputView!
    private var dealPassword    : UCInputView!
    private var reDealPassword  : UCInputView!
    private var phoneLabel      : UCInputView!
    private var bankName        : UCInputView!
    private var bankCard        : UCInputView!
    private var localAddr       : UCInputView!
    private var mbCode          : UCInputView!
    private var submitBtn       : BaseButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title                              = "实名认证"
    }
    
    override func initUI() {
        super.initUI()
        
        scrollView                              = UIScrollView()
        scrollView.contentSize                  = CGSizeMake(self.view.bounds.width, 500)
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        scrollView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.view)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(self.view)
            maker.bottom.equalTo()(self.view)
        }
        
        optionView                              = UIView()
        optionView.backgroundColor              = UIColor.whiteColor()
        optionView.layer.borderColor            = UtilTool.colorWithHexString("#ddd").CGColor
        optionView.layer.borderWidth            = 1
        scrollView.addSubview(optionView)
        
        optionView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.scrollView).offset()(16)
            maker.top.equalTo()(self.scrollView).offset()(30)
            maker.right.equalTo()(self.view).offset()(-16)
            maker.height.equalTo()(40 * 9)
        }
        
        submitBtn                               = BaseButton()
        submitBtn.layer.cornerRadius            = 4
        submitBtn.backgroundColor               = UtilTool.colorWithHexString("#53a0e3")
        submitBtn.titleLabel?.font              = UIFont.systemFontOfSize(14)
        submitBtn.setTitle("提交认证", forState: UIControlState.Normal)
        submitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submitBtn.addTarget(self, action: #selector(UCVerifyViewController.buttonTapAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        scrollView.addSubview(submitBtn)
        
        submitBtn.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView)
            maker.right.equalTo()(self.optionView)
            maker.top.equalTo()(self.optionView.mas_bottom).offset()(30)
            maker.height.equalTo()(40)
        }
        
        realName                                = UCInputView(type: .Normal, delegate: self, needLine: true)
        realName.iconImage                      = UIImage(named: "uc_icon_idcard")
        realName.placeholder                    = "真实姓名"
        realName.tag                            = 100
        
        idCard                                  = UCInputView(type: .Normal, delegate: self, needLine: true)
        idCard.iconImage                        = UIImage(named: "uc_icon_idcard")
        idCard.placeholder                      = "身份证号码"
        idCard.tag                              = 101
        
        dealPassword                            = UCInputView(type: .Normal, delegate: self, needLine: true)
        dealPassword.iconImage                  = UIImage(named: "uc_login_lock")
        dealPassword.secureTextEntry            = true
        dealPassword.placeholder                = "交易密码"
        dealPassword.tag                        = 102
        
        reDealPassword                          = UCInputView(type: .Normal, delegate: self, needLine: true)
        reDealPassword.iconImage                = UIImage(named: "uc_login_lock")
        reDealPassword.secureTextEntry          = true
        reDealPassword.placeholder              = "重复交易密码"
        reDealPassword.tag                      = 103
        
        phoneLabel                              = UCInputView(type: .Normal, delegate: self, needLine: true)
        phoneLabel.iconImage                    = UIImage(named: "uc_login_phone")
        phoneLabel.userInteractionEnabled       = false
        phoneLabel.tag                          = 104
        
        bankName                                = UCInputView(type: .Select, delegate: self, needLine: true)
        bankName.iconImage                      = UIImage(named: "uc_bankcard")
        bankName.text                           = "请选择银行"
        bankName.tag                            = 105
        
        bankCard                                = UCInputView(type: .Normal, delegate: self, needLine: true)
        bankCard.iconImage                      = UIImage(named: "uc_bankcard")
        bankCard.keyboardType                   = .NumberPad
        bankCard.placeholder                    = "银行卡号"
        bankCard.tag                            = 106
        
        localAddr                               = UCInputView(type: .Normal, delegate: self, needLine: true)
        localAddr.iconImage                     = UIImage(named: "uc_icon_local")
        localAddr.placeholder                   = "银行所在地及支行"
        localAddr.tag                           = 107
        
        mbCode                                  = UCInputView(type: .WithButton, delegate: self, needLine: false)
        mbCode.iconImage                        = UIImage(named: "uc_login_key")
        mbCode.placeholder                      = "手机验证码"
        mbCode.keyboardType                     = .NumberPad
        mbCode.btnTitle                         = "获取验证码"
        mbCode.tag                              = 108
        
        optionView.addSubview(realName)
        optionView.addSubview(idCard)
        optionView.addSubview(dealPassword)
        optionView.addSubview(reDealPassword)
        optionView.addSubview(phoneLabel)
        optionView.addSubview(bankName)
        optionView.addSubview(bankCard)
        optionView.addSubview(localAddr)
        optionView.addSubview(mbCode)
        
        var lastView : UCInputView?
        for i in 100 ... 108 {
            if let tmpView = optionView.viewWithTag(i) as? UCInputView {
                tmpView.mas_makeConstraints({ (maker) in
                    maker.left.equalTo()(self.optionView)
                    maker.right.equalTo()(self.optionView)
                    if lastView == nil {
                        maker.top.equalTo()(self.optionView)
                    }else{
                        maker.top.equalTo()(lastView?.mas_bottom)
                    }
                    maker.height.equalTo()(40)
                })
                lastView    = tmpView
            }
        }
    }
    
    @objc private func buttonTapAction(btn : UIButton) {
        
    }

}
