//
//  HomeInvestCell.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/8.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//  68

import UIKit

class HomeInvestCell: UITableViewCell {
    
    var projectData         : HomeProjectData! {
        didSet {
            if projectData != nil {
                showData()
            }
        }
    }
    private var titleLabel  : UILabel!
    private var sellLabel   : UILabel!
    private var perLabel    : UILabel!
    private var timeLabel   : UILabel!
    private var statusLabel : UILabel!
    private var sepLine     : UIView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor    = UIColor.whiteColor()
        self.selectionStyle     = .None
        initUI()
    }
    
    private func initUI() {
        
        titleLabel                      = UILabel()
        titleLabel.font                 = UIFont.systemFontOfSize(12)
        titleLabel.textColor            = UtilTool.colorWithHexString("#666")
        
        sellLabel                       = UILabel()
        sellLabel.font                  = UIFont.systemFontOfSize(10)
        sellLabel.textColor             = UtilTool.colorWithHexString("#a3a3a3")
        sellLabel.textAlignment         = .Right
        
        perLabel                        = UILabel()
        perLabel.font                   = UIFont.systemFontOfSize(10)
        perLabel.textColor              = UtilTool.colorWithHexString("#ff6600")
        perLabel.contentMode            = .Bottom
        
        timeLabel                       = UILabel()
        timeLabel.font                  = UIFont.systemFontOfSize(10)
        timeLabel.textColor             = UtilTool.colorWithHexString("#a3a3a3")
        timeLabel.textAlignment         = .Center
        timeLabel.contentMode           = .Bottom
        
        statusLabel                     = UILabel()
        statusLabel.font                = UIFont.systemFontOfSize(12)
        statusLabel.textColor           = UIColor.whiteColor()
        statusLabel.textAlignment       = .Center
        statusLabel.layer.cornerRadius  = 4
        statusLabel.layer.masksToBounds = true
        
        sepLine                         = UIView()
        sepLine.backgroundColor         = UtilTool.colorWithHexString("#ddd")
        
        self.addSubview(titleLabel)
        self.addSubview(sellLabel)
        self.addSubview(perLabel)
        self.addSubview(timeLabel)
        self.addSubview(statusLabel)
        self.addSubview(sepLine)
        
        titleLabel.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self).offset()(16)
            maker.top.equalTo()(self).offset()(12)
            maker.height.equalTo()(12)
        }
        
        sellLabel.mas_makeConstraints { (maker) -> Void in
            maker.right.equalTo()(self).offset()(-16)
            maker.centerY.equalTo()(self.titleLabel)
        }
        
        perLabel.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.titleLabel)
            maker.bottom.equalTo()(self).offset()(-12)
            maker.height.equalTo()(18)
        }
        
        timeLabel.mas_makeConstraints { (maker) -> Void in
            maker.centerX.equalTo()(self)
            maker.centerY.equalTo()(self.perLabel)
            maker.height.equalTo()(18)
        }
        
        statusLabel.mas_makeConstraints { (maker) -> Void in
            maker.right.equalTo()(self.sellLabel)
            maker.centerY.equalTo()(self.timeLabel)
            maker.height.equalTo()(24)
            maker.width.equalTo()(60)
        }
        
        sepLine.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
            maker.bottom.equalTo()(self)
            maker.height.equalTo()(1)
        }

    }
    
    private func showData() {
        
        titleLabel.text                 = projectData.title
        if projectData.type == 0 {
            sellLabel.text              = "\(projectData.borrowLimit / 10000)万，" + "已加入\(projectData.process)%"
            var str : NSString          = "\(projectData.rate)%"
            var attri                   = NSMutableAttributedString(string: str as String)
            attri.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: str.rangeOfString(projectData.rate))
            perLabel.textColor          = UtilTool.colorWithHexString("#ff6600")
            perLabel.attributedText     = attri
            str                         = "\(projectData.timePeriod) 个月"
            attri                       = NSMutableAttributedString(string: str as String)
            attri.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(18),NSForegroundColorAttributeName : UtilTool.colorWithHexString("#666")], range: str.rangeOfString(projectData.timePeriod))
            timeLabel.attributedText    = attri
            statusLabel.text            = projectData.status
            statusLabel.backgroundColor = UtilTool.colorWithHexString("#f0ad4e")
        }else{
            sellLabel.text              = "已加入\(projectData.process)%"
            perLabel.text               = projectData.rate
            perLabel.textColor          = UtilTool.colorWithHexString("#a3a3a3")
            let str : NSString          = "筹款\(projectData.timePeriod) 万"
            let attri                   = NSMutableAttributedString(string: str as String)
            attri.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(18),NSForegroundColorAttributeName : UtilTool.colorWithHexString("#666")], range: str.rangeOfString(projectData.timePeriod))
            timeLabel.attributedText    = attri
            statusLabel.text            = projectData.status
            statusLabel.backgroundColor = UtilTool.colorWithHexString("#53a0e3")
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
