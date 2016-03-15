//
//  BaseNaviBar.swift
//  GaodiLicai
//
//  Created by zhangyr on 15/12/1.
//  Copyright © 2015年 cjxnfs. All rights reserved.
//

import UIKit

class NaviButtonInfo    : NSObject
{
    var image   : String?
    var action  : Selector?
}

protocol NavibarTouchDelegate   : NSObjectProtocol
{
    func navibarTouchBegan()
}

class BaseNaviBar: BaseView
{
    let leftBtnWidth    : CGFloat   = 44
    let leftBtnHeiht    : CGFloat   = 44
    let leftBtnMagging  : CGFloat   = 5
    let rightBtnWidth   : CGFloat   = 44
    let rightBtnHeight  : CGFloat   = 44
    let rightBtnMagging : CGFloat   = 5
    let maggingToParent : CGFloat   = 10

    weak var delegate   : AnyObject?
    weak var touchDelegate  : NavibarTouchDelegate?

    override init(frame: CGRect)
    {
        super.init(frame: CGRectZero)
    }
    
    
    convenience init(leftButton : String?, leftAction : Selector, rightButton : String?,rightAction : Selector, titleText : String?, delegate : AnyObject?)
    {
        self.init(frame: CGRectZero)
        var leftBtns    : Array<NaviButtonInfo>?
        if leftButton == nil || leftButton!.length() == 0
        {
            leftBtns    = nil
        }else
        {
            let btnInfo         = NaviButtonInfo()
            btnInfo.image       = leftButton!
            btnInfo.action      = leftAction
            leftBtns            = [btnInfo]
        }
        
        var rightBtns    : Array<NaviButtonInfo>?
        if rightButton == nil || rightButton!.length() == 0
        {
            rightBtns    = nil
        }else
        {
            let btnInfo         = NaviButtonInfo()
            btnInfo.image       = rightButton!
            btnInfo.action      = rightAction
            rightBtns           = [btnInfo]
        }
        
        self.initUI(leftBtns, rightBtns: rightBtns, titleText: titleText, titleView: nil, delegate: delegate)
    }
    
    
    convenience init(leftButton : String?, leftAction : Selector, rightButton : String?,rightAction : Selector, titleView : BaseView?, delegate : AnyObject?)
    {
        self.init(frame: CGRectZero)
        var leftBtns    : Array<NaviButtonInfo>?
        if leftButton == nil || leftButton!.length() == 0
        {
            leftBtns    = nil
        }else
        {
            let btnInfo         = NaviButtonInfo()
            btnInfo.image       = leftButton!
            btnInfo.action      = leftAction
            leftBtns            = [btnInfo]
        }
        
        var rightBtns    : Array<NaviButtonInfo>?
        if rightButton == nil || rightButton!.length() == 0
        {
            rightBtns    = nil
        }else
        {
            let btnInfo         = NaviButtonInfo()
            btnInfo.image       = rightButton!
            btnInfo.action      = rightAction
            rightBtns           = [btnInfo]
        }
        
        self.initUI(leftBtns, rightBtns: rightBtns, titleText: nil, titleView: titleView, delegate: delegate)
    }

    
    convenience init(leftBtns : Array<NaviButtonInfo>, rightBtns : Array<NaviButtonInfo>, titleText : String, delegate : AnyObject?)
    {
        self.init(frame: CGRectZero)
        self.initUI(leftBtns, rightBtns: rightBtns, titleText: titleText, titleView: nil, delegate: delegate)
        
    }
    
    convenience init(leftBtns : Array<NaviButtonInfo>, rightBtns : Array<NaviButtonInfo>, titleView : BaseView, delegate : AnyObject?)
    {
        self.init(frame: CGRectZero)
        self.initUI(leftBtns, rightBtns: rightBtns, titleText: nil, titleView: titleView,delegate: delegate)
    }
    
    convenience init(customView : BaseView)
    {
        self.init(frame: CGRectZero)
        self.addSubview(customView)
        customView.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self)
            maker.bottom.equalTo()(self)
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initUI(leftBtns : Array<NaviButtonInfo>?, rightBtns : Array<NaviButtonInfo>?, titleText : String?, titleView : BaseView?, delegate : AnyObject?)
    {
        self.delegate       = delegate
        if leftBtns != nil && leftBtns!.count > 0
        {
            leftButtons = Array<BaseButton>()
            
            for i : Int in 0 ... leftBtns!.count - 1
            {
                let leftBtn         = leftBtns![i]
                let leftImage       = leftBtn.image
                let btn             = BaseButton()
                btn.setImage(UIImage(named: leftImage!), forState: UIControlState.Normal)
                btn.addTarget(self.delegate, action: leftBtn.action!, forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(btn)
                
                btn.mas_makeConstraints({ (maker) -> Void in
                    maker.left.equalTo()(self).offset()(self.maggingToParent + CGFloat(i) * (self.leftBtnWidth + self.leftBtnMagging))
                    maker.width.equalTo()(self.leftBtnWidth)
                    maker.centerY.equalTo()(self)
                    maker.height.equalTo()(self.leftBtnHeiht)
                })
            }
        }
        
        if rightBtns != nil && rightBtns!.count > 0
        {
            rightButtons = Array<BaseButton>()
            
            for i : Int in 0 ... rightBtns!.count - 1
            {
                let rightBtn        = rightBtns![i]
                let rightImage      = rightBtn.image
                let btn             = BaseButton()
                btn.setImage(UIImage(named: rightImage!), forState: UIControlState.Normal)
                btn.addTarget(self.delegate, action: rightBtn.action!, forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(btn)
                
                btn.mas_makeConstraints({ (maker) -> Void in
                    maker.right.equalTo()(self).offset()(CGFloat(rightBtns!.count - 1 - i) * (self.rightBtnWidth + self.rightBtnMagging) + self.maggingToParent)
                    maker.width.equalTo()(self.rightBtnWidth)
                    maker.centerY.equalTo()(self)
                    maker.height.equalTo()(self.rightBtnHeight)
                })
            }
        }
        
        if titleText == nil || titleText!.length() == 0
        {
            
        }else
        {
            titleLabel  = UILabel()
            self.addSubview(titleLabel)
            titleLabel.mas_makeConstraints({ (maker) -> Void in
                maker.top.equalTo()(self)
                maker.bottom.equalTo()(self)
                maker.left.equalTo()(self)
                maker.right.equalTo()(self)
            })
        }
        
        if titleView == nil
        {
            
        }else
        {
            self.addSubview(titleView!)
            titleView!.mas_makeConstraints({ (maker) -> Void in
                maker.top.equalTo()(self)
                maker.bottom.equalTo()(self)
                if leftBtns != nil && leftBtns!.count > 0
                {
                    maker.left.equalTo()(self.maggingToParent + CGFloat(leftBtns!.count) * (self.leftBtnWidth + self.leftBtnMagging))
                }else
                {
                    maker.left.equalTo()(self)
                }
                
                if rightBtns != nil && rightBtns!.count > 0
                {
                    maker.right.equalTo()(self.maggingToParent + CGFloat(rightBtns!.count) * (self.rightBtnWidth + self.rightBtnMagging))
                }else
                {
                    maker.right.equalTo()(self)
                }
                
            })
        }
    }
    
    
    
    deinit
    {
        self.leftButtons?.removeAll(keepCapacity: false)
        self.rightButtons?.removeAll(keepCapacity: false)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.touchDelegate?.navibarTouchBegan()
    }
    

    private var bgImageView     : UIImageView!
    private var titleLabel      : UILabel!
    private var leftButtons     : Array<BaseButton>?
    private var rightButtons    : Array<BaseButton>?
}
