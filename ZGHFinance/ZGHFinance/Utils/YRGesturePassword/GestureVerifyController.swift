//
//  GestureVerifyController.swift
//  YRGesturePasswordView
//
//  Created by zhangyr on 16/1/13.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//
//  手势密码控制器，唯一对外接口

import UIKit

class GestureVerifyController: BaseViewController , GesturePasswordViewDelegate {
    
    ///用户账号
    var userKey : String                = ""
    ///验证类型 设置.Set  修改.Change  验证.Verify 关闭.Close
    var style   : GestureVerifyStyle    = .Set
    
    /**
     判断当前账号下的手势密码是否存在
     - parameter 参数及回调: key:账号字段 block回调:回调参数返回是否存在
     - returns:无
    */
    class func isExistPasswordByKey(key : String , block : ((Bool) -> Void)) {
        guard let _ = GestureKeychain.getValueForKey(key) else {
            block(false)
            return
        }
        block(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.edgesForExtendedLayout = .None
        switch style {
        case .Set :
            self.title              = "设置手势密码"
        case .Change :
            self.title              = "修改手势密码"
        case .Close :
            self.title              = "关闭手势密码"
        default :
            break
        }

        self.view.backgroundColor   = UIColor.blackColor()
        let passView                = GesturePasswordView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.frame.size.height), delegate: self, style : style)
        passView.userKey            = userKey
        self.view.addSubview(passView)
    }
    
    /*private func unLogin()
    {
        let login : UCLoginViewController    = UCLoginViewController()
        login.callBack =
            {(parm) -> Void in
                
                if parm is String && (parm as! String) == "register"
                {
                    UtilTool.noticError(view: self.view, msg: REG_SUCC_TEXT,time: 3)
                }
                
        }
        let controller            = UtilTool.getCurrentController()
        if controller is UINavigationController {
            controller.presentViewController(UtilTool.getAppDelegate().navi, animated: true, completion: nil)
        }else{
            controller.navigationController?.presentViewController(UtilTool.getAppDelegate().navi, animated: true, completion: nil)
        }
    }*/
    
    func gesturePasswordCanceled(passView: GesturePasswordView) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //TODO: 取消手势密码事件回调
    }
    
    func gesturePasswordForgot(passView: GesturePasswordView) {
        if style == .Verify {
            self.dismissViewControllerAnimated(true) { () -> Void in
                //TODO: 忘记手势密码事件回调
                UtilCookie.logout()
                //self.unLogin()
            }
        }else{
            self.navigationController?.popToRootViewControllerAnimated(true)
            UtilCookie.logout()
            //self.unLogin()
        }
    }

    func gesturePasswordChangeResult(passView: GesturePasswordView) -> Bool {
        self.navigationController?.popViewControllerAnimated(true)
        //TODO:修改手势密码成功回调
        return true
    }
    
    func gesturePasswordVerifyResult(passView: GesturePasswordView) -> Bool {
        if style == .Verify {
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
        //TODO:验证手势密码成功回调
        return true
    }
    
    func gesturePasswordSetResult(passView: GesturePasswordView) -> Bool {
        self.navigationController?.popViewControllerAnimated(true)
        //TODO:设置手势密码成功回调
        return true
    }
    

}
