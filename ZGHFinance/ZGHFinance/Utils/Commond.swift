//
//  Commond.swift
//  KLineView
//
//  Created by zhangyr on 15/4/22.
//  Copyright (c) 2015年 cjxnfs. All rights reserved.
//

import UIKit

class Commond: NSObject {
   
    //MARK: 字符串转换为日期时间对象
    class func dateFromString(str : String) -> NSDate {
        
        let dateF = NSDateFormatter()
        dateF.dateFormat = "yyyy-MM-dd"
        let tempDate = dateF.dateFromString(str)
        return tempDate!
    }
    //MARK: 时间对象转换为时间字段信息
    
    class func dateComponentsWithDate(inout date : NSDate?) -> NSDateComponents! {
        if date == nil {
            date = NSDate()
        }
        //获取公历的calendar对象
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        //定义一个时间段的标志，指定获取年月日时分秒的信息
        var unitFlags : NSCalendarUnit!
        if IOS_7 {
            unitFlags = [NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSDayCalendarUnit, NSCalendarUnit.NSWeekdayCalendarUnit, NSCalendarUnit.NSHourCalendarUnit, NSCalendarUnit.NSMinuteCalendarUnit, NSCalendarUnit.NSSecondCalendarUnit]
        }else if #available(iOS 8 , *) {
            unitFlags = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second]
        }
        
        //获取不同时间字段信息
        let dateCom = calendar?.components(unitFlags, fromDate: date!)
        return dateCom
    }
    
    class func isEqualWithFloat(f1 : Float ,f2 : Float ,absDelta : Int) -> Bool {
        var i1 ,i2 : Int!
        let num = NSNumber(unsignedLongLong: 0x80000000)
        i1 = f1 > 0 ? Int(f1) : Int(f1) - num.integerValue
        i2 = f2 > 0 ? Int(f2) : Int(f2) - num.integerValue
        return abs(i1 - i2) < absDelta
    }
    //获取用户偏好信息
    class func getUserDefaults(key : String) -> AnyObject? {
       return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    //设置用户偏好信息
    class func setUserDefaults(obj : AnyObject , key : String) {
        NSUserDefaults.standardUserDefaults().setObject(obj, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    //删除某条偏好信息
    class func removeUserDefaults(key : String) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //数值变化
    class func changePrice(price : CGFloat) -> String! {
        
        var newPrice : CGFloat = 0
        var moneyUnit = "万"
        if Int(price) > 10_000 {
            newPrice = price / 10_000
        }
        if Int(price) > 10_000_000 {
            newPrice = price / 10_000_000
            moneyUnit = "千万"
        }
        if Int(price) > 100_000_000 {
            newPrice = price / 100_000_000
            moneyUnit = "亿"
        }
        let newStr = NSString(format: "%.1f%@", newPrice , moneyUnit)
        return newStr as String
    }
    
}
