//
//  FinanceDetailHeaderView.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/10.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//  225

import UIKit

protocol FinanceDetailHeaderViewDelegate : NSObjectProtocol {
    func detailHeaderTouchEvent()
}

class FinanceDetailHeaderView: UIView {

    private var titleLabel      : UILabel!
    private var statusLabel     : UILabel!
    private var rateLabel       : UILabel!
    private var timeLabel       : UILabel!
    private var amountLabel     : UILabel!
    private var progressView    : UIProgressView!
    private var processLabel    : UILabel!
    private var expectLabel     : UILabel!
    private var buyButton       : BaseButton!
    private weak var delegate   : FinanceDetailHeaderViewDelegate?
    

    init(delegate: FinanceDetailHeaderViewDelegate?) {
        super.init(frame: CGRectZero)
        self.backgroundColor    = UIColor.whiteColor()
        self.delegate           = delegate
        initUI()
    }
    
    func showHeaderData(data : FinanceDetailHeadData) {
        titleLabel.text                 = data.title
        statusLabel.text                = data.status
        var str : NSString              = "\(data.rate)%"
        var attri                       = NSMutableAttributedString(string: str as String)
        attri.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: str.rangeOfString(data.rate))
        rateLabel.attributedText        = attri
        str                             = "\(data.timePeriod) 个月"
        attri                           = NSMutableAttributedString(string: str as String)
        attri.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(18),NSForegroundColorAttributeName : UtilTool.colorWithHexString("#666")], range: str.rangeOfString(data.timePeriod))
        timeLabel.attributedText        = attri
        str                             = "\(data.borrowLimit / 10000) 万元"
        attri                           = NSMutableAttributedString(string: str as String)
        attri.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(18),NSForegroundColorAttributeName : UtilTool.colorWithHexString("#666")], range: str.rangeOfString("\(data.borrowLimit / 10000)"))
        amountLabel.attributedText      = attri
        
        processLabel.text               = "已加入\((Double(data.collected) / Double(data.borrowLimit) * 100).format(".0"))%，剩余金额\((Double(data.borrowLimit) - Double(data.collected)).formatDecimal(true))元"
        expectLabel.text                = "投资每万元预期收益\(data.expectProfit)元"
        
        if data.collected == data.borrowLimit {
            progressView.progressTintColor  = UtilTool.colorWithHexString("#53a0e3")
            progressView.progress           = 1
            buyButton.backgroundColor       = UtilTool.colorWithHexString("#53a0e3")
            buyButton.enabled               = false
            buyButton.setTitle("筹款完成", forState: UIControlState.Normal)
        }else{
            progressView.progressTintColor  = UtilTool.colorWithHexString("#f0ad4e")
            progressView.progress           = Float(data.collected) / Float(data.borrowLimit)
            buyButton.backgroundColor       = UtilTool.colorWithHexString("#f0ad4e")
            buyButton.enabled               = true
            buyButton.setTitle("立即投资", forState: UIControlState.Normal)
        }
    }
    
    private func initUI() {
        
        titleLabel                      = UILabel()
        titleLabel.font                 = UIFont.systemFontOfSize(14)
        titleLabel.textColor            = UtilTool.colorWithHexString("#666")
        
        statusLabel                     = UILabel()
        statusLabel.font                = UIFont.systemFontOfSize(12)
        statusLabel.textColor           = UIColor.whiteColor()
        statusLabel.textAlignment       = .Center
        statusLabel.backgroundColor     = UtilTool.colorWithHexString("#f0ad4e")
        statusLabel.layer.cornerRadius  = 3
        statusLabel.layer.masksToBounds = true
        
        rateLabel                       = UILabel()
        rateLabel.font                  = UIFont.systemFontOfSize(10)
        rateLabel.textColor             = UtilTool.colorWithHexString("#ff6600")
        rateLabel.textAlignment         = .Center
        rateLabel.contentMode           = .Bottom
        
        timeLabel                       = UILabel()
        timeLabel.font                  = UIFont.systemFontOfSize(10)
        timeLabel.textColor             = UtilTool.colorWithHexString("#666")
        timeLabel.textAlignment         = .Center
        timeLabel.contentMode           = .Bottom
        
        amountLabel                     = UILabel()
        amountLabel.font                = UIFont.systemFontOfSize(10)
        amountLabel.textColor           = UtilTool.colorWithHexString("#666")
        amountLabel.textAlignment       = .Center
        amountLabel.contentMode         = .Bottom
        
        progressView                    = UIProgressView()
        progressView.trackTintColor     = UtilTool.colorWithHexString("#ddd")
        progressView.layer.cornerRadius = 4
        progressView.layer.masksToBounds = true
        progressView.progressTintColor  = UtilTool.colorWithHexString("#f0ad4e")
        progressView.progress           = 0
        
        processLabel                    = UILabel()
        processLabel.font               = UIFont.systemFontOfSize(12)
        processLabel.textColor          = UtilTool.colorWithHexString("#a3a3a3")
        
        expectLabel                     = UILabel()
        expectLabel.font                = UIFont.systemFontOfSize(12)
        expectLabel.textColor           = UtilTool.colorWithHexString("#a3a3a3")
        
        buyButton                       = BaseButton()
        buyButton.layer.cornerRadius    = 4
        buyButton.layer.masksToBounds   = true
        buyButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buyButton.titleLabel?.font      = UIFont.systemFontOfSize(14)
        buyButton.addTarget(self, action: "buyAction", forControlEvents: UIControlEvents.TouchUpInside)
        
        let topLine                     = UIView()
        topLine.backgroundColor         = UtilTool.colorWithHexString("#ddd")
        
        let rateHint                    = UILabel()
        rateHint.font                   = UIFont.systemFontOfSize(12)
        rateHint.textColor              = UtilTool.colorWithHexString("#a3a3a3")
        rateHint.text                   = "年化利率"
        
        let timeHint                    = UILabel()
        timeHint.font                   = UIFont.systemFontOfSize(12)
        timeHint.textColor              = UtilTool.colorWithHexString("#a3a3a3")
        timeHint.textAlignment          = .Center
        timeHint.text                   = "借款期限"
        
        let amountHint                  = UILabel()
        amountHint.font                 = UIFont.systemFontOfSize(12)
        amountHint.textColor            = UtilTool.colorWithHexString("#a3a3a3")
        amountHint.textAlignment        = .Right
        amountHint.text                 = "项目金额"
        
        let midLine                     = UIView()
        midLine.backgroundColor         = UtilTool.colorWithHexString("#ddd")
        
        self.addSubview(titleLabel)
        self.addSubview(statusLabel)
        self.addSubview(topLine)
        self.addSubview(rateLabel)
        self.addSubview(timeLabel)
        self.addSubview(amountLabel)
        self.addSubview(rateHint)
        self.addSubview(timeHint)
        self.addSubview(amountHint)
        self.addSubview(progressView)
        self.addSubview(processLabel)
        self.addSubview(midLine)
        self.addSubview(expectLabel)
        self.addSubview(buyButton)
        
        titleLabel.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self).offset()(16)
            maker.top.equalTo()(self).offset()(12)
            maker.height.equalTo()(14)
        }
        
        statusLabel.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.titleLabel.mas_right).offset()(5)
            maker.centerY.equalTo()(self.titleLabel)
            maker.width.equalTo()(60)
            maker.height.equalTo()(18)
        }
        
        topLine.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
            maker.top.equalTo()(self.titleLabel.mas_bottom).offset()(12)
            maker.height.equalTo()(1)
        }
        
        rateHint.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self).offset()(24)
            maker.top.equalTo()(topLine.mas_bottom).offset()(46)
            maker.height.equalTo()(12)
        }
        
        rateLabel.mas_makeConstraints { (maker) -> Void in
            maker.centerX.equalTo()(rateHint)
            maker.top.equalTo()(topLine.mas_bottom).offset()(16)
            maker.height.equalTo()(18)
        }
        
        timeHint.mas_makeConstraints { (maker) -> Void in
            maker.centerX.equalTo()(self)
            maker.top.equalTo()(topLine.mas_bottom).offset()(46)
            maker.height.equalTo()(12)
        }
        
        timeLabel.mas_makeConstraints { (maker) -> Void in
            maker.centerX.equalTo()(timeHint)
            maker.top.equalTo()(topLine.mas_bottom).offset()(16)
            maker.height.equalTo()(18)
        }
        
        amountHint.mas_makeConstraints { (maker) -> Void in
            maker.right.equalTo()(self).offset()(-24)
            maker.top.equalTo()(topLine.mas_bottom).offset()(46)
            maker.height.equalTo()(12)
        }
        
        amountLabel.mas_makeConstraints { (maker) -> Void in
            maker.centerX.equalTo()(amountHint)
            maker.top.equalTo()(topLine.mas_bottom).offset()(16)
            maker.height.equalTo()(18)
        }
        
        progressView.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(rateHint)
            maker.right.equalTo()(amountHint)
            maker.top.equalTo()(rateHint.mas_bottom).offset()(10)
            maker.height.equalTo()(8)
        }
        
        processLabel.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(rateHint)
            maker.top.equalTo()(self.progressView.mas_bottom).offset()(8)
            maker.height.equalTo()(12)
        }
        
        midLine.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.progressView)
            maker.right.equalTo()(self.progressView)
            maker.top.equalTo()(self.processLabel.mas_bottom).offset()(4)
            maker.height.equalTo()(0.5)
        }
        
        expectLabel.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.processLabel)
            maker.top.equalTo()(midLine.mas_bottom).offset()(4)
            maker.height.equalTo()(12)
        }
        
        buyButton.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(midLine)
            maker.right.equalTo()(midLine)
            maker.bottom.equalTo()(self).offset()(-12)
            maker.height.equalTo()(40)
        }
        
    }
    
    @objc private func buyAction() {
        delegate?.detailHeaderTouchEvent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
