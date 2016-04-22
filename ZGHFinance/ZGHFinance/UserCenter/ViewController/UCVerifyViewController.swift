//
//  UCVerifyViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/12.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCVerifyViewController: BaseViewController , UCInputViewDelegate , UCBankPickerViewDelegate {
    
    var type                    : Int           = 1
    var userData                : UCUserInfoData?
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
    private let bankInfo = ["招商银行","工商银行","光大银行","广发银行","建设银行","民生银行","农业银行","浦发银行","兴业银行","中国银行","中信银行","交通银行"]

    override func viewDidLoad() {
        super.viewDidLoad()
        if type == 1 {
            self.title                          = "实名认证"
        }else{
            self.title                          = "绑定银行卡"
        }
    }
    
    override func initUI() {
        super.initUI()
        
        if userData != nil {
            
            if userData!.idCard.isEmpty || (type != 1 && userData!.bankCard.isEmpty){
                verifyUI()
            }else{
                let idCardView              = UCVerifyIdCardView()
                self.view.addSubview(idCardView)
                idCardView.mas_makeConstraints({ (maker) in
                    maker.left.equalTo()(self.view).offset()(16)
                    maker.right.equalTo()(self.view).offset()(-16)
                    maker.top.equalTo()(self.view).offset()(30)
                    maker.height.equalTo()(100)
                })
                var info : CardInfo?
                if type == 1 {
                    info                    = CardInfo(icon: UIImage(named: "uc_login_icon.jpg"), name: userData?.realname, id: UtilTool.idCardFormat(userData!.idCard), status: "已认证")
                    
                }else{
                    info                    = CardInfo(icon: UIImage(named: userData!.bankName), name: UtilTool.getBankName(userData!.bankName), id: UtilTool.bankCardFormat(userData!.bankCard), status: "已绑定")
                }
                idCardView.cardInfo         = info
            }
            
            
        }else{
            UtilTool.noticError(view: self.view, msg: "用户数据获取错误")
        }
        
    }
    
    private func verifyUI() {
        scrollView                              = UIScrollView()
        scrollView.contentSize                  = CGSizeMake(self.view.bounds.width, 500)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical         = true
        scrollView.keyboardDismissMode          = .OnDrag
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
        
        if !userData!.idCard.isEmpty {
            realName.text                       = userData!.realname
            realName.userInteractionEnabled     = false
            idCard.text                         = UtilTool.idCardFormat(userData!.idCard)
            idCard.userInteractionEnabled       = false
        }
        
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
        phoneLabel.text                         = userData?.cellPhone
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc private func buttonTapAction(btn : UIButton) {
        
        self.view.endEditing(true)
        var error           = ""
        if realName.text!.isEmpty {
            error           = "请填写真实姓名"
            realName.becomeFirstResponder()
        }else if idCard.text!.isEmpty {
            error           = "请填写身份证号"
            idCard.becomeFirstResponder()
        }else if dealPassword.text!.isEmpty {
            error           = "请填写交易密码"
            dealPassword.becomeFirstResponder()
        }else if reDealPassword.text!.isEmpty {
            error           = "请重复交易密码"
            reDealPassword.becomeFirstResponder()
        }else if phoneLabel.text!.isEmpty {
            error           = "手机号码不能为空"
        }else if bankName.text!.isEmpty || bankName.text! == "请选择银行" {
            error           = "请选择银行"
        }else if bankCard.text!.isEmpty {
            error           = "请填写银行卡号"
            bankCard.becomeFirstResponder()
        }else if localAddr.text!.isEmpty {
            error           = "请填写银行卡开户地"
            localAddr.becomeFirstResponder()
        }else if mbCode.text!.isEmpty {
            error           = "请填写验证码"
            mbCode.becomeFirstResponder()
        }else if userData!.idCard.isEmpty && !checkIdCard(idCard.text!) {
            error           = "身份证号不正确"
            idCard.becomeFirstResponder()
        }else if dealPassword.text! != reDealPassword.text! {
            error           = "两次交易密码不同"
            dealPassword.becomeFirstResponder()
        }
        
        if error.isEmpty {
            if let userInfo = Commond.getUserDefaults("userData") as? UCUserData {
                UCService.verifyAuthInfo([
                    "token" : userInfo.loginToken ,
                    "realname" : realName.text! ,
                    "idCard" : userData!.idCard.isEmpty ? idCard.text! : userData!.idCard ,
                    "phone" : phoneLabel.text! ,
                    "checkCode" : mbCode.text! ,
                    "tradePassword" : dealPassword.text! ,
                    "bankCardNo" : bankCard.text! ,
                    "pcId" : UtilTool.getBankName(bankName.text!, keyForValue: false) ,
                    "bankLocation" : localAddr.text!], completion: { (data) in
                        if let str = data?.responseData as? String {
                            if str.hasPrefix("uid") {
                                UtilTool.noticError(view: self.view, msg: "认证成功", offset: 0, time: 0.5, complete: {
                                    self.navigationController?.popViewControllerAnimated(true)
                                })
                            }else{
                                UtilTool.noticError(view: self.view, msg: "认证失败(\(str))")
                            }
                        }else{
                            UtilTool.noticError(view: self.view, msg: "信息有误，认证失败")
                        }
                    }, failure: { (error) in
                        UtilTool.noticError(view: self.view, msg: error.msg!)
                })
            }else{
                let _ = UCLoginViewController()
                self.presentViewController(UtilTool.getAppDelegate().navi, animated: true, completion: nil)
            }
        }else{
            UtilTool.noticError(view: self.view, msg: error)
        }
    }
    
    private func checkIdCard(id : String) -> Bool {
        if id.length() != 18 {
            return false
        }else{
            let subPreString = (id as NSString).substringToIndex(id.length() - 1)
            let subSufString = (id as NSString).substringFromIndex(id.length() - 1)
            if let _ = Int(subPreString) {
                if let _ = Int(subSufString) {
                    return true
                }else if subSufString == "x" || subSufString == "X" {
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        }
    }
    
    @objc private func timeCount(timer : NSTimer) {
        tInterval -= 1
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
    
    override func needKeyBoardObserver() -> Bool {
        return true
    }
    
    private weak var tmpCompareView : UCInputView?
    override func observerOptions() -> (transView: UIView?, compareView: UIView?) {
        return (scrollView , tmpCompareView)
    }
    
    //MARK: Delegate
    
    func inputViewButtonTap(inputView: UCInputView, actionButton: UIButton) {
        let phone = phoneLabel.text!
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
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(UCVerifyViewController.timeCount(_:)), userInfo: actionButton, repeats: true)
        }
    }
    
    func inputViewDidChanged(inputView: UCInputView, withInputString string: String) {
    }
    
    func inputViewSelected(inputView: UCInputView, withInputString string: String?) {
        self.view.endEditing(true)
        let picker                  = UCBankPickerView()
        picker.delegate             = self
        picker.dataSource           = bankInfo
        if let index = bankInfo.indexOf(bankName.text!) {
            picker.selectedIndex    = index
        }
        picker.showInView(self.view)
    }
    
    func inputViewStartEditing(inputView: UCInputView) {
        tmpCompareView      = inputView
    }
    
    func pickerViewDidSelectedWithName(name: String) {
        bankName.text       = name
    }
    
    private var tInterval   : Int               = 60

}
