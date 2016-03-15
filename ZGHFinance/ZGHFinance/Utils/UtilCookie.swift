//
//  UtilCookie.swift
//  cjxnfs
//
//  Created by wangdong on 15/3/24.
//  Copyright (c) 2015年 wangdong. All rights reserved.
//

import UIKit

class UtilCookie: NSObject {
   
    //加载Cookie
    class func loadCookie() {
        let userData = NSUserDefaults()
        let cookiesData = userData.objectForKey("cookies") as? NSData
        if cookiesData != nil
        {
            let cookies : Array<NSHTTPCookie> = NSKeyedUnarchiver.unarchiveObjectWithData(cookiesData!) as! Array<NSHTTPCookie>
    
            for cookie: NSHTTPCookie in cookies
            {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie as NSHTTPCookie)
            }
        }
    }
    //删除Cookie
    class func logout() {
        let cookies : Array? = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
        
        
        //cookies?.removeAll(keepCapacity: false)
        for c in cookies! {
            let cookie = c 
            let cookieName = cookie.name as String
            if cookieName == "web_qtstr" {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }
        }
        NSNotificationCenter.defaultCenter().postNotificationName("unlogin", object: nil)
        saveCookie()
    }
    //保存Cookie
    class func saveCookie() {
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
        if cookies != nil {
            let cookiesData = NSKeyedArchiver.archivedDataWithRootObject(cookies!)
            let userData = NSUserDefaults()
            userData.setObject(cookiesData, forKey: "cookies")
            userData.synchronize()
        }
    }
    //获取Cookie
    class func getCookieByKey(key:String) -> String {
        
        let cookies : NSArray? = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
        if cookies == nil {
            return ""
        }
        for c in cookies! {
            let cookie = c as! NSHTTPCookie
            let cookieName = cookie.name as String
            if cookieName == key && cookie.value != "deleted" {
                return cookie.value as String
            }
        }
        return ""
    }
    
}
