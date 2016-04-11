//
//  BottomTabBar.swift
//  cjxnfs
//
//  Created by zhangyr on 15/5/25.
//  Copyright (c) 2015年 cjxnfs. All rights reserved.
//
//  自定义tabBar

import UIKit

private var bottomTabBar : BottomTabBar!

class BottomTabBar: UIView
{
    
    private var lastBtn : BaseButton!
    private var b_center : BaseButton!
    private var cpView : UIView!
    private var peizi : BaseButton!
    private var zc : BaseButton!
    private weak var delegate : UIViewController!
    private var budgeLabel : UILabel!
    private var selectedColor   : UIColor   = UtilTool.colorWithHexString("#53a0e3")
    private var unSelectedColor : UIColor   = UIColor.lightGrayColor()
    
    var budgeNum : Int!
    {
        didSet
        {
            if budgeNum == 0
            {
                budgeLabel.text   = "0"
                budgeLabel.hidden = true
            }else{
                
                if budgeNum == -1 {
                    budgeLabel.frame.size.width  = 8
                    budgeLabel.frame.size.height = 8
                }else
                {
                    if budgeNum > 99 {
                    budgeLabel.text   = "99+"
                    }
                    
                    budgeLabel.text   = "\(budgeNum)"
                    budgeLabel.sizeToFit()
                    budgeLabel.frame.size.width = budgeLabel.frame.size.width + 4
                    if budgeLabel.frame.size.width < budgeLabel.frame.size.height
                    {
                        budgeLabel.frame.size.width = budgeLabel.frame.size.height
                    }
                }
                budgeLabel.layer.cornerRadius   = budgeLabel.frame.size.height / 2
                budgeLabel.layer.masksToBounds  = true
                budgeLabel.hidden               = false
            }
        }
    }
    
    class func shareBottomTabBar(frame : CGRect , delegate : UIViewController!) -> BottomTabBar
    {
        if bottomTabBar == nil
        {
            bottomTabBar = BottomTabBar(frame: frame)
        }
        if delegate != nil
        {
            bottomTabBar.delegate = delegate
        }
        return bottomTabBar
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BottomTabBar.toggleCall(_:)), name: UIApplicationWillChangeStatusBarFrameNotification, object: nil)
        self.backgroundColor        = UIColor.clearColor()
        let btn_W   = frame.size.width / 3
        let btn_H   = frame.size.height - 5
        let btn_bc  = UIView(frame: CGRect(x: -1, y: 5, width: frame.size.width + 2, height: btn_H + 1))
        btn_bc.backgroundColor      = UIColor.clearColor()
        btn_bc.layer.borderColor    = UtilTool.colorWithHexString("#eee").CGColor
        btn_bc.layer.borderWidth    = 1
        let b_home                  = ButtonForTab(frame: CGRect(x: 0, y: 0, width: btn_W, height: btn_H), image: "main_tab_icon", title: "首页", toView: btn_bc, controller: self)
        b_home.backgroundColor      = UIColor.whiteColor()
        b_home.tag                  = 0
        b_home.imageView?.tintColor = UtilTool.colorWithHexString("#53a0e3")
        b_home.setImage(UIImage(named: "main_tab_icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        b_home.setTitleColor(selectedColor, forState: UIControlState.Normal)
        lastBtn                     = b_home
        
        let b_stock                 = ButtonForTab(frame: CGRect(x: b_home.frame.maxX, y: 0, width: btn_W, height: btn_H), image: "financing_tab_icon", title: "理财", toView: btn_bc, controller: self)
        b_stock.setTitleColor(unSelectedColor, forState: UIControlState.Normal)
        b_stock.backgroundColor = UIColor.whiteColor()
        b_stock.tag = 1
        budgeLabel  = UILabel(frame: CGRect(x: b_stock.center.x + 5, y: b_stock.frame.minY + 8, width: 8, height: 8))
        budgeLabel.backgroundColor = UtilTool.colorWithHexString("#e4007f")
        budgeLabel.font            = UIFont.systemFontOfSize(7)
        budgeLabel.textColor       = UIColor.whiteColor()
        budgeLabel.textAlignment   = NSTextAlignment.Center
        budgeLabel.hidden          = true
        btn_bc.addSubview(budgeLabel)
        
        let b_info = ButtonForTab(frame: CGRect(x: b_stock.frame.maxX, y: 0, width: btn_W, height: btn_H), image: "uc_tab_icon", title: "我的", toView: btn_bc, controller: self)
        b_info.setTitleColor(unSelectedColor, forState: UIControlState.Normal)
        b_info.backgroundColor = UIColor.whiteColor()
        b_info.tag = 2

        self.addSubview(btn_bc)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleCall(noti : NSNotification)
    {
        let userInfo = NSDictionary(dictionary: noti.userInfo!)
        let statusBarRect = (userInfo[UIApplicationStatusBarFrameUserInfoKey] as! NSValue).CGRectValue()
        let statusBarHeight = statusBarRect.size.height
        if statusBarHeight < 40 {
            UIView.animateWithDuration(0.25, delay: 0.0138, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.frame.origin.y += 20
                }, completion: nil)
        }else{
            UIView.animateWithDuration(0.25, delay: 0.04, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.frame.origin.y -= 20
                }, completion: nil)
        }
        
    }
    
    
    func clickButton(btn : BaseButton)
    {
        
        let dic     = ["0" : "main", "1" : "financing", "2" : "uc"]
        let currentImage    = String(format: "%@_tab_icon", arguments: [dic["\(btn.tag)"]!])
        if lastBtn != nil
        {
            let lastImage       = String(format: "%@_tab_icon", arguments: [dic["\(lastBtn.tag)"]!])
            lastBtn.setImage(UIImage(named: lastImage), forState: UIControlState.Normal)
            lastBtn.setTitleColor(unSelectedColor, forState: UIControlState.Normal)
        }
        btn.imageView?.tintColor = UtilTool.colorWithHexString("#53a0e3")
        btn.setImage(UIImage(named: currentImage)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        btn.setTitleColor(selectedColor, forState: UIControlState.Normal)
        lastBtn = btn
        UtilTool.getAppDelegate().window?.rootViewController = UtilTool.getAppDelegate().tabBarStack[btn.tag] as? UIViewController
    }
    
    func cpClick(btn : BaseButton) {
        self.b_center.tag = 1
        self.cpView.removeFromSuperview()
        //println("点击\(btn.tag)")
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
//        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        if !CGRectContainsPoint(self.bounds, point) {
            for subview in self.subviews {
                let rect = subview.frame
                if CGRectContainsPoint(rect, point) {
                    //println(subview)
                    let v = subview 
                    let p = convertPoint(point, toView: v)
                    return v.hitTest(p, withEvent: event)
                }
            }
        }
        
        return super.hitTest(point, withEvent: event)
        
    }

}
