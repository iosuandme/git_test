//
//  UtilDateTime.swift
//  cjxnfs
//
//  Created by zhangyr on 15/3/24.
//  Copyright (c) 2015年 quzhaogu. All rights reserved.
//

import UIKit

class UtilDateTime: NSObject {
    
    //格式化时间 输入时间戳，以自定义的时间格式输出
    class func formatTime(express : String = "yyyy-MM-dd HH:mm",time_interval : Int = 0) -> String {
        var date : NSDate?
        
        if time_interval == 0 {
            date = NSDate()
        }else
        {
            date = NSDate(timeIntervalSince1970: Double(time_interval))
        }
        let format : NSDateFormatter! = NSDateFormatter()
        format.dateFormat = express
        let timeStr = format.stringFromDate(date!)
        return timeStr
    }
    //获取当前时间戳
    class func getTimeInterval() ->Int {
        let d = NSDate()
        let t = d.timeIntervalSince1970
        return Int(t)
    }
    
    class func getTimeIntervalByDateString(express : String = "yyyyMMdd" , dateStr : String) -> Int {
        let format : NSDateFormatter = NSDateFormatter()
        format.dateFormat = express
        let date = format.dateFromString(dateStr)
        let t = date?.timeIntervalSince1970
        return Int(t!)
    }
    
    //将输入的年月日转化为时间戳再转化为需要的格式  如 "yyyyMMdd"  20150606  "MM-dd" -> 06-06
    class func convertFormatByDate(express : String = "yyyyMMdd" , date_time : String , toFormat : String = "MM-dd") -> String {
        
        let format : NSDateFormatter = NSDateFormatter()
        format.dateFormat = express
        if date_time.length() < express.length() {
            return "错误时间"
        }
        let date = format.dateFromString(date_time)
        let formatNew : NSDateFormatter = NSDateFormatter()
        formatNew.dateFormat = toFormat
        let newTimeStr = formatNew.stringFromDate(date!)
        return newTimeStr
    }
    
    //输入一个时间戳显示多少时间前
    class func timeAgo(time_interval : Int) -> String {
        let agotime = getTimeInterval() - time_interval
        let str = [12*30*24*60*60:"年前",
            30*24*60*60:"个月前",
            7*24*60*60:"周前",
            24*60*60:"天前",
            60*60:"小时前",
            60:"分钟前",
            1:"秒前"
        ]
        if agotime < 1 {
            return "刚刚"
        }
        let keys = str.keys
        var tailStr : String!
        var font : String!
        var maxKey = 0
        for key in keys {
            if agotime >= key {
                if key > maxKey {
                    maxKey = key
                    tailStr = str[key]
                    font = String(agotime/key)
                }
            }
        }
        return font + tailStr
    }
    
    
    
}
