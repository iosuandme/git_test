//
//  FinanceDetailCell.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/11.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//  固定 78

import UIKit

class FinanceDetailCell: UITableViewCell {

    var detailData      : FinanceDetailOtherData! {
        didSet {
            if detailData != nil {
                layoutUI()
            }
        }
    }
    
    private func layoutUI() {
        var tv : UIView?        = nil
        for dData in detailData.otherDatas {
            let dCellView       = FinanceDetailCellView(type: dData.type)
            dCellView.topView   = tv
            self.addSubview(dCellView)
            dCellView.data      = dData
            tv                  = dCellView
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle     = .None
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class FinanceDetailCellView : UIView , UIWebViewDelegate {
    
    var data                : FinanceDetailCellData! {
        didSet {
            if data != nil {
                showData()
            }
        }
    }
    
    var benefitData         : HomeBenefitDetailData! {
        didSet {
            if benefitData != nil {
                showData()
            }
        }
    }
    
    weak var topView        : UIView?
    private var titleLabel  : UILabel!
    private var textLabel   : UILabel!
    private var webView     : UIWebView!
    private var type        : FinanceDetailType = .Text
    
    required init(type : FinanceDetailType) {
        super.init(frame: CGRectZero)
        self.type               = type
        self.backgroundColor    = UIColor.whiteColor()
        initUI()
    }
    
    private func initUI() {
        
        let topSep              = UIView()
        topSep.backgroundColor  = UtilTool.colorWithHexString("#e5e5e5")
        
        titleLabel              = UILabel()
        titleLabel.font         = UIFont.systemFontOfSize(12)
        titleLabel.textColor    = UtilTool.colorWithHexString("#666")
        
        let line                = UIView()
        line.backgroundColor    = UtilTool.colorWithHexString("#ddd")
        
        switch type {
        case .Web :
            webView             = UIWebView()
            webView.delegate    = self
            self.addSubview(webView)
        default :
            textLabel               = UILabel()
            textLabel.font          = UIFont.systemFontOfSize(12)
            textLabel.textColor     = UtilTool.colorWithHexString("#666")
            textLabel.contentMode   = .Top
            textLabel.numberOfLines = 0
            self.addSubview(textLabel)
        }
        
        
        self.addSubview(topSep)
        self.addSubview(titleLabel)
        self.addSubview(line)
        
        topSep.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
            maker.top.equalTo()(self)
            maker.height.equalTo()(10)
        }
        
        titleLabel.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self).offset()(16)
            maker.top.equalTo()(topSep.mas_bottom).offset()(12)
            maker.height.equalTo()(12)
        }
        
        line.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self).offset()(16)
            maker.right.equalTo()(self).offset()(-16)
            maker.top.equalTo()(self.titleLabel.mas_bottom).offset()(12)
            maker.height.equalTo()(0.5)
        }
        
        switch type {
        case .Web :
            webView.mas_makeConstraints { (maker) -> Void in
                maker.left.equalTo()(line)
                maker.right.equalTo()(line)
                maker.top.equalTo()(line.mas_bottom).offset()(12)
                maker.height.equalTo()(0)
            }
        default :
            textLabel.mas_makeConstraints { (maker) -> Void in
                maker.left.equalTo()(line)
                maker.right.equalTo()(line)
                maker.top.equalTo()(line.mas_bottom).offset()(12)
            }
        }
        
    }
    
    private func showData() {
        if type == .Web {
            titleLabel.text                 = benefitData.title
            webView.loadHTMLString(benefitData.content, baseURL: nil)
            webView.userInteractionEnabled  = false
            webView.mas_remakeConstraints { (maker) -> Void in
                maker.left.equalTo()(self).offset()(16)
                maker.right.equalTo()(self).offset()(-16)
                maker.top.equalTo()(self.titleLabel.mas_bottom).offset()(24.5)
                maker.height.equalTo()(self.benefitData.contentHeight)
            }
            self.mas_remakeConstraints { (maker) -> Void in
                maker.left.equalTo()(self.superview)
                maker.right.equalTo()(self.superview)
                if self.topView != nil {
                    maker.top.equalTo()(self.topView?.mas_bottom)
                }else{
                    maker.top.equalTo()(self.superview)
                }
                maker.bottom.equalTo()(self.webView).offset()(12)
            }
        }else{
            titleLabel.text             = data.title
            textLabel.attributedText    = data.attributeString
            self.mas_remakeConstraints { (maker) -> Void in
                maker.left.equalTo()(self.superview)
                maker.right.equalTo()(self.superview)
                if self.topView != nil {
                    maker.top.equalTo()(self.topView?.mas_bottom)
                }else{
                    maker.top.equalTo()(self.superview)
                }
                maker.bottom.equalTo()(self.textLabel).offset()(12)
            }
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName('body')[0].style.webkitTextFillColor='#666666'")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
