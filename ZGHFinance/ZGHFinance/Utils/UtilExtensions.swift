//
//  UtilExtensions.swift
//  GaodiLicai
//
//  Created by zhangyr on 15/12/6.
//  Copyright © 2015年 cjxnfs. All rights reserved.
//

import UIKit

extension NSDictionary {
    
    func parseNumber(key : String , numberType : ParseNumberType) -> AnyObject {
        let obj: AnyObject? = self.objectForKey(key)
        var val : AnyObject = 0
        if obj is NSString {
            if numberType == ParseNumberType.int {
                val = (obj as! NSString).integerValue
            }else if numberType == ParseNumberType.float {
                val = (obj as! NSString).floatValue
            }
        }else if obj is NSNumber {
            if numberType == ParseNumberType.int {
                val = (obj as! NSNumber).integerValue
            }else if numberType == ParseNumberType.float {
                val = (obj as! NSNumber).floatValue
            }
        }else if obj is Int {
            val = obj!
        }else if obj is Float {
            val = obj!
        }else{
            //println(obj)
        }
        return val
    }
}

extension CGFloat {
    
    func formatString() -> String {
        let tmpInt = Int64((self + 0.00005) * 100)
        if tmpInt % 100 == 0 {
            return String(format: "%.0f", self)
        }else if tmpInt % 10  == 0 {
            return String(format: "%.1f", self)
        }else{
            return String(format: "%.2f", self)
        }
    }
    
}


extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
    
    func formatDecimal(needFloat : Bool) -> String {
        let format                = NSNumberFormatter()
        format.numberStyle        = .DecimalStyle
        if needFloat {
            format.positiveFormat = "###,##0.00"
        }
        return format.stringFromNumber(NSNumber(double: self + 0.0005))!
    }
}

extension Int {
    func formatDecimal() -> String {
        let format                = NSNumberFormatter()
        format.numberStyle        = .DecimalStyle
        return format.stringFromNumber(NSNumber(integer: self))!
    }
}

extension String {
    //MD5加密
    func md5() -> String {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.destroy()
        
        return String(hash)
    }
    //字符串的长度
    func length() -> Int! {
        return (self as NSString).length
    }
    //正则表达式
    func isMatch(regex: String, options: NSRegularExpressionOptions) -> Bool
    {
        var error: NSError?
        var exp: NSRegularExpression?
        do {
            exp = try NSRegularExpression(pattern: regex, options: options)
        } catch let error1 as NSError {
            error = error1
            exp = nil
        }
        if let error = error {
            print(error.description)
        }
        let matchCount = exp?.numberOfMatchesInString(self, options: [], range: NSMakeRange(0, self.length()))
        return matchCount > 0
    }
    
    func escapeHeadStr(str:String) -> (String, Bool)
    {
        var result = self as NSString
        var findAtleastOne = false
        while(true)
        {
            let range = result.rangeOfString(str)
            if range.location == 0 && range.length == 1
            {
                result = result.substringFromIndex(range.length)
                findAtleastOne = true
            }else
            {
                break
            }
        }
        return (result as String, findAtleastOne)
    }
    
    func countSubString(subStr : String) -> Int {
        var count = 0
        if self.length() == 0 {
            return 0
        }
        var nsStr = self as NSString
        var range : NSRange!
        var subString = ""
        var isEnd = false
        repeat {
            
            range = nsStr.rangeOfString(subStr)
            if range.length > 0 {
                count++
                subString = nsStr.substringFromIndex(range.location + range.length)
                nsStr     = subString as NSString
            }else{
                isEnd = true
            }
            
        }while(!isEnd)
        
        return count
    }
    
    func isPureFloat() -> Bool {
        let scan = NSScanner(string: self)
        var val : UnsafeMutablePointer<Float>!
        val      = UnsafeMutablePointer<Float>.alloc(0)
        return scan.scanFloat(val) && scan.atEnd
    }
    
    func isPureInt() -> Bool {
        let scan = NSScanner(string: self)
        var val : UnsafeMutablePointer<Int32>!
        val      = UnsafeMutablePointer<Int32>.alloc(0)
        return scan.scanInt(val) && scan.atEnd
    }
    
    func addAttributeToSubString(subString : String , withAttributes attributes : [String : AnyObject]) -> NSAttributedString {
        
        let mutableAttri    = NSMutableAttributedString(string: self)
        mutableAttri.addAttributes(attributes, range: (self as NSString).rangeOfString(subString))
        return mutableAttri
    }
    
}