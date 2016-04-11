//
//  ButtonForTab.swift
//  cjxnfs
//
//  Created by zhangyr on 15/5/25.
//  Copyright (c) 2015年 cjxnfs. All rights reserved.
//
//  自定义tabBar中的按钮组合
//

import UIKit

class ButtonForTab: BaseButton
{
    var titleFont : CGFloat   = 10
    {
        didSet
        {
            if titleFont != oldValue
            {
                self.updateConstraints()
            }
        }
    }
    
    var marginHeight : CGFloat  = 4
    {
        didSet
        {
            if oldValue != marginHeight
            {
                self.updateConstraints()
            }
        }
    }
    
    var marginTop : CGFloat     = 10
    {
        didSet
        {
            if oldValue != marginTop
            {
                self.updateConstraints()
            }
        }
    }
    
    init(frame: CGRect ,image : String , title : String ,toView : UIView ,controller : NSObject, isRevearse : Bool = false)
    {
        super.init(frame: frame)
        self.mImage     = UIImage(named: image)
        self.setImage(self.mImage, forState: UIControlState.Normal)
        self.setTitle(title, forState: UIControlState.Normal)
        self.titleLabel?.font   = UIFont.systemFontOfSize(10)
        self.addTarget(controller, action: #selector(BottomTabBar.clickButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //let tapGesture = UITapGestureRecognizer(target: controller, action: "doubleClick:")
        //tapGesture.numberOfTapsRequired = 2
        //self.addGestureRecognizer(tapGesture)
        self.mIsRevearse         = isRevearse
        self.adjustsImageWhenHighlighted = false
        toView.addSubview(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.titleLabel?.font   = UIFont.systemFontOfSize(titleFont)
        
        if mIsRevearse
        {
            //Center text
            var newFrame : CGRect   = self.titleLabel!.frame
            newFrame.origin.x       = 0;
            newFrame.origin.y       = self.marginTop;
            newFrame.size.width     = self.frame.size.width;
            newFrame.size.height    = titleFont
            
            self.titleLabel!.frame  = newFrame;
            self.titleLabel!.textAlignment = NSTextAlignment.Center;
            
            // Center image
            var center : CGPoint    = self.imageView!.center;
            center.x                = self.frame.size.width / 2;
            center.y                = self.marginTop + self.titleLabel!.frame.height + self.marginHeight + self.imageView!.frame.size.height / 2;
            self.imageView!.center  = center;
            
        }else
        {
            
            if self.imageView != nil && self.titleLabel != nil
            {
                // Center image
                var center : CGPoint    = self.imageView!.center;
                center.x                = self.frame.size.width / 2;
                center.y                = self.imageView!.frame.size.height / 2 + self.marginTop;
                self.imageView!.center  = center;
                
                //Center text
                var newFrame : CGRect   = self.titleLabel!.frame
                newFrame.origin.x       = 0;
                newFrame.origin.y       = self.imageView!.frame.size.height + self.marginTop + self.marginHeight;
                newFrame.size.width     = self.frame.size.width;
                
                self.titleLabel!.frame  = newFrame;
                self.titleLabel!.textAlignment = NSTextAlignment.Center;
            }
        }
    }
    
    private var mImage          : UIImage?
    private var mIsRevearse     : Bool      = false
}
