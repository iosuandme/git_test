//
//  UCRechargeViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/21.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCRechargeViewController: BaseViewController {
    
    var  cellPhone                  : String    = ""
    private var scrollView          : UIScrollView!
    private var cardNoLabel         : UILabel!
    private var cardNameLabel       : UILabel!
    private var amountInput         : UITextField!
    private let hintStr                         = "目前支持的银行有中国光大银行、招商银行、广发银行、兴业银行、中国农业银行、中国银行、交通银行、中国民生银行、中信银行、浦发银行、中国工商银行、中国建设银行"
    private var bankInfo            : UCBankCardInfo? {
        didSet {
            if bankInfo != nil {
                cardNameLabel.text              = bankInfo?.cardName
                cardNoLabel.text                = UtilTool.bankCardFormat(bankInfo!.cardNo)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title                              = "充值"
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
        
        let hint1                               = UILabel()
        hint1.font                              = UIFont.systemFontOfSize(10)
        hint1.textColor                         = UtilTool.colorWithHexString("#a8a8a9")
        hint1.text                              = "充值银行卡"
        scrollView.addSubview(hint1)
        
        hint1.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.scrollView).offset()(16)
            maker.right.equalTo()(self.view).offset()(-16)
            maker.top.equalTo()(self.scrollView).offset()(8)
            maker.height.equalTo()(10)
        }
        
        
        let topView                             = UIView()
        topView.backgroundColor                 = UIColor.whiteColor()
        scrollView.addSubview(topView)
        
        topView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.scrollView)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(hint1.mas_bottom).offset()(8)
            maker.height.equalTo()(100)
        }
        
        let noLabel                             = UILabel()
        noLabel.font                            = UIFont.systemFontOfSize(14)
        noLabel.textColor                       = UtilTool.colorWithHexString("#666")
        noLabel.text                            = "卡号"
        topView.addSubview(noLabel)
        
        noLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(topView).offset()(16)
            maker.top.equalTo()(topView).offset()(17.5)
            maker.width.equalTo()(35)
            maker.height.equalTo()(14)
        }
        
        let accessaryArr                        = UIImageView()
        accessaryArr.image                      = UIImage(named: "uc_cell_arr")
        topView.addSubview(accessaryArr)
        
        accessaryArr.mas_makeConstraints { (maker) in
            maker.right.equalTo()(topView).offset()(-16)
            maker.centerY.equalTo()(noLabel)
            maker.width.equalTo()(7)
            maker.height.equalTo()(12)
        }
        
        cardNoLabel                             = UILabel()
        cardNoLabel.font                        = UIFont.systemFontOfSize(14)
        cardNoLabel.textColor                   = UtilTool.colorWithHexString("#666")
        cardNoLabel.text                        = "选择充值银行卡"
        topView.addSubview(cardNoLabel)
        
        cardNoLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(topView).offset()(100)
            maker.right.equalTo()(accessaryArr.mas_left).offset()(10)
            maker.centerY.equalTo()(noLabel)
            maker.height.equalTo()(14)
        }
        
        let nameLabel                           = UILabel()
        nameLabel.font                          = UIFont.systemFontOfSize(14)
        nameLabel.textColor                     = UtilTool.colorWithHexString("#666")
        nameLabel.text                          = "银行"
        topView.addSubview(nameLabel)
        
        nameLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(noLabel)
            maker.bottom.equalTo()(topView).offset()(-17.5)
            maker.width.equalTo()(noLabel)
            maker.height.equalTo()(14)
        }
        
        cardNameLabel                           = UILabel()
        cardNameLabel.font                      = UIFont.systemFontOfSize(14)
        cardNameLabel.textColor                 = UtilTool.colorWithHexString("#666")
        cardNameLabel.text                      = "--"
        topView.addSubview(cardNameLabel)
        
        cardNameLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(topView).offset()(100)
            maker.right.equalTo()(topView).offset()(-16)
            maker.centerY.equalTo()(nameLabel)
            maker.height.equalTo()(14)
        }
        
        let selectBtn                           = BaseButton()
        selectBtn.addTarget(self, action: #selector(UCRechargeViewController.selectAction), forControlEvents: UIControlEvents.TouchUpInside)
        topView.addSubview(selectBtn)
        
        selectBtn.mas_makeConstraints { (maker) in
            maker.left.equalTo()(noLabel)
            maker.right.equalTo()(accessaryArr)
            maker.top.equalTo()(topView)
            maker.height.equalTo()(49.5)
        }
        
        let line                                = UIView()
        line.backgroundColor                    = UtilTool.colorWithHexString("#ddd")
        topView.addSubview(line)
        
        line.mas_makeConstraints { (maker) in
            maker.left.equalTo()(noLabel)
            maker.right.equalTo()(accessaryArr)
            maker.centerY.equalTo()(topView)
            maker.height.equalTo()(0.5)
        }
        
        let hint2                               = UILabel()
        hint2.font                              = UIFont.systemFontOfSize(10)
        hint2.textColor                         = UtilTool.colorWithHexString("#a8a8a9")
        hint2.text                              = "充值金额"
        scrollView.addSubview(hint2)
        
        hint2.mas_makeConstraints { (maker) in
            maker.left.equalTo()(hint1)
            maker.right.equalTo()(hint1)
            maker.top.equalTo()(topView.mas_bottom).offset()(20)
            maker.height.equalTo()(10)
        }
        
        let midView                             = UIView()
        midView.backgroundColor                 = UIColor.whiteColor()
        scrollView.addSubview(midView)
        
        midView.mas_makeConstraints { (maker) in
            maker.top.equalTo()(hint2.mas_bottom).offset()(8)
            maker.left.equalTo()(topView)
            maker.right.equalTo()(topView)
            maker.height.equalTo()(50)
        }
        
        let moneyLabel                          = UILabel()
        moneyLabel.font                         = UIFont.systemFontOfSize(14)
        moneyLabel.textColor                    = UtilTool.colorWithHexString("#666")
        moneyLabel.text                         = "金额"
        midView.addSubview(moneyLabel)
        
        moneyLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(midView).offset()(16)
            maker.centerY.equalTo()(midView)
            maker.width.equalTo()(35)
            maker.height.equalTo()(14)
        }
        
        let inputView                           = UIView()
        inputView.layer.cornerRadius            = 3
        inputView.layer.masksToBounds           = true
        inputView.layer.borderColor             = UtilTool.colorWithHexString("#ddd").CGColor
        inputView.layer.borderWidth             = 1
        midView.addSubview(inputView)
        
        inputView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(midView).offset()(100)
            maker.centerY.equalTo()(midView)
            maker.right.equalTo()(midView).offset()(-16)
            maker.height.equalTo()(34)
        }
        
        amountInput                             = UITextField()
        amountInput.font                        = UIFont.systemFontOfSize(14)
        amountInput.placeholder                 = "充值金额，最低一元"
        amountInput.textColor                   = UtilTool.colorWithHexString("#666")
        amountInput.keyboardType                = .DecimalPad
        amountInput.delegate                    = self
        inputView.addSubview(amountInput)
        
        amountInput.mas_makeConstraints { (maker) in
            maker.left.equalTo()(inputView).offset()(8)
            maker.right.equalTo()(inputView).offset()(-8)
            maker.centerY.equalTo()(inputView)
            maker.height.equalTo()(30)
        }
        
        let rechargeBtn                         = BaseButton()
        rechargeBtn.backgroundColor             = UtilTool.colorWithHexString("#53a0e3")
        rechargeBtn.titleLabel?.font            = UIFont.systemFontOfSize(15)
        rechargeBtn.layer.cornerRadius          = 4
        rechargeBtn.layer.masksToBounds         = true
        rechargeBtn.setTitle("下一步", forState: UIControlState.Normal)
        rechargeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rechargeBtn.addTarget(self, action: #selector(UCRechargeViewController.rechargeAction), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(rechargeBtn)
        
        rechargeBtn.mas_makeConstraints { (maker) in
            maker.top.equalTo()(midView.mas_bottom).offset()(20)
            maker.left.equalTo()(midView).offset()(16)
            maker.right.equalTo()(midView).offset()(-16)
            maker.height.equalTo()(40)
        }
        
        let bottomView                          = UIView()
        bottomView.backgroundColor              = UtilTool.colorWithHexString("#fcf7e3")
        bottomView.layer.borderColor            = UtilTool.colorWithHexString("#fbf0d5").CGColor
        bottomView.layer.borderWidth            = 1
        scrollView.addSubview(bottomView)
        
        bottomView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(midView).offset()(-1)
            maker.right.equalTo()(midView).offset()(1)
            maker.top.equalTo()(rechargeBtn.mas_bottom).offset()(20)
            maker.height.equalTo()(80)
        }
        
        let hintLabel                           = UILabel()
        hintLabel.font                          = UIFont.systemFontOfSize(12)
        hintLabel.textColor                     = UtilTool.colorWithHexString("#bca982")
        hintLabel.numberOfLines                 = 0
        let paragraph                           = NSMutableParagraphStyle()
        paragraph.lineSpacing                   = 3
        hintLabel.attributedText                = NSAttributedString(string: hintStr, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(12) , NSParagraphStyleAttributeName : paragraph , NSForegroundColorAttributeName : UtilTool.colorWithHexString("#bca982")])
        bottomView.addSubview(hintLabel)
        
        hintLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(bottomView).offset()(17)
            maker.right.equalTo()(bottomView).offset()(-17)
            maker.centerY.equalTo()(bottomView)
        }
        
    }
    
    @objc private func selectAction() {
        let bankCardVc                          = UCBankCardListController()
        bankCardVc.optionType                   = .Select
        weak var weakSelf                       = self
        bankCardVc.callBack                     = {(info) in
            weakSelf!.bankInfo                  = info
        }
        bankCardVc.selectionData                = bankInfo
        self.navigationController?.pushViewController(bankCardVc, animated: true)
    }
    
    @objc private func rechargeAction() {
        
        var error               = ""
        if bankInfo == nil {
            error               = "请选择充值银行卡"
        }else if amountInput.text!.isEmpty {
            error               = "请输入充值金额"
            amountInput.becomeFirstResponder()
        }else if Double(amountInput.text!) == nil {
            error               = "金额输入有误"
            amountInput.becomeFirstResponder()
        }else if Double(amountInput.text!) < 1 {
            error               = "最低充值1元"
            amountInput.becomeFirstResponder()
        }
        
        if error.isEmpty {
            let tmpAmount           = Int(Double(amountInput.text!)! * 100)
            let amount              = (Double(tmpAmount) / 100).formatDecimal(false)
            let confirmVc           = UCRechargeConfirmController()
            confirmVc.rechargeInfo  = RechargeData(bankInfo: bankInfo, amount: amount, cellPhone: cellPhone)
            self.navigationController?.pushViewController(confirmVc, animated: true)
            
        }else{
            UtilTool.noticError(view: self.view, msg: error)
        }
    }
}

extension UCRechargeViewController : UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0 {
            if string != "." {
                guard let _ = Int(string) else{
                    return false
                }
            }
            if string == "." && (textField.text!.containsString(string) || textField.text!.isEmpty) {
                return false
            }
            if string == "0" && textField.text!.isEmpty {
                return false
            }
        }
        return true
    }
    
    
}

