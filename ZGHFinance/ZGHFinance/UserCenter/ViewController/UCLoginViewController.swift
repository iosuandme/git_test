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
    private var phoneInput  : UCInputView!
    private var pwdInput    : UCInputView!
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
        phoneInput.becomeFirstResponder()
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
        
        phoneInput                      = UCInputView(type: .Normal, delegate: nil, needLine: true)
        phoneInput.placeholder          = "请输入用户名/手机号"
        phoneInput.iconImage            = UIImage(named: "uc_login_phone")
        
        pwdInput                        = UCInputView(type: .Normal, delegate: nil, needLine: false)
        pwdInput.placeholder            = "请输入密码"
        pwdInput.secureTextEntry        = true
        pwdInput.iconImage              = UIImage(named: "uc_login_lock")
        
        loginButton                     = BaseButton()
        loginButton.layer.cornerRadius  = 4
        loginButton.backgroundColor     = UtilTool.colorWithHexString("#53a0e3")
        loginButton.titleLabel?.font    = UIFont.systemFontOfSize(14)
        loginButton.tag                 = 888
        loginButton.setTitle("登录", forState: UIControlState.Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginButton.addTarget(self, action: #selector(UCLoginViewController.buttonTapAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        registerBtn                     = BaseButton()
        registerBtn.titleLabel?.font    = UIFont.systemFontOfSize(12)
        registerBtn.tag                 = 999
        registerBtn.setTitle("没有账户？立即注册", forState: UIControlState.Normal)
        registerBtn.setTitleColor(UtilTool.colorWithHexString("#666"), forState: UIControlState.Normal)
        registerBtn.addTarget(self, action: #selector(UCLoginViewController.buttonTapAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        let sepLine                     = UIView()
        sepLine.backgroundColor         = UtilTool.colorWithHexString("#ddd")
        
        self.view.addSubview(optionView)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerBtn)
        optionView.addSubview(phoneInput)
        optionView.addSubview(pwdInput)
        
        optionView.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.view).offset()(16)
            maker.right.equalTo()(self.view).offset()(-16)
            maker.top.equalTo()(self.view).offset()(30)
            maker.height.equalTo()(80)
        }
        
        phoneInput.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView)
            maker.top.equalTo()(self.optionView)
            maker.right.equalTo()(self.optionView)
            maker.height.equalTo()(self.optionView).multipliedBy()(0.5)
        }
        
        pwdInput.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView)
            maker.bottom.equalTo()(self.optionView)
            maker.right.equalTo()(self.optionView)
            maker.height.equalTo()(self.optionView).multipliedBy()(0.5)
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
    
    @objc private func buttonTapAction(button : UIButton) {
        self.view.endEditing(true)
        
        if button.tag == 888 {
            let username = phoneInput.text!
            let password = pwdInput.text!
            var error   = ""
            if username.isEmpty {
                error   = "请填写用户名"
                phoneInput.becomeFirstResponder()
            }else if password.isEmpty {
                error   = "请输入密码"
                pwdInput.becomeFirstResponder()
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
                        userData.timeStamp  = UtilDateTime.getTimeInterval()
                        Commond.setUserDefaults(userData, key: "userData")
                        self.dismissViewControllerAnimated(true, completion: self.callBack)
                    }else{
                        UtilTool.noticError(view: self.view, msg: loginData!.responseMsg!)
                        Commond.removeUserDefaults("userData")
                    }
                    
                    }, failure: { (error) -> Void in
                        button.enabled  = true
                        button.setTitle("登录", forState: UIControlState.Normal)
                        UtilTool.noticError(view: self.view, msg: error.msg!)
                        Commond.removeUserDefaults("userData")
                })
            }else{
                UtilTool.noticError(view: self.view, msg: error)
            }
        }else{
            let registerVc          = UCRegisterViewController()
            self.navigationController?.pushViewController(registerVc, animated: true)
        }
    }
    
    class func autoLoginWithUserData(userData : UCUserData , succ : (() -> Void)? , failure : (() -> Void)?) {
        UCService.loginActionWithUsername(userData.loginName, loginPassword: userData.password, completion: { (loginData) -> Void in
            if loginData?.cjxnfsCode == 10000 {
                let uData        = loginData as! UCUserData
                uData.password   = userData.password
                uData.timeStamp  = UtilDateTime.getTimeInterval()
                Commond.setUserDefaults(uData, key: "userData")
                succ?()
            }else{
                Commond.removeUserDefaults("userData")
                failure?()
            }
            
            }, failure: { (error) -> Void in
                Commond.removeUserDefaults("userData")
                failure?()
        })
    }

}
