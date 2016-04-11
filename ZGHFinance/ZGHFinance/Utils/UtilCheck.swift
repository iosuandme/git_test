//
//  UtilCheck.swift
//  cjxnfs
//
//  Created by wangdong on 15/3/15.
//  Copyright (c) 2015年 wangdong. All rights reserved.
//

private let PWDMIN = 6  //密码最短长度
private let PWDMAX = 20 //密码最长长度
private let MBCODE = 6 //验证码位数

import UIKit

class UtilCheck {
    
    //检测手机号
    //^1[3|4|5|7|8]\d{9}$
    class func checkMobile(mobile: String) -> Bool {
        
        let mobile_length : Int = mobile.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        let mbStr = NSString(string: mobile)
        if mobile_length == 11 {
            
            if mbStr.integerValue != 0 {
                var index : Int = 0
                
                for char in mobile.characters {
                    let subNum : Int! = Int(String(char))
                    if index == 0 && subNum != 1{
                        return false
                    }else if index == 1 {
                        switch subNum {
                        case 0...2:
                            fallthrough
                        case 6:
                            fallthrough
                        case 9:
                            return false
                        default:
                            break
                        }
                    }
                    index += 1
                }
                return true
            }
        }
        return false
    }
    
    //检测密码
    //>6位 不能全数字或字母
    class func checkPasswd(passwd: String) -> Bool {
        //判断字符串中每个字符的ASCII码
        func checkSubChar(subChar : String) -> Bool {
            
            var charASC : Int = 0
            if let asc = getASCIIForChar(subChar) {
                charASC = asc
            }else{
                return true
            }
            
            switch charASC {
            case 97...122:
                fallthrough
            case 65...90:
                return true
            default:
                return false
            }
        }
        
        let passwd_length = passwd.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        
        if passwd_length >= PWDMIN && passwd_length <= PWDMAX {
            
            if let _ = Int(passwd) {
                return false
            }
            
            var count = 0
            for char in passwd.characters {
                let str = String(char)
                if checkSubChar(str) {
                    count += 1
                }
            }
            if count == passwd_length {
                return false
            }
            return true
        }
        return false
    }
    
    //检测手机验证码
    //6位数字
    class func checkMbCode(mobilecode: String) -> Bool {
        
        let code_length = mobilecode.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        
        if code_length == MBCODE {
            if let _ = Int(mobilecode) {
                return true
            }
        }
        return false
    }
    
    //检测正整数
    class func checkNumber(number:String) -> Bool {
        if let num = Int(number) {
            if num <= 0 {
                return false
            }
            let str = String(num)
            if str == number {
                return true
            }
        }
        return false;
    }
    
    
    
    //字符串是否是整形或浮点型
    class func checkNumIsLegal(num : String) -> Bool {
        let emailRegex = "(^\\d*.\\d{1,2}$)|(^\\d*$)"
        return num.isMatch(emailRegex, options: NSRegularExpressionOptions.CaseInsensitive)
    }
    
    //是否登录 true:已登录 false:没有登录
    class func isLogin() -> Bool {
        //let web_qtstr = UtilCookie.getCookieByKey("web_qtstr")
        //return !web_qtstr.isEmpty
        if let _ = Commond.getUserDefaults("userData") as? UCUserData {
            return true
        }else{
            return false
        }
    }
    
    //跳转到登录页面
    /*class func checkLogin(sourceVC: UIViewController , toVC : UIViewController? = nil) {
        if !self.isLogin() {
            let loginVC = LoginViewController()
            loginVC.ctl = sourceVC
            loginVC.toCtl = toVC
            sourceVC.presentViewController(loginVC.navigationController!, animated: true, completion: nil)
        }
    }*/
    
    //获取设备操作系统版本
    class func getDeviceVersion() -> Float {
        return (UIDevice.currentDevice().systemVersion as NSString).floatValue
    }
    
    //获取设备信息
    class func getDeviceInfo(device_id : String) -> Dictionary<String , AnyObject> {
        
        let systemVersion = self.getDeviceVersion()
        let size = UIScreen.mainScreen().bounds.size
        
        var device_type = ""
        switch size {
        case CGSizeMake(320, 480):
            device_type = "iPhone 4"
        case CGSizeMake(320, 568):
            device_type = "iPhone 5"
        case CGSizeMake(375, 667):
            device_type = "iPhone 6"
        case CGSizeMake(414, 736):
            device_type = "iPhone 6 PLUS"
        default:
            device_type = "iPhone other"
        }
        
        let app_version = NSBundle.mainBundle().objectForInfoDictionaryKey(String(kCFBundleVersionKey)) as! String
        
        if device_id == "abc" {
            return ["app_type":2,"device_id":device_id,"model": device_type,"brand":"Apple","os_version":"ios \(systemVersion)","app_version" : app_version]
        }
        return ["app_type":2,"device_id":device_id,"device_version": device_type,"device_brand":"Apple","os_version":"ios \(systemVersion)","app_version" : app_version]
    }
    
    //检测当前是否是开盘时间
    //未开盘 1
    //交易中 2
    //午间休市 3
    //已收盘 4
    class func isDealTime() -> Int {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        let min = components.minute
        if hour >= 9 && hour <= 11 {
            if (hour == 9 && min < 30) || (hour == 11 && min > 30) {
                if hour == 9 && min < 30 {
                    return 1
                }else{
                    return 3
                }
            }
            return 2
        }else if hour >= 13 && hour <= 14 {
            return 2
        }else if hour >= 0 && hour < 9{
            return 1
        }else{
            return 4
        }
    }
    
}
