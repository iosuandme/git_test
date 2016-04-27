//
//  HomeInvestPayController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/25.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class HomeInvestPayController: BaseViewController {
    
    var isBenefit                   : Bool      = true
    var id                          : String    = ""
    private var scrollView          : UIScrollView!
    private var titleLabel          : UILabel!
    private var totalLabel          : UILabel!
    private var balanceHint         : UILabel!
    private var balanceLabel        : UILabel!
    private var amountInput         : UITextField!
    private var payButton           : BaseButton!
    
    private var unit                : String{return isBenefit ? "个" : "元"}
    private var totalAmount         : Double    = 0 {
        didSet {
            totalLabel.text                     = totalAmount.formatDecimal(false) + "元"
        }
    }
    private var usableAmount        : Double    = 0 {
        didSet {
            balanceLabel.text                   = usableAmount.formatDecimal(false) + unit
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if isBenefit {
            self.title                          = "公益捐赠"
        }else{
            self.title                          = "项目投资"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func initUI() {
        super.initUI()
        
        scrollView                              = UIScrollView()
        scrollView.alwaysBounceVertical         = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize                  = CGSizeMake(self.view.bounds.width, 300)
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
            maker.top.equalTo()(self.scrollView)
            maker.width.equalTo()(self.view)
            maker.height.equalTo()(170)
        }
        
        titleLabel                              = UILabel()
        titleLabel.font                         = UIFont.systemFontOfSize(15)
        titleLabel.textColor                    = UtilTool.colorWithHexString("#666")
        contentView.addSubview(titleLabel)
        
        titleLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(contentView).offset()(16)
            maker.right.equalTo()(contentView).offset()(-16)
            maker.top.equalTo()(contentView).offset()(8)
            maker.height.equalTo()(15)
        }
        
        let line1                               = UIView()
        line1.backgroundColor                   = UtilTool.colorWithHexString("#ddd")
        contentView.addSubview(line1)
        
        line1.mas_makeConstraints { (maker) in
            maker.left.equalTo()(contentView)
            maker.right.equalTo()(contentView)
            maker.top.equalTo()(self.titleLabel.mas_bottom).offset()(8)
            maker.height.equalTo()(0.5)
        }
        
        let totalHint                           = UILabel()
        totalHint.font                          = UIFont.systemFontOfSize(12)
        totalHint.textColor                     = UtilTool.colorWithHexString("#a8a8a9")
        totalHint.text                          = "剩余金额"
        contentView.addSubview(totalHint)
        
        totalHint.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.titleLabel)
            maker.top.equalTo()(line1.mas_bottom).offset()(18)
            maker.height.equalTo()(12)
        }
        
        totalLabel                              = UILabel()
        totalLabel.font                         = UIFont.systemFontOfSize(12)
        totalLabel.textColor                    = UtilTool.colorWithHexString("#666")
        totalLabel.textAlignment                = .Right
        totalLabel.text                         = "0元"
        contentView.addSubview(totalLabel)
        
        totalLabel.mas_makeConstraints { (maker) in
            maker.right.equalTo()(self.titleLabel)
            maker.top.equalTo()(totalHint)
            maker.height.equalTo()(12)
        }
        
        balanceHint                             = UILabel()
        balanceHint.font                        = UIFont.systemFontOfSize(12)
        balanceHint.textColor                   = UtilTool.colorWithHexString("#a8a8a9")
        balanceHint.text                        = isBenefit ? "可用爱心币" : "可用余额"
        contentView.addSubview(balanceHint)
        
        balanceHint.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.titleLabel)
            maker.top.equalTo()(totalHint.mas_bottom).offset()(18)
            maker.height.equalTo()(12)
        }
        
        let infoBtn                     = BaseButton()
        infoBtn.setImage(UIImage(named: "uc_property_icon_warning"), forState: UIControlState.Normal)
        infoBtn.addTarget(self, action: #selector(HomeInvestPayController.showInfo), forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(infoBtn)
        infoBtn.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.balanceHint.mas_right).offset()(6)
            maker.centerY.equalTo()(self.balanceHint)
            maker.width.equalTo()(20)
            maker.height.equalTo()(20)
        }
        
        balanceLabel                            = UILabel()
        balanceLabel.font                       = UIFont.systemFontOfSize(12)
        balanceLabel.textColor                  = UtilTool.colorWithHexString("#ff6600")
        balanceLabel.textAlignment              = .Right
        balanceLabel.text                       = isBenefit ? "0个" : "0元"
        contentView.addSubview(balanceLabel)
        
        balanceLabel.mas_makeConstraints { (maker) in
            maker.right.equalTo()(self.titleLabel)
            maker.top.equalTo()(self.balanceHint)
            maker.height.equalTo()(12)
        }
        
        amountInput                             = UITextField()
        amountInput.font                        = UIFont.systemFontOfSize(14)
        amountInput.textAlignment               = .Center
        amountInput.textColor                   = UtilTool.colorWithHexString("#666")
        amountInput.keyboardType                = .NumberPad
        amountInput.placeholder                 = "投标金额"
        amountInput.layer.cornerRadius          = 3
        amountInput.layer.masksToBounds         = true
        amountInput.layer.borderColor           = UtilTool.colorWithHexString("#ddd").CGColor
        amountInput.layer.borderWidth           = 1
        amountInput.becomeFirstResponder()
        amountInput.addTarget(self, action: #selector(HomeInvestPayController.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        contentView.addSubview(amountInput)
        
        amountInput.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.titleLabel)
            maker.right.equalTo()(self.titleLabel)
            maker.top.equalTo()(self.balanceLabel.mas_bottom).offset()(18)
            maker.height.equalTo()(40)
        }
        
        payButton                               = BaseButton()
        payButton.backgroundColor               = UtilTool.colorWithHexString("#53a0e3")
        payButton.layer.cornerRadius            = 4
        payButton.layer.masksToBounds           = true
        payButton.titleLabel?.font              = UIFont.systemFontOfSize(14)
        payButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        let title                               = isBenefit ? "捐赠" : "投资"
        payButton.setTitle(title, forState: UIControlState.Normal)
        payButton.addTarget(self, action: #selector(HomeInvestPayController.payAction), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(payButton)
        
        payButton.mas_makeConstraints { (maker) in
            maker.left.equalTo()(contentView).offset()(16)
            maker.right.equalTo()(contentView).offset()(-16)
            maker.top.equalTo()(contentView.mas_bottom).offset()(30)
            maker.height.equalTo()(40)
        }
        
    }
    
    @objc private func showInfo() {
        let alert               = SMAlertView(title: "什么是爱心币", message: "爱心币是用于捐赠公益项目的代币，首次注册会获取一定数量的爱心币，某些线下活动也能获取爱心币奖励(如投资活动)，爱心币不可通过充值获取。捐赠的爱心币会以等额的价值由中赣核普惠金融资助给公益项目的组织者。", delegate: nil, cancelButtonTitle: "我知道了")
        alert.show()
    }
    
    override func needRefrshData() -> Bool {
        return false
    }
    
    override func refreshData() {
        
        if isBenefit {
            
            if let uData = Commond.getUserDefaults("userData") as? UCUserData {
                UCService.getUserDataWithToken(uData.loginToken, completion: { (userData) in
                    if userData?.cjxnfsCode == 10000 {
                        self.usableAmount   = Double((userData as! UCUserInfoData).loveCoins)
                    }else{
                        UtilTool.noticError(view: self.view, msg: userData!.responseMsg!)
                    }
                    }, failure: { (error) in
                        UtilTool.noticError(view: self.view, msg: error.msg!)
                })
            }
            
            HomeService.getHomeBenefitDetailData(id, needContent: false , completion: { (detail) -> Void in
                if detail?.cjxnfsCode == 10000 {
                    let tmp                 = detail as! HomeBenefitDetailData
                    self.titleLabel.text    = tmp.title
                    self.totalAmount        = Double(tmp.total - tmp.collected)
                }else{
                    UtilTool.noticError(view: self.view, msg: detail!.responseMsg!)
                }
                }, failure: { (error) -> Void in
                    UtilTool.noticError(view: self.view, msg: error.msg!)
            })
        }else{
            
            if let uData = Commond.getUserDefaults("userData") as? UCUserData {
                UCService.getAccountDataWithToken(uData.loginToken, completion: { (accountData) in
                    if accountData?.cjxnfsCode == 10000 {
                        let tmp             = accountData as! UCAccountInfoData
                        self.usableAmount   = tmp.balance - tmp.frozenFund
                    }else{
                        UtilTool.noticError(view: self.view, msg: accountData!.responseMsg!)
                    }
                    }, failure: { (error) in
                        UtilTool.noticError(view: self.view, msg: error.msg!)
                })
            }
            
            FinancingService.getFinancingDetailData(id, completion: { (detail) -> Void in
                if detail?.cjxnfsCode == 10000 {
                    let tmp                 = detail as! FinanceDetailData
                    self.titleLabel.text    = tmp.headerData.title
                    self.totalAmount        = Double(tmp.headerData.borrowLimit - tmp.headerData.collected)
                }else{
                    UtilTool.noticError(view: self.view, msg: detail!.responseMsg!)
                }
                }, failure: { (error) -> Void in
                    UtilTool.noticError(view: self.view, msg: error.msg!)
            })
            
        }
    }
    
    @objc private func textDidChange(tf : UITextField) {
        if !tf.text!.isEmpty {
            if let amount  = Double(tf.text!) {
                if amount > usableAmount {
                    tf.text = "\(Int(usableAmount))"
                }
                if amount > totalAmount {
                    tf.text = "\(Int(totalAmount))"
                }
            }else{
                tf.text     = "0"
            }
        }
    }
    
    @objc private func payAction() {
        var error           = ""
        if amountInput.text!.isEmpty {
            error           = "请输入金额"
        }else if Double(amountInput.text!) < 1 {
            error           = "最低投资1元"
        }
        if error.isEmpty {
            self.view.endEditing(true)
            let action      = isBenefit ? "捐赠" : "投资"
            if let uData = Commond.getUserDefaults("userData") as? UCUserData {
                let params : Dictionary<String , AnyObject> = ["token" : uData.loginToken , "bidId" : id , "money" : amountInput.text!]
                UCService.payForBidWithParams(isBenefit, params: params, completion: { (bsd) in
                    if bsd?.cjxnfsCode == 10000 {
                        UtilTool.noticError(view: self.view, msg: "\(action)成功" , complete: {
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    }else if bsd?.cjxnfsCode == 10001 {
                        UtilTool.noticError(view: self.view, msg: bsd!.responseMsg!)
                    }else{
                        UtilTool.noticError(view: self.view, msg: "\(action)失败")
                    }
                    }, failure: { (error) in
                        UtilTool.noticError(view: self.view, msg: "\(action)失败")
                })
                
            }
        }else{
            UtilTool.noticError(view: self.view, msg: error)
        }
    }

}
