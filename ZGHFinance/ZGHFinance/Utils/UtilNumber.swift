//
//  UtilNumber.swift
//  cjxnfs
//
//  Created by jiafa on 15/3/16.
//  Copyright (c) 2015年 wangdong. All rights reserved.
//

import Foundation

//number为传进来的金额数   isReal表示是否为真实金额
func toWanString(number:Int, isReal : Bool = true , fen_power : Double = 100) -> NSString {
    
    var money = Double(number)
    if !isReal {
        money = Double(number) / fen_power
    }
    
    //化点模式的万元单位
    func toPointString(number : Double) ->NSString {
        
        let doubleNum : Double! = number / 10000.0
        var doubleStr : String! = "\(doubleNum)"
        var sign = ""
        if doubleStr.hasPrefix("-") {
            sign = "-"
            doubleStr = doubleStr.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.AnchoredSearch, range: nil)
        }
        let range = doubleStr.rangeOfString(".")
        let intStr = doubleStr.substringToIndex(range!.startIndex)
        let floatStr = doubleStr.substringFromIndex(range!.endIndex) as NSString
        
        var trunStr : String = ""
        var count : Int = 0
        for char in intStr.characters {
            trunStr = String(char) + trunStr
            count++
        }
        
        var index : Int = 0
        var resStr : String = ""
        
        
        if count < 4 {
            resStr = intStr
            
        }else{
            for char in trunStr.characters {
                resStr = String(char) + resStr
                index++
                if index % 3 == 0 {
                    if index < count{
                        resStr = "," + resStr
                    }
                }
            }
        }
        var result = ""
        if floatStr.floatValue < 0.01 {
            result = "\(sign)\(resStr)万"
        }else{
            result = "\(sign)\(resStr).\(floatStr)万"
        }
        return NSString(string: result)
    }
    //加分隔的原金额单位
    func toFormatString(number:Int) -> NSString {
        
        var intStr = "\(number)"
        
        var sign = ""
        if intStr.hasPrefix("-") {
            sign = "-"
            intStr = intStr.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.AnchoredSearch, range: nil)
        }
        
        var trunStr : String = ""
        var count : Int = 0
        for char in intStr.characters {
            trunStr = String(char) + trunStr
            count++
        }
        
        var index : Int = 0
        var resStr : String = ""
        
        
        if count < 4 {
            resStr = intStr
            
        }else{
            for char in trunStr.characters {
                resStr = String(char) + resStr
                index++
                if index % 3 == 0 {
                    if index < count{
                        resStr = "," + resStr
                    }
                }
            }
        }
        let result = "\(sign)\(resStr)"
        return NSString(string: result)
    }
    //带小数点的单位
    func toFenPointString (number : Double) -> NSString {
        
        let doubleStr = String(format: "%.2lf",number)
        let range = doubleStr.rangeOfString(".")
        var intStr = doubleStr.substringToIndex(range!.startIndex)
        var sign = ""
        if intStr.hasPrefix("-") {
            sign = "-"
            intStr = intStr.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.AnchoredSearch, range: nil)
        }
        let floatStr = doubleStr.substringFromIndex(range!.endIndex) as NSString
        
        var trunStr : String = ""
        var count : Int = 0
        for char in intStr.characters {
            trunStr = String(char) + trunStr
            count++
        }
        
        var index : Int = 0
        var resStr : String = ""
        
        
        if count < 4 {
            resStr = intStr
            
        }else{
            for char in trunStr.characters {
                resStr = String(char) + resStr
                index++
                if index % 3 == 0 {
                    if index < count{
                        resStr = "," + resStr
                    }
                }
            }
        }
        
        let result = "\(sign)\(resStr).\(floatStr)"
        return NSString(string: result)
    }
    
    if money % 100 == 0 && money >= 10000 {
        return toPointString(money)
    }else if money % 1 == 0 {
        return toFormatString(Int(money))
    }else{
        return toFenPointString(money)
    }
}

//ASCII码获取

func getASCIIForChar (char : String) -> Int? {
    
    var str = ""
    for cu in char.utf8 {
        str += String(cu)
    }
    let charASC : Int! = Int(str)
    return charASC
}




