//
//  UCRegisterViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/17.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCRegisterViewController: BaseViewController , UCInputViewDelegate {

    private var scrollView  : UIScrollView!
    private var optionView  : UIView!
    private var phoneInput  : UCInputView!
    private var userName    : UCInputView!
    private var pwdInput    : UCInputView!
    private var repwdInput  : UCInputView!
    private var mbCodeInput : UCInputView!
    private var registerBtn : BaseButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title                              = "注册"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize          = CGSizeMake(SCREEN_WIDTH, registerBtn.frame.maxY + 60)
        phoneInput.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func initUI() {
        super.initUI()
        
        scrollView                              = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        scrollView.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.view)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(self.view)
            maker.bottom.equalTo()(self.view)
        }
        
        optionView                      = UIView()
        optionView.backgroundColor      = UIColor.whiteColor()
        optionView.layer.borderWidth    = 1
        optionView.layer.borderColor    = UtilTool.colorWithHexString("#ddd").CGColor
        
        phoneInput                      = UCInputView(type: .Normal, delegate: self, needLine: true)
        phoneInput.placeholder          = "请输入手机号"
        phoneInput.keyboardType         = .NumberPad
        phoneInput.iconImage            = UIImage(named: "uc_login_phone")
        
        userName                        = UCInputView(type: .Normal, delegate: self, needLine: true)
        userName.placeholder            = "请输入用户名"
        userName.iconImage              = UIImage(named: "uc_tab_icon")
        
        pwdInput                        = UCInputView(type: .Normal, delegate: self, needLine: true)
        pwdInput.placeholder            = "请输入密码"
        pwdInput.secureTextEntry        = true
        pwdInput.iconImage              = UIImage(named: "uc_login_lock")
        
        repwdInput                      = UCInputView(type: .Normal, delegate: self, needLine: true)
        repwdInput.placeholder          = "请再次输入密码"
        repwdInput.secureTextEntry      = true
        repwdInput.iconImage            = UIImage(named: "uc_login_lock")
        
        mbCodeInput                     = UCInputView(type: .WithButton, delegate: self, needLine: false)
        mbCodeInput.placeholder         = "请输入验证码"
        mbCodeInput.keyboardType        = .NumberPad
        mbCodeInput.btnTitle            = "获取验证码"
        mbCodeInput.iconImage           = UIImage(named: "uc_login_key")
        
        registerBtn                     = BaseButton()
        registerBtn.layer.cornerRadius  = 4
        registerBtn.backgroundColor     = UtilTool.colorWithHexString("#53a0e3")
        registerBtn.titleLabel?.font    = UIFont.systemFontOfSize(14)
        registerBtn.setTitle("注册", forState: UIControlState.Normal)
        registerBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        registerBtn.addTarget(self, action: "buttonTapAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        scrollView.addSubview(optionView)
        scrollView.addSubview(registerBtn)
        optionView.addSubview(phoneInput)
        optionView.addSubview(userName)
        optionView.addSubview(pwdInput)
        optionView.addSubview(repwdInput)
        optionView.addSubview(mbCodeInput)
        
        optionView.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.scrollView).offset()(16)
            maker.right.equalTo()(self.view).offset()(-16)
            maker.top.equalTo()(self.scrollView).offset()(30)
            maker.height.equalTo()(200)
        }
        
        registerBtn.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView)
            maker.right.equalTo()(self.optionView)
            maker.top.equalTo()(self.optionView.mas_bottom).offset()(35)
            maker.height.equalTo()(40)
        }
        
        phoneInput.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView)
            maker.right.equalTo()(self.optionView)
            maker.height.equalTo()(self.optionView).multipliedBy()(0.2)
            maker.top.equalTo()(self.optionView)
        }
        
        userName.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView)
            maker.right.equalTo()(self.optionView)
            maker.height.equalTo()(self.optionView).multipliedBy()(0.2)
            maker.top.equalTo()(self.phoneInput.mas_bottom)
        }
        
        pwdInput.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView)
            maker.right.equalTo()(self.optionView)
            maker.height.equalTo()(self.optionView).multipliedBy()(0.2)
            maker.top.equalTo()(self.userName.mas_bottom)
        }
        
        repwdInput.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView)
            maker.right.equalTo()(self.optionView)
            maker.height.equalTo()(self.optionView).multipliedBy()(0.2)
            maker.top.equalTo()(self.pwdInput.mas_bottom)
        }
        
        mbCodeInput.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView)
            maker.right.equalTo()(self.optionView)
            maker.height.equalTo()(self.optionView).multipliedBy()(0.2)
            maker.top.equalTo()(self.repwdInput.mas_bottom)
        }
    }
    
    @objc private func buttonTapAction(btn : UIButton) {
        print("注册")
        self.view.endEditing(true)
    }
    
    //MARK: Delegate
    
    func inputViewButtonTap(inputView: UCInputView, actionButton: UIButton) {
        print("获取验证码")
    }
    
    func inputViewDidChanged(inputView: UCInputView, withInputString string: String) {
        print(string)
    }

}
