//
//  FinanceRecordCell.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/11.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//  94

import UIKit

class FinanceRecordCell: UITableViewCell {

    var recordInfo           : FinanceRecordDetailData!
    private var avatarImg    : UIImageView!
    private var nickName     : UILabel!
    private var actionTime   : UILabel!
    private var amountLabel  : UILabel!
    private var investAmount : UILabel!
    private var expectLabel  : UILabel!
    private var expectProfit : UILabel!
    private var sepLine      : UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.whiteColor()
        self.selectionStyle  = UITableViewCellSelectionStyle.None
        
        avatarImg    = UIImageView()
        nickName     = UILabel()
        actionTime   = UILabel()
        amountLabel  = UILabel()
        investAmount = UILabel()
        expectLabel  = UILabel()
        expectProfit = UILabel()
        sepLine      = UILabel()
        
        self.addSubview(avatarImg)
        self.addSubview(nickName)
        self.addSubview(actionTime)
        self.addSubview(amountLabel)
        self.addSubview(investAmount)
        self.addSubview(expectLabel)
        self.addSubview(expectProfit)
        self.addSubview(sepLine)
        
        addAttributes()
        addConstraints()
    }
    
    private func addAttributes() {
        avatarImg.layer.cornerRadius  = 18
        avatarImg.layer.masksToBounds = true
        nickName.font                 = UIFont.systemFontOfSize(12)
        nickName.textColor            = UtilTool.colorWithHexString("#666")
        actionTime.font               = UIFont.systemFontOfSize(10)
        actionTime.textColor          = UtilTool.colorWithHexString("#a3a3a3")
        amountLabel.font              = UIFont.systemFontOfSize(12)
        amountLabel.textColor         = UtilTool.colorWithHexString("#a3a3a3")
        amountLabel.text              = "投标金额"
        investAmount.font             = UIFont.systemFontOfSize(12)
        investAmount.textColor        = UtilTool.colorWithHexString("#666")
        expectLabel.font              = UIFont.systemFontOfSize(12)
        expectLabel.textColor         = UtilTool.colorWithHexString("#a3a3a3")
        expectLabel.text              = "有效金额"
        expectProfit.font             = UIFont.systemFontOfSize(12)
        expectProfit.textColor        = UtilTool.colorWithHexString("#666")
        sepLine.backgroundColor       = UtilTool.colorWithHexString("#efefef")
    }
    
    private func addConstraints() {
        
        avatarImg.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.sepLine.mas_bottom).offset()(15)
            maker.left.equalTo()(self.mas_left).offset()(16)
            maker.width.equalTo()(36)
            maker.height.equalTo()(36)
        }
        
        nickName.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.avatarImg.mas_top).offset()(6)
            maker.left.equalTo()(self.avatarImg.mas_right).offset()(7)
            maker.width.equalTo()(200)
            maker.height.equalTo()(14)
        }
        
        actionTime.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.nickName.mas_bottom).offset()(4)
            maker.left.equalTo()(self.nickName.mas_left)
            maker.width.equalTo()(self.nickName.mas_width)
            maker.height.equalTo()(12)
        }
        
        amountLabel.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.avatarImg.mas_bottom).offset()(12)
            maker.left.equalTo()(self.avatarImg.mas_left)
            maker.width.equalTo()(50)
            maker.height.equalTo()(14)
        }
        
        investAmount.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.amountLabel.mas_top)
            maker.left.equalTo()(self.amountLabel.mas_right).offset()(5)
            maker.width.equalTo()(SCREEN_WIDTH / 2 - 64)
            maker.height.equalTo()(14)
        }
        
        expectLabel.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.investAmount.mas_top)
            maker.left.equalTo()(self.investAmount.mas_right)
            maker.width.equalTo()(self.amountLabel.mas_width)
            maker.height.equalTo()(14)
        }
        
        expectProfit.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self.expectLabel.mas_top)
            maker.left.equalTo()(self.expectLabel.mas_right).offset()(5)
            maker.right.equalTo()(self.mas_right).offset()(-9)
            maker.height.equalTo()(14)
        }
        
        sepLine.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.mas_left)
            maker.right.equalTo()(self.mas_right)
            maker.top.equalTo()(self)
            maker.height.equalTo()(2)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if recordInfo == nil {
            return
        }
        
        avatarImg.image     = UIImage(named: "uc_login_icon.jpg")
        var str             = ""
        if recordInfo.name.length() > 1 {
            str             = (recordInfo.name as NSString).substringToIndex(1) + "****" + (recordInfo.name as NSString).substringFromIndex(recordInfo.name.length() - 1)
        }else{
            str             = (recordInfo.name as NSString).substringToIndex(1) + "*****"
        }
        nickName.text       = str
        let timeStr         = UtilDateTime.formatTime("yyyy-MM-dd HH:mm", time_interval: recordInfo.time / 1000)
        actionTime.text     = "投标时间  " + timeStr
        investAmount.text   = toWanString(recordInfo.amount, isReal: true) + "元"
        expectProfit.text   = toWanString(recordInfo.enableAmount, isReal: true) + "元"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
