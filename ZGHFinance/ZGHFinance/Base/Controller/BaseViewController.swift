//
//  BaseViewController.swift
//  GaodiLicai
//
//  Created by zhangyr on 15/12/2.
//  Copyright © 2015年 cjxnfs. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if needKeyBoardObserver() {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardWillHideNotification, object: nil)
        }
        
        self.initData()
        self.initUI()
        if self.needRefrshData()
        {
            self.refreshData()
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        if self.needTabbar()
        {
            UtilTool.addTabBarToController(self)
        }
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        if self.canSlideToLast()
        {
            if self.navigationController != nil && self.navigationController!.respondsToSelector(Selector("interactivePopGestureRecognizer"))
            {
                self.navigationController!.interactivePopGestureRecognizer?.enabled   = true
            }
            
        }else
        {
            if self.navigationController != nil && self.navigationController!.respondsToSelector(Selector("interactivePopGestureRecognizer"))
            {
                self.navigationController!.interactivePopGestureRecognizer?.enabled   = false
            }
            
        }
        
        if self.navigationController != nil && self.navigationController!.respondsToSelector(Selector("interactivePopGestureRecognizer"))
        {
            if self.navigationController!.viewControllers.count >= 2
            {
                self.navigationController!.interactivePopGestureRecognizer!.delegate = self
            }else
            {
                self.navigationController!.interactivePopGestureRecognizer?.delegate    = nil
                self.navigationController?.interactivePopGestureRecognizer?.enabled     = false
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        if self.navigationController != nil && self.navigationController!.respondsToSelector(Selector("interactivePopGestureRecognizer"))
        {
            self.navigationController?.interactivePopGestureRecognizer?.delegate    = nil
        }
    }
    
    /**
     
     初始化数据
     
     - returns:
     */
    func initData()
    {
        
    }
    
    /**
     初始化界面
     
     - returns:
     */
    func initUI()
    {
        
        self.view.backgroundColor   = UtilTool.colorWithHexString("#e5e5e5")
        if self.needBgImageView()
        {
        }
        
        if self.needSetBackIcon()
        {
            self.setBackIcon()
        }
    }
    
    
    /**
     获取数据，刷新界面
     */
    func refreshData()
    {
        
    }
    
    /**
     是否需要在初始化界面后，马上刷新
     
     - returns: 刷或不刷
     */
    func needRefrshData() -> Bool
    {
        return true
    }
    
    func needKeyBoardObserver() -> Bool
    {
        return false
    }
    
    func needTabbar()   -> Bool
    {
        return false
    }
    
    func canSlideToLast() -> Bool
    {
        return true
    }
    func needSetBackIcon()  -> Bool
    {
        return true
    }
    
    func needBgImageView()  -> Bool
    {
        return true
    }

    
    func observerOptions() -> (transView : UIView? , compareView : UIView?) {
        return (nil , nil)
    }
    
    func setBackIcon()
    {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 18))
        btn.setImage(UIImage(named: "navi_backBar"), forState: UIControlState.Normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 3, left: -30, bottom: 0, right: 0)
        btn.addTarget(self, action: "popAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem  = UIBarButtonItem(customView: btn)
    }
    
    func popAction()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func keyboardDidShow(noti : NSNotification) {
        keyboardWillShowHide(noti, dismiss: false)
    }
    
    func keyboardDidHide(noti : NSNotification) {
        keyboardWillShowHide(noti, dismiss: true)
    }
    
    private func keyboardWillShowHide(notification : NSNotification , dismiss : Bool)
    {
        let optionViews      = observerOptions()
        if let userInfo = notification.userInfo {
            let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            let curve        = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue
            var options  : UIViewAnimationOptions = .CurveEaseInOut
            switch curve {
            case 0 :
                options = .CurveEaseInOut
            case 1:
                options = .CurveEaseIn
            case 2:
                options = .CurveEaseOut
            case 3 :
                options = .CurveLinear
            default :
                break
            }
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            if dismiss {
                UIView.animateWithDuration(duration, delay: 0, options: options, animations: { () -> Void in
                    optionViews.transView?.transform = CGAffineTransformIdentity
                    }, completion: nil)
            }else{
                if optionViews.compareView != nil {
                    var space   = optionViews.transView!.bounds.height - optionViews.compareView!.frame.maxY - keyboardRect.height
                    if space < 0 {
                        if IOS_7 {
                            space  -= 120
                        }
                        UIView.animateWithDuration(duration, delay: 0, options: options, animations: { () -> Void in
                            optionViews.transView?.transform = CGAffineTransformMakeTranslation(0, space)
                            }, completion: nil)
                    }
                }
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationController!.viewControllers.count > 1
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private var bgView  : UIImageView!
}
