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
    private var tInterval   : Int               = 60
    
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
        phoneInput.placeholder          = "输入手机号"
        phoneInput.keyboardType         = .NumberPad
        phoneInput.iconImage            = UIImage(named: "uc_login_phone")
        
        userName                        = UCInputView(type: .Normal, delegate: self, needLine: true)
        userName.placeholder            = "输入用户名（仅数字、字母、中文）"
        userName.iconImage              = UIImage(named: "uc_tab_icon")
        
        pwdInput                        = UCInputView(type: .Normal, delegate: self, needLine: true)
        pwdInput.placeholder            = "输入密码"
        pwdInput.secureTextEntry        = true
        pwdInput.iconImage              = UIImage(named: "uc_login_lock")
        
        repwdInput                      = UCInputView(type: .Normal, delegate: self, needLine: true)
        repwdInput.placeholder          = "再次输入密码"
        repwdInput.secureTextEntry      = true
        repwdInput.iconImage            = UIImage(named: "uc_login_lock")
        
        mbCodeInput                     = UCInputView(type: .WithButton, delegate: self, needLine: false)
        mbCodeInput.placeholder         = "输入验证码"
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
        self.view.endEditing(true)
        var error           = ""
        if phoneInput.text!.isEmpty {
            error           = "请输入手机号码"
            phoneInput.becomeFirstResponder()
        }else if userName.text!.isEmpty {
            error           = "请输入用户名"
            userName.becomeFirstResponder()
        }else if pwdInput.text!.isEmpty {
            error           = "请输入密码"
            pwdInput.becomeFirstResponder()
        }else if repwdInput.text!.isEmpty {
            error           = "请确认密码"
            repwdInput.becomeFirstResponder()
        }else if mbCodeInput.text!.isEmpty {
            error           = "请输入手机验证码"
            mbCodeInput.becomeFirstResponder()
        }else if !UtilCheck.checkMobile(phoneInput.text!) {
            error           = "手机号码输入有误"
            phoneInput.becomeFirstResponder()
        }else if !checkUsernameValid(userName.text!) {
            error           = "用户名不合规范（仅数字、字母、中文）"
            userName.becomeFirstResponder()
        }else if pwdInput.text! != repwdInput.text! {
            error           = "两次的密码不同"
            pwdInput.becomeFirstResponder()
        }
        if !error.isEmpty {
            UtilTool.noticError(view: self.view, msg: error)
        }else{
            UtilTool.noticError(view: self.view, msg: "合法注册")
        }
    }
    
    @objc private func timeCount(timer : NSTimer) {
        tInterval--
        let button          = timer.userInfo as! UIButton
        if tInterval == 0 {
            button.setTitle("重发验证码", forState: UIControlState.Normal)
            button.enabled  = true
            tInterval       = 60
            timer.invalidate()
        }else{
            button.setTitle("\(tInterval)秒后重发", forState: UIControlState.Normal)
        }
        
    }
    
    private func checkUsernameValid(username : String) -> Bool {
        
        for s in username.characters {
            let str         = String(s)
            var isChinese   = false
            var isNotOther  = false
            let ch          = (str as NSString).characterAtIndex(0)
            if (ch > 0x4e00 && ch < 0x9fff) {
                isChinese   = true
            }else{
                if let asc     = getASCIIForChar(str) {
                    switch asc {
                    case 65...90 :
                        fallthrough
                    case 97...122 :
                        fallthrough
                    case 48...57 :
                        isNotOther  = true
                    default :
                        isNotOther  = false
                    }
                }else{
                    isNotOther      = false
                }
            }
            
            if !isChinese && !isNotOther {
                return false
            }
            
        }
        return true
    }
    
    //MARK: Delegate
    
    func inputViewButtonTap(inputView: UCInputView, actionButton: UIButton) {
        let phone = phoneInput.text!
        if phone.isEmpty {
            UtilTool.noticError(view: self.view, msg: "请输入手机号")
        }else if !UtilCheck.checkMobile(phone){
            UtilTool.noticError(view: self.view, msg: "请输入正确手机号")
        }else{
            UCService.sendMbCodeWithPhone(phone, completion: { (data) -> Void in
                }, failure: { (error) -> Void in
            })
            actionButton.setTitle("\(tInterval)秒后重发", forState: UIControlState.Normal)
            actionButton.enabled    = false
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timeCount:", userInfo: actionButton, repeats: true)
        }
    }
    
    func inputViewDidChanged(inputView: UCInputView, withInputString string: String) {
        print(string)
    }

}
