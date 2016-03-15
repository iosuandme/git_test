//
//  ToastView.swift
//  cjxnfs
//
//  Created by zhangyr on 15/8/2.
//  Copyright (c) 2015年 cjxnfs. All rights reserved.
//

import UIKit

let REQ_CANCEL                  = Selector("requestCanceled")

class ToastView: UIView
{
    private var bgView          : UIImageView!
    private var messageLabel    : UILabel!
    private var cancelBtn       : UIButton!
    private var waitingView     : UIImageView!
    private var iconView        : UIImageView!
//    private var split           : UIImageView!
    
    private static var toasts   : Dictionary<UIView, ToastView> = Dictionary<UIView, ToastView>()
    
    convenience init()
    {
        self.init(frame: CGRectZero)
        self.initUI()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
    }
    

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideBgView() {
        bgView.alpha                    = 0
    }
    
    func showBgView() {
        UIView.animateWithDuration(0.1) { () -> Void in
            self.bgView.alpha                = 1
        }
    }

    
    func initUI()
    {
        bgView                          = UIImageView()
        messageLabel                    = UILabel()
        messageLabel.font               = UIFont.systemFontOfSize(10)
        messageLabel.textAlignment      = NSTextAlignment.Center
        cancelBtn                       = UIButton()
        waitingView                     = UIImageView()
        iconView                        = UIImageView()
//        split                           = UIImageView()
        
        self.addSubview(bgView)
        
        bgView.addSubview(messageLabel)
        bgView.addSubview(cancelBtn)
        bgView.addSubview(waitingView)
        bgView.addSubview(iconView)
//        bgView.addSubview(split)
        let image                       = UIImage(named: "main_image_toast_bg")
        let insets                      = UIEdgeInsetsMake(8, 8, 8, 8)
        let imge                        = image?.resizableImageWithCapInsets(insets, resizingMode: UIImageResizingMode.Stretch)
        bgView.image                    = imge
        waitingView.image               = UIImage(named: "main_image_toast_progress")
        iconView.image                  = UIImage(named: "main_image_toast_logo")
        cancelBtn.setImage(UIImage(named: "main_image_toast_cancel"), forState: UIControlState.Normal)
        
        weak var weakSelf               = self
        
        bgView.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(weakSelf)
            maker.right.equalTo()(weakSelf)
            maker.top.equalTo()(weakSelf)
            maker.bottom.equalTo()(weakSelf)
        }
        
        iconView.mas_makeConstraints { (maker) -> Void in
            maker.centerX.equalTo()(weakSelf)
            maker.top.equalTo()(weakSelf).offset()(28)
        }
        
        waitingView.mas_makeConstraints { (maker) -> Void in
            maker.centerX.equalTo()(weakSelf)
            maker.centerY.equalTo()(weakSelf?.iconView)
        }
        
        messageLabel.mas_makeConstraints { (maker) -> Void in
            maker.width.equalTo()(weakSelf)
            maker.centerX.equalTo()(weakSelf)
            maker.height.equalTo()(11)
            maker.bottom.equalTo()(weakSelf).offset()(-20)
        }
        
//        cancelBtn.mas_makeConstraints { (maker) -> Void in
//            maker.right.equalTo()(weakSelf).offset()(-27)
//            maker.centerY.equalTo()(weakSelf)
//            maker.width.equalTo()(20)
//            maker.height.equalTo()(20)
//        }
//        
        self.userInteractionEnabled     = true
    }
    
    class func showMessage(msg : String, withParentView : UIView? = nil, withWaiting : Bool = true, andCancel : Bool = true, withDuration : Double = 0, withTarget : AnyObject?, andAction : Selector?) -> ToastView?
    {
        var toast       : ToastView?            = nil
        var lastVC      : UIViewController?
        
        let controller  = UtilTool.getAppDelegate().window!.rootViewController!
        
        lastVC      = controller.childViewControllers.last
        
        var parentView  : UIView?
        if withParentView != nil
        {
            parentView                          = withParentView!
        }else
        {
            if lastVC != nil && lastVC!.presentedViewController != nil
            {
                if lastVC!.presentedViewController is UINavigationController
                {
                    if (lastVC!.presentedViewController as? UINavigationController)!.childViewControllers.count > 0
                    {
                        parentView                  = (lastVC!.presentedViewController as! UINavigationController).childViewControllers.last!.view
                    }else
                    {
                        parentView                  = lastVC!.view
                    }
                }else
                {
                    parentView                      = lastVC!.view
                }
                
            }else
            {
                parentView                          = lastVC == nil ? nil : lastVC!.view
            }
        }
        
        
        if parentView != nil 
        {
            parentView!.userInteractionEnabled      = false
            let subviews                = parentView!.subviews
            for view : AnyObject  in subviews
            {
                if view is ToastView
                {
                    toast               = view as? ToastView
                    break
                }
            }
            
            if toast != nil
            {
                if !toast!.hidden //正在显示
                {
                    return toast
                }else
                {
                    toast!.hidden   = false
                }
            }else
            {
                let screenHeight        = UIScreen.mainScreen().bounds.height
                let screenWidth         = UIScreen.mainScreen().bounds.width
                toast                   = ToastView()
                toast!.tag              = 123456
                parentView!.addSubview(toast!)
                weak var weakParent     = parentView!
                
                if IOS_7 && weakParent is UITableView
                {
                    toast!.frame        = CGRectMake((screenWidth - 81)/2, (screenHeight - 68) / 2 - 64, 90, 90)
                }else
                {
                    toast!.mas_makeConstraints({ (maker) -> Void in
                        maker.centerX.equalTo()(weakParent)
                        maker.centerY.equalTo()(weakParent).centerOffset()(CGPointMake(0, -32))
                        //                    maker.width.equalTo()(192)
                        maker.width.equalTo()(90)
                        maker.height.equalTo()(90)
                    })
                }
                
            }
            
            toast?.showMessage(msg, withWaiting: withWaiting, andCancel: andCancel, withDuration: withDuration, withTarget: withTarget, andAction: andAction)
        }
        
        if !(parentView! is UIWebView)
        {
            toasts[parentView!]     = toast
        }
        
        return toast
    }
    
    
    func showMessage(msg : String, withWaiting : Bool = true, andCancel : Bool = true, withDuration : Double = 0, withTarget : AnyObject?, andAction : Selector?)
    {
        self.hidden                     = false
        self.superview?.bringSubviewToFront(self)
        messageLabel.textColor          = UIColor.blackColor()
        messageLabel.font               = UIFont.systemFontOfSize(12)
        messageLabel.text               = msg
        messageLabel.textAlignment      = NSTextAlignment.Center
        waitingView.hidden              = !withWaiting
        cancelBtn.hidden                = !andCancel
//        split.hidden                    = !andCancel
        
        if withWaiting
        {
            self.showRotateCircle()
        }
     
        if withTarget == nil
        {
            self.cancelBtn.addTarget(self, action: Selector("onDurationArrived"), forControlEvents: UIControlEvents.TouchUpInside)
        }else
        {
            if andAction == nil
            {
                self.cancelBtn.addTarget(self, action: Selector("onDurationArrived"), forControlEvents: UIControlEvents.TouchUpInside)
            }else
            {
                self.cancelBtn.addTarget(withTarget, action: andAction!, forControlEvents: UIControlEvents.TouchUpInside)
            }
            
        }
        
        if Int(withDuration) != 0
        {
            NSTimer.scheduledTimerWithTimeInterval(withDuration, target: self, selector: Selector("onDurationArrived"), userInfo: nil, repeats: false)
        }
    }
    
    class func dismissAllToasts()
    {
        for (_, value) in ToastView.toasts
        {
            value.onDurationArrived()
        }
    }
    
    func dismiss()
    {
        self.onDurationArrived()
    }
    
    
    private func onDurationArrived()
    {
        self.superview?.userInteractionEnabled  = true
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.removeFromSuperview()
        }
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.transform  = CGAffineTransformMakeScale(0.8, 0.8)
            self.alpha      = 0
            }) { (Bool) -> Void in
                self.stopRotateCircle()
        }
//        BaseRequest.cancelAll()
    }
    
    private func showRotateCircle()
    {
        let fullRotation : CABasicAnimation     = CABasicAnimation(keyPath: "transform.rotation")
        fullRotation.fromValue                  = NSNumber(double: 0)
        fullRotation.toValue                    = NSNumber(double: 2 * M_PI)
        fullRotation.duration                   = 1
        fullRotation.repeatCount                = MAXFLOAT
        waitingView.layer.addAnimation(fullRotation, forKey: "move-layer")
    }
    
    private func stopRotateCircle()
    {
        waitingView.layer.removeAllAnimations()
    }
    
    
}
