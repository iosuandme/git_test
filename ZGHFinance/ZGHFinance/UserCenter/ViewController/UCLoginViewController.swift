//
//  UCLoginViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/16.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCLoginViewController: BaseViewController {

    var callBack            : (() -> Void)?
    private var optionView  : UIView!
    private var phoneIcon   : UIImageView!
    private var phoneText   : UITextField!
    private var pwdIcon     : UIImageView!
    private var pwdText     : UITextField!
    private var loginButton : BaseButton!
    private var registerBtn : BaseButton!
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        let app  = UIApplication.sharedApplication().delegate as! AppDelegate
        app.navi = BaseNavigationController(rootViewController: self)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title                  = "登录"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        phoneText.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func initUI() {
        super.initUI()
        optionView                      = UIView()
        optionView.backgroundColor      = UIColor.whiteColor()
        optionView.layer.borderWidth    = 1
        optionView.layer.borderColor    = UtilTool.colorWithHexString("#ddd").CGColor
        
        phoneIcon                       = UIImageView(image: UIImage(named: "uc_login_phone"))
        
        phoneText                       = UITextField()
        phoneText.font                  = UIFont.systemFontOfSize(12)
        phoneText.textColor             = UtilTool.colorWithHexString("#666")
        phoneText.placeholder           = "请输入用户名/手机号"
        phoneText.tag                   = 666
        phoneText.addTarget(self, action: "textFieldDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        
        pwdIcon                         = UIImageView(image: UIImage(named: "uc_login_lock"))
        
        pwdText                         = UITextField()
        pwdText.secureTextEntry         = true
        pwdText.font                    = UIFont.systemFontOfSize(12)
        pwdText.textColor               = UtilTool.colorWithHexString("#666")
        pwdText.placeholder             = "请输入密码"
        pwdText.tag                     = 777
        pwdText.addTarget(self, action: "textFieldDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        
        loginButton                     = BaseButton()
        loginButton.layer.cornerRadius  = 4
        loginButton.backgroundColor     = UtilTool.colorWithHexString("#53a0e3")
        loginButton.titleLabel?.font    = UIFont.systemFontOfSize(14)
        loginButton.tag                 = 888
        loginButton.setTitle("登录", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: "buttonTaoAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        registerBtn                     = BaseButton()
        registerBtn.titleLabel?.font    = UIFont.systemFontOfSize(12)
        registerBtn.tag                 = 999
        registerBtn.setTitle("没有账户？立即注册", forState: UIControlState.Normal)
        registerBtn.setTitleColor(UtilTool.colorWithHexString("#666"), forState: UIControlState.Normal)
        registerBtn.addTarget(self, action: "buttonTaoAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let sepLine                     = UIView()
        sepLine.backgroundColor         = UtilTool.colorWithHexString("#ddd")
        
        self.view.addSubview(optionView)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerBtn)
        optionView.addSubview(phoneIcon)
        optionView.addSubview(phoneText)
        optionView.addSubview(sepLine)
        optionView.addSubview(pwdIcon)
        optionView.addSubview(pwdText)
        
        optionView.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.view).offset()(16)
            maker.right.equalTo()(self.view).offset()(-16)
            maker.top.equalTo()(self.view).offset()(30)
            maker.height.equalTo()(81)
        }
        
        phoneIcon.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView).offset()(16)
            maker.top.equalTo()(self.optionView).offset()(10.5)
            maker.width.equalTo()(15)
            maker.height.equalTo()(19)
        }
        
        phoneText.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.phoneIcon.mas_right).offset()(24)
            maker.right.equalTo()(self.optionView).offset()(-16)
            maker.top.equalTo()(self.optionView)
            maker.height.equalTo()(40)
        }
        
        sepLine.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView)
            maker.right.equalTo()(self.optionView)
            maker.top.equalTo()(self.phoneText.mas_bottom)
            maker.height.equalTo()(1)
        }
        
        pwdText.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.phoneText)
            maker.right.equalTo()(self.phoneText)
            maker.bottom.equalTo()(self.optionView)
            maker.height.equalTo()(40)
        }
        
        pwdIcon.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.phoneIcon)
            maker.centerY.equalTo()(self.pwdText)
        }
        
        loginButton.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView)
            maker.right.equalTo()(self.optionView)
            maker.top.equalTo()(self.optionView.mas_bottom).offset()(30)
            maker.height.equalTo()(40)
        }
        
        registerBtn.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.loginButton)
            maker.right.equalTo()(self.loginButton)
            maker.top.equalTo()(self.loginButton.mas_bottom).offset()(35)
            maker.height.equalTo()(30)
        }
    }
    
    override func needSetBackIcon() -> Bool {
        return true
    }
    
    override func popAction() {
        self.view.endEditing(true)
        UtilTool.getAppDelegate().navi = nil
        self.dismissViewControllerAnimated(true) { () -> Void in
            //do something here
        }
    }
    
    @objc private func textFieldDidChanged(textField : UITextField) {
        //限制规则
    }
    
    @objc private func buttonTaoAction(button : UIButton) {
        self.view.endEditing(true)
        
        if button.tag == 888 {
            let username = phoneText.text!
            let password = pwdText.text!
            var error   = ""
            if username.isEmpty {
                error   = "请填写用户名"
                phoneText.becomeFirstResponder()
            }else if password.isEmpty {
                error   = "请输入密码"
                pwdText.becomeFirstResponder()
            }
            
            if error.isEmpty {
                button.enabled = false
                button.setTitle("登录中···", forState: UIControlState.Normal)
                UCService.loginActionWithUsername(username, loginPassword: password, completion: { (loginData) -> Void in
                    button.enabled  = true
                    button.setTitle("登录", forState: UIControlState.Normal)
                    if loginData?.cjxnfsCode == 10000 {
                        let userData        = loginData as! UCUserData
                        userData.loginName  = username
                        userData.password   = password
                        Commond.setUserDefaults(userData, key: "userData")
                        self.dismissViewControllerAnimated(true, completion: self.callBack)
                    }else{
                        UtilTool.noticError(view: self.view, msg: loginData!.responseMsg!)
                    }
                    
                    }, failure: { (error) -> Void in
                        button.enabled  = true
                        button.setTitle("登录", forState: UIControlState.Normal)
                        UtilTool.noticError(view: self.view, msg: error.msg!)
                })
            }else{
                UtilTool.noticError(view: self.view, msg: error)
            }
        }else{
            
        }
    }

}
