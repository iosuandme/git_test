//
//  HomeBenefitHeaderView.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/15.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//  210

import UIKit

protocol HomeBenefitHeaderViewDelegate : NSObjectProtocol {
    func benefitHeaderTouchEvent()
}

class HomeBenefitHeaderView: UIView {

    private var titleLabel      : UILabel!
    private var statusLabel     : UILabel!
    private var rateLabel       : UILabel!
    private var timeLabel       : UILabel!
    private var progressView    : UIProgressView!
    private var processLabel    : UILabel!
    private var buyButton       : BaseButton!
    private weak var delegate   : HomeBenefitHeaderViewDelegate?
    
    
    init(delegate: HomeBenefitHeaderViewDelegate?) {
        super.init(frame: CGRectZero)
        self.backgroundColor    = UIColor.whiteColor()
        self.delegate           = delegate
        initUI()
    }
    
    func showHeaderData(data : HomeBenefitDetailData) {
        titleLabel.text                 = data.title
        statusLabel.text                = data.bidStatus
        let str : NSString              = "\(data.total / 10000) 万"
        let attri                       = NSMutableAttributedString(string: str as String)
        attri.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: str.rangeOfString("\(data.total / 10000)"))
        rateLabel.attributedText        = attri
        timeLabel.text                  = data.org
        
        processLabel.text               = "已加入\((Double(data.collected) / Double(data.total) * 100).format(".0"))%，剩余金额\((Double(data.total) - Double(data.collected)).formatDecimal(true))元"
        
        if data.collected == data.total {
            progressView.progressTintColor  = UtilTool.colorWithHexString("#53a0e3")
            progressView.progress           = 1
            buyButton.backgroundColor       = UtilTool.colorWithHexString("#53a0e3")
            buyButton.enabled               = false
            buyButton.setTitle("捐款完成", forState: UIControlState.Normal)
        }else{
            progressView.progressTintColor  = UtilTool.colorWithHexString("#f0ad4e")
            progressView.progress           = Float(data.collected) / Float(data.total)
            buyButton.backgroundColor       = UtilTool.colorWithHexString("#f0ad4e")
            buyButton.enabled               = true
            buyButton.setTitle("立即捐款", forState: UIControlState.Normal)
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
        statusLabel.backgroundColor     = UtilTool.colorWithHexString("#53a0e3")
        statusLabel.layer.cornerRadius  = 3
        statusLabel.layer.masksToBounds = true
        
        rateLabel                       = UILabel()
        rateLabel.font                  = UIFont.systemFontOfSize(10)
        rateLabel.textColor             = UtilTool.colorWithHexString("#ff6600")
        rateLabel.textAlignment         = .Center
        rateLabel.contentMode           = .Bottom
        
        timeLabel                       = UILabel()
        timeLabel.font                  = UIFont.systemFontOfSize(14)
        timeLabel.textColor             = UtilTool.colorWithHexString("#666")
        timeLabel.textAlignment         = .Center
        timeLabel.contentMode           = .Bottom
        
        progressView                    = UIProgressView()
        progressView.trackTintColor     = UtilTool.colorWithHexString("#ddd")
        progressView.layer.cornerRadius = 4
        progressView.layer.masksToBounds = true
        progressView.progressTintColor  = UtilTool.colorWithHexString("#f0ad4e")
        progressView.progress           = 0
        
        processLabel                    = UILabel()
        processLabel.font               = UIFont.systemFontOfSize(12)
        processLabel.textColor          = UtilTool.colorWithHexString("#a3a3a3")
        
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
        rateHint.text                   = "项目金额"
        
        let timeHint                    = UILabel()
        timeHint.font                   = UIFont.systemFontOfSize(12)
        timeHint.textColor              = UtilTool.colorWithHexString("#a3a3a3")
        timeHint.textAlignment          = .Center
        timeHint.text                   = "公益机构"
        
        self.addSubview(titleLabel)
        self.addSubview(statusLabel)
        self.addSubview(topLine)
        self.addSubview(rateLabel)
        self.addSubview(timeLabel)
        self.addSubview(rateHint)
        self.addSubview(timeHint)
        self.addSubview(progressView)
        self.addSubview(processLabel)
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
            maker.left.equalTo()(self.mas_centerX)
            maker.top.equalTo()(topLine.mas_bottom).offset()(46)
            maker.height.equalTo()(12)
        }
        
        timeLabel.mas_makeConstraints { (maker) -> Void in
            maker.centerX.equalTo()(timeHint)
            maker.top.equalTo()(topLine.mas_bottom).offset()(16)
            maker.height.equalTo()(18)
        }
        
        
        progressView.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(rateHint)
            maker.right.equalTo()(self).offset()(-24)
            maker.top.equalTo()(rateHint.mas_bottom).offset()(10)
            maker.height.equalTo()(8)
        }
        
        processLabel.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(rateHint)
            maker.top.equalTo()(self.progressView.mas_bottom).offset()(8)
            maker.height.equalTo()(12)
        }
        
        
        buyButton.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.processLabel)
            maker.right.equalTo()(self.progressView)
            maker.bottom.equalTo()(self).offset()(-12)
            maker.height.equalTo()(40)
        }
        
    }
    
    @objc private func buyAction() {
        delegate?.benefitHeaderTouchEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
