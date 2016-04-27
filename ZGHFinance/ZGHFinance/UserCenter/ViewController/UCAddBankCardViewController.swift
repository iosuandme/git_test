//
//  UCAddBankCardViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/26.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCAddBankCardViewController: BaseViewController , UCInputViewDelegate , UCBankPickerViewDelegate{

    var userInfo                : UCUserInfoData?
    var banks                   : Array<String> = Array()
    private var scrollView      : UIScrollView!
    private var optionView      : UIView!
    private var realName        : UCInputView!
    private var bankName        : UCInputView!
    private var bankCard        : UCInputView!
    private var localAddr       : UCInputView!
    private var phoneLabel      : UCInputView!
    private var mbCode          : UCInputView!
    private var submitBtn       : BaseButton!
    private let bankInfo = ["招商银行","工商银行","光大银行","广发银行","建设银行","民生银行","农业银行","浦发银行","兴业银行","中国银行","中信银行","交通银行"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title                              = "添加银行卡"
    }
    
    override func initUI() {
        super.initUI()
        if userInfo == nil {
            return
        }
        scrollView                              = UIScrollView()
        scrollView.contentSize                  = CGSizeMake(self.view.bounds.width, 350)
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
        scrollView.addSubview(optionView)
        
        optionView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.scrollView)
            maker.top.equalTo()(self.scrollView).offset()(20)
            maker.right.equalTo()(self.view)
            maker.height.equalTo()(40 * 6)
        }
        
        submitBtn                               = BaseButton()
        submitBtn.layer.cornerRadius            = 4
        submitBtn.backgroundColor               = UtilTool.colorWithHexString("#53a0e3")
        submitBtn.titleLabel?.font              = UIFont.systemFontOfSize(14)
        submitBtn.setTitle("添加", forState: UIControlState.Normal)
        submitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submitBtn.addTarget(self, action: #selector(UCAddBankCardViewController.buttonTapAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        scrollView.addSubview(submitBtn)
        
        submitBtn.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.optionView).offset()(16)
            maker.right.equalTo()(self.optionView).offset()(-16)
            maker.top.equalTo()(self.optionView.mas_bottom).offset()(30)
            maker.height.equalTo()(40)
        }
        
        realName                                = UCInputView(type: .Normal, delegate: self, needLine: true)
        realName.iconImage                      = UIImage(named: "uc_icon_idcard")
        realName.placeholder                    = "真实姓名"
        realName.tag                            = 100
        realName.text                           = userInfo?.realname
        realName.userInteractionEnabled         = false
        
        bankName                                = UCInputView(type: .Select, delegate: self, needLine: true)
        bankName.iconImage                      = UIImage(named: "uc_bankcard")
        bankName.text                           = "请选择银行"
        bankName.tag                            = 101
        
        bankCard                                = UCInputView(type: .Normal, delegate: self, needLine: true)
        bankCard.iconImage                      = UIImage(named: "uc_bankcard")
        bankCard.keyboardType                   = .NumberPad
        bankCard.placeholder                    = "银行卡号"
        bankCard.tag                            = 102
        
        localAddr                               = UCInputView(type: .Normal, delegate: self, needLine: true)
        localAddr.iconImage                     = UIImage(named: "uc_icon_local")
        localAddr.placeholder                   = "银行所在地及支行"
        localAddr.tag                           = 103
        
        phoneLabel                              = UCInputView(type: .Normal, delegate: self, needLine: true)
        phoneLabel.iconImage                    = UIImage(named: "uc_login_phone")
        phoneLabel.userInteractionEnabled       = false
        phoneLabel.tag                          = 104
        phoneLabel.text                         = userInfo?.cellPhone
        
        mbCode                                  = UCInputView(type: .WithButton, delegate: self, needLine: false)
        mbCode.iconImage                        = UIImage(named: "uc_login_key")
        mbCode.placeholder                      = "手机验证码"
        mbCode.keyboardType                     = .NumberPad
        mbCode.btnTitle                         = "获取验证码"
        mbCode.tag                              = 105
        
        optionView.addSubview(realName)
        optionView.addSubview(bankName)
        optionView.addSubview(bankCard)
        optionView.addSubview(localAddr)
        optionView.addSubview(phoneLabel)
        optionView.addSubview(mbCode)
        
        var lastView : UCInputView?
        for i in 100 ... 105 {
            if let tmpView = optionView.viewWithTag(i) as? UCInputView {
                tmpView.mas_makeConstraints({ (maker) in
                    maker.left.equalTo()(self.optionView).offset()(16)
                    maker.right.equalTo()(self.optionView).offset()(-16)
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
        
        self.view.endEditing(true)
        var error           = ""
        if bankName.text!.isEmpty || bankName.text! == "请选择银行" {
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
        }else if banks.contains(bankCard.text!) {
            error           = "该银行卡已存在"
            bankCard.becomeFirstResponder()
        }

        if error.isEmpty {
            if let userInfo = Commond.getUserDefaults("userData") as? UCUserData {
                
                let params : Dictionary<String , AnyObject> = ["token" : userInfo.loginToken , "bankName" : UtilTool.getBankName(bankName.text!, keyForValue: false) , "bankNo" : bankCard.text! , "location" : localAddr.text! , "mbCode" : mbCode.text!]
                
                UCService.addBankCardWithParams(params, completion: { (data) in
                    let res = data?.responseData + ""
                    if res == "0" {
                        UtilTool.noticError(view: self.view, msg: "添加成功", complete: { 
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    }else{
                        UtilTool.noticError(view: self.view, msg: "添加失败(错误码:\(res))")
                    }
                    }, failure: { (error) in
                        UtilTool.noticError(view: self.view, msg: error.msg!)
                })
            }else{
                UtilTool.noticError(view: self.view, msg: "未登录")
            }
        }else{
            UtilTool.noticError(view: self.view, msg: error)
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
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(UCAddBankCardViewController.timeCount(_:)), userInfo: actionButton, repeats: true)
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
