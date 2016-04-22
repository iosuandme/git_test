//
//  UCBankCardCell.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/21.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//  138

import UIKit

protocol UCBankCardCellDelegate : NSObjectProtocol {
    func bankCardChoosenWithIndex(index : Int)
}

class UCBankCardCell: UITableViewCell {

    weak var delegate           : UCBankCardCellDelegate?
    var index                   : Int   = 0
    var bankCardInfo            : UCBankCardInfo! {
        didSet {
            if bankCardInfo != nil {
                showData()
            }
        }
    }
    private var cardView        : UIView!
    private var bankIcon        : UIImageView!
    private var bankName        : UIButton!
    private var cardNo          : UILabel!
    private var hintLabel       : UILabel!
    private var selectImg       : UIImageView!
    private var selectBtn       : BaseButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle             = .None
        self.backgroundColor            = UtilTool.colorWithHexString("#efefef")
        initUI()
        addConstraints()
    }
    
    private func initUI() {
        
        cardView                        = UIView()
        cardView.backgroundColor        = UIColor.whiteColor()
        cardView.layer.cornerRadius     = 4
        cardView.layer.masksToBounds    = true
        cardView.layer.borderColor      = UtilTool.colorWithHexString("#ddd").CGColor
        cardView.layer.borderWidth      = 1
        
        
        bankName                        = UIButton()
        bankName.imageEdgeInsets        = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        bankName.titleEdgeInsets        = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -4)
        bankName.userInteractionEnabled = false
        bankName.titleLabel?.font       = UIFont.systemFontOfSize(13)
        bankName.setTitleColor(UtilTool.colorWithHexString("#666"), forState: UIControlState.Normal)
        bankName.setImage(UIImage(named: "uc_bankcard"), forState: UIControlState.Normal)
        
        cardNo                          = UILabel()
        cardNo.font                     = UIFont.systemFontOfSize(14)
        cardNo.textColor                = UtilTool.colorWithHexString("#666")
        cardNo.textAlignment            = .Center
        
        hintLabel                       = UILabel()
        hintLabel.font                  = UIFont.systemFontOfSize(12)
        hintLabel.textColor             = UtilTool.colorWithHexString("#a8a8a9")
        hintLabel.textAlignment         = .Center
        
        selectImg                       = UIImageView()
        selectImg.image                 = UIImage(named: "uc_icon_verified")
        selectImg.hidden                = true
        
        selectBtn                       = BaseButton()
        selectBtn.addTarget(self, action: #selector(UCBankCardCell.selectedAction), forControlEvents: UIControlEvents.TouchUpInside)
        
        bankIcon                        = UIImageView()
        bankIcon.backgroundColor        = UIColor.whiteColor()
        
        self.contentView.addSubview(cardView)
        cardView.addSubview(bankName)
        cardView.addSubview(cardNo)
        cardView.addSubview(hintLabel)
        cardView.addSubview(selectImg)
        cardView.addSubview(selectBtn)
        bankName.addSubview(bankIcon)
    }
    
    private func addConstraints() {
        
        cardView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.cardView.superview).offset()(32)
            maker.right.equalTo()(self.cardView.superview).offset()(-32)
            maker.top.equalTo()(self.cardView.superview).offset()(15)
            maker.bottom.equalTo()(self.cardView.superview).offset()(-15)
        }
        
        bankName.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.cardView)
            maker.right.equalTo()(self.cardView)
            maker.top.equalTo()(self.cardView)
            maker.height.equalTo()(40)
        }
        
        cardNo.mas_makeConstraints { (maker) in
            maker.top.equalTo()(self.bankName.mas_bottom).offset()(10)
            maker.centerX.equalTo()(self.bankName)
            maker.height.equalTo()(14)
        }
        
        hintLabel.mas_makeConstraints { (maker) in
            maker.top.equalTo()(self.cardNo.mas_bottom).offset()(20)
            maker.centerX.equalTo()(self.bankName)
            maker.height.equalTo()(12)
        }
        
        selectImg.mas_makeConstraints { (maker) in
            maker.top.equalTo()(self.cardView).offset()(10)
            maker.right.equalTo()(self.cardView).offset()(-10)
            maker.width.equalTo()(25)
            maker.height.equalTo()(25)
        }
        
        selectBtn.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.cardView)
            maker.right.equalTo()(self.cardView)
            maker.top.equalTo()(self.cardView)
            maker.bottom.equalTo()(self.cardView)
        }
        
        bankIcon.mas_makeConstraints { (maker) in
            maker.centerY.equalTo()(self.bankName.imageView)
            maker.right.equalTo()(self.bankName.imageView)
            maker.width.equalTo()(24)
            maker.height.equalTo()(24)
        }
        
    }
    
    @objc private func selectedAction() {
        delegate?.bankCardChoosenWithIndex(index)
    }
    
    private func showData() {
        
        bankIcon.image                  = UIImage(named: UtilTool.getBankName(bankCardInfo.cardName, keyForValue: false))
        bankName.imageView?.frame.size  = CGSizeMake(20, 20)
        bankName.setTitle(bankCardInfo.cardName, forState: UIControlState.Normal)
        cardNo.text                     = UtilTool.bankCardFormat(bankCardInfo.cardNo)
        hintLabel.text                  = bankCardInfo.desc
        selectImg.hidden                = !bankCardInfo.isSelected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
