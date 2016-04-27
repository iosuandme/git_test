//
//  NSTool.swift
//  cjxnfs
//
//  Created by wangdong on 15/3/15.
//  Copyright (c) 2015年 wangdong. All rights reserved.
//

import UIKit
import CoreTelephony

//当前屏幕宽
let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
//当前屏幕高
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height
//宽度比
let AUTO_SCALE_X : CGFloat = SCREEN_WIDTH / 320
//高度比
let AUTO_SCALE_Y : CGFloat = SCREEN_HEIGHT / 568
let IOS_7  =  UtilTool.getDeviceVersion() >= 7 && UtilTool.getDeviceVersion() < 8

let IOS_8  =  UtilTool.getDeviceVersion() >= 8
//小号字体大小
let SMALL_FONT_SIZE : CGFloat = 12
//一般标题字体大小
let TITLE_FONT_SIZE : CGFloat = 14
//一般文本字体
let TEXT_FONT_SIZE : CGFloat = 16
//导航字体大小
let NAVI_FONT_SIZE : CGFloat = 16
//一般试图高度
let VIEW_NORMAL_HEIGHT : CGFloat = 40
//刷新数据时间间隔
let REFRESH_TIME : NSTimeInterval = 5
//tabbar高度
let TABBAR_HEIGHT : CGFloat = 55

let FONTNAME1               = "Avenir"


enum ParseNumberType : Int {
    case int = 1
    case float
}


@objc class UtilTool : NSObject , SMAlertViewDelegate {
    
    //获取十六进制颜色值
    class func colorWithHexString (rgba: String) -> UIColor {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = rgba.startIndex.advancedBy(1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
                }
            } else {
                // print("Scan hex error")
            }
        } else {
            // print("Invalid RGB string, missing '#' as prefix", terminator: "")
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    //获取筹款百分比
    class func getChoukuanPercent(peizi_zijin:Int , ketou_zijin: Int) -> Int
    {
        if peizi_zijin == 0
        {
            return 0
        }
        var choukuan_percent = Float((peizi_zijin - ketou_zijin)) / Float(peizi_zijin) * 100
        if choukuan_percent < 1 && choukuan_percent > 0 {
            choukuan_percent = 1.0
        }
        if choukuan_percent > 99 && choukuan_percent < 100
        {
            choukuan_percent = 99.0
        }
        choukuan_percent = floor(choukuan_percent)
        return Int(choukuan_percent)
    }
    
    //金额属性文本格式，白色加大
    // string  金额前需要显示的内容     可选
    // stringBack 金额后需要显示的内容   可选
    // money 金额数   必选
    //isReal 是否为真实的金额 ，如果可能到分请传false  可选
    //power 金额字体放大倍数 可选
    class func moneyFormatString(string : String = "", stringBack : String = "",money:Int , isReal : Bool = true ,power : CGFloat = 1 ,color : UIColor = UIColor.whiteColor(), util : String = "元") -> NSMutableAttributedString {
        let moneyStr = toWanString(money , isReal :isReal)
        let formatStr = NSString(format: "\(string)\(moneyStr)\(util)\(stringBack)")
        let range = formatStr.rangeOfString(string)
        let subStr : NSString = formatStr.substringFromIndex(range.length)
        let attributedString = NSMutableAttributedString(string: formatStr as String);
        let redcolorAttributes = [NSForegroundColorAttributeName: color, NSFontAttributeName: UIFont.boldSystemFontOfSize(20 * power)]
        attributedString.addAttributes(redcolorAttributes, range: NSMakeRange(subStr.rangeOfString(moneyStr as String).location + range.length, subStr.rangeOfString(moneyStr as String).length))
        return attributedString
    }
    
    class func moneyFormatStringWithInt64(string : String = "", stringBack : String = "",money:Int64 , isReal : Bool = true ,power : CGFloat = 1 ,color : UIColor = UIColor.whiteColor(), util : String = "元") -> NSMutableAttributedString {
        let intMoney = Int(money / 100)
        let moneyStr = toWanString(intMoney , isReal :isReal)
        let formatStr = NSString(format: "\(string)\(moneyStr)\(util)\(stringBack)")
        let range = formatStr.rangeOfString(string)
        let subStr : NSString = formatStr.substringFromIndex(range.length)
        let attributedString = NSMutableAttributedString(string: formatStr as String);
        let redcolorAttributes = [NSForegroundColorAttributeName: color, NSFontAttributeName: UIFont(name: "Avenir", size: TEXT_FONT_SIZE * power)!]
        attributedString.addAttributes(redcolorAttributes, range: NSMakeRange(subStr.rangeOfString(moneyStr as String).location + range.length, subStr.rangeOfString(moneyStr as String).length))
        return attributedString
    }
    
    class func moneyColorString(preString : String = "", afterString : String = "", money:Int, isReal : Bool = true, power : CGFloat = 1 ,color : UIColor, util : String = "元") -> NSMutableAttributedString
    {
        let moneyStr = toWanString(money , isReal :isReal)
        return self.colorString(preString, desString: moneyStr as String, afterString: afterString, power: power, color: color, util: util)
    }
    
    
    /**
     *  Description  前缀后面的文字加统一颜色
     */
    class func colorString(preString : String = "", desString:String, afterString : String = "", power : CGFloat = 1 ,color : UIColor, util : String) -> NSMutableAttributedString
    {
        let formatStr   = NSString(format: "%@%@%@%@", preString, desString, util, afterString)
        let range = formatStr.rangeOfString(preString)
        let subStr : NSString = formatStr.substringFromIndex(range.length)
        let attributedString = NSMutableAttributedString(string: formatStr as String);
        let redcolorAttributes = [NSForegroundColorAttributeName: color, NSFontAttributeName: UIFont.systemFontOfSize(14 * power)]
        attributedString.addAttributes(redcolorAttributes, range: NSMakeRange(range.length, subStr.rangeOfString(desString).length))
        return attributedString
    }
    
//    ["preColor"   : preColor,     "preFont" : preFont,
//    "desColor"    : desColor,     "desFont" : desFont,
//    "afterColor"  : afterColor,   "" : afterFont]
    
    class func attributeString(preString : String = "", desString : String, afterString : String = "",  dic : Dictionary<String, AnyObject>) -> NSMutableAttributedString
    {
        let formatStr   = NSString(format: "\(preString)\(desString)\(afterString)")
        let preRange    = formatStr.rangeOfString(preString)
        let desRange    = formatStr.rangeOfString(desString)
        let afterRange  = formatStr.rangeOfString(afterString)
        
        let preColor    = dic["preColor"]   as? UIColor
        let preFont     = dic["preFont"]    as? UIFont
        
        let desColor    = dic["desColor"]   as? UIColor
        let desFont     = dic["desFont"]    as? UIFont
        
        let afterColor  = dic["afterColor"] as? UIColor
        let afterFont   = dic["afterFont"]  as? UIFont
        
//        let subStr : NSString = formatStr.substringFromIndex(range.length)
        
        let attributedString = NSMutableAttributedString(string: formatStr as String);
        
        
        if preColor != nil && preFont != nil
        {
            let preAttributes       = [NSForegroundColorAttributeName: preColor!, NSFontAttributeName : preFont!]
            attributedString.addAttributes(preAttributes, range: preRange)
        }
        if desColor != nil && desFont != nil
        {
            let desAttributes       = [NSForegroundColorAttributeName: desColor!, NSFontAttributeName : desFont!]
            attributedString.addAttributes(desAttributes, range: desRange)
        }
        
        if afterColor != nil && afterFont != nil
        {
            let afterAttributes     = [NSForegroundColorAttributeName: afterColor!, NSFontAttributeName : afterFont!]
            attributedString.addAttributes(afterAttributes, range: afterRange)
        }
        
        return attributedString
    }
    
    //状态栏显示
    
    //友好提示不合法操作 view为所要提醒显示试图 msg为提示内容,complete拖尾闭包可选,显示完信息之后做的事
    class func noticError (view view : UIView! ,msg : String ,offset : CGFloat = 0, time : Double = 0.5, complete:() -> Void = {}) {
        
        if view == nil
        {
            return
        }
        
        let during  = time
        
        let message = NSString(string: msg)
        let rect = message.boundingRectWithSize(CGSizeMake(view!.bounds.width - 100, 999), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont(name: "AvenirNext-Bold", size: 16)!], context: nil)
        
        let alert = UILabel(frame: CGRect(x: 0, y: 0, width: rect.size.width + 40, height: rect.size.height + 30))
        alert.numberOfLines = 0
        alert.backgroundColor = UIColor.blackColor()
        alert.font = UIFont(name: "AvenirNext-Bold", size: 16)
        alert.textColor = UIColor.whiteColor()
        alert.text = msg
        alert.textAlignment = NSTextAlignment.Center
        alert.center = view!.center
        alert.frame.origin.y = view!.bounds.height / 2 - alert.bounds.height / 2 + offset - 64
        alert.layer.cornerRadius = 5
        alert.layer.masksToBounds = true
        alert.alpha = 0
        view!.addSubview(alert)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            alert.alpha = 0.8
            }, completion: { (Bool) -> Void in
                UIView.animateKeyframesWithDuration(0.5, delay: during, options: UIViewKeyframeAnimationOptions.CalculationModeLinear, animations: { () -> Void in
                    alert.alpha = 0
                    }, completion: { (Bool) -> Void in
                        alert.removeFromSuperview()
                        complete()
                })
        })
        
    }
    
    //手机号中间加星
    class func encryMobileMiddle(mobile: String) -> String {
        if mobile.length() >= 11 {
            let mb = NSString(string: mobile)
            return mb.substringToIndex(3) + "****" + mb.substringFromIndex(mb.length-4)
        }else{
            return mobile
        }
    }
    
    //获取设备系统版本
    class func getDeviceVersion() -> Float {
        return (UIDevice.currentDevice().systemVersion as NSString).floatValue
    }
    
    class func idCardFormat(idCard : NSString) -> String {
        if idCard.length < 18 {
            return "****错误身份信息****"
        }
        let frontFour = idCard.substringToIndex(4)
        let backFour = idCard.substringFromIndex(idCard.length - 4)
        return "\(frontFour)**********\(backFour)"
    }
    
    //银行卡号格式，传进银行，卡号 以 "XX银行 1111*** ***1111" 格式输出
    class func bankCardFormat(cardNo : NSString) -> String {
        if cardNo.length < 10 {
            return cardNo as String
        }
        let frontFour = cardNo.substringToIndex(4)
        let backFour = cardNo.substringFromIndex(cardNo.length - 4)
        return "\(frontFour) **** **** \(backFour)"
    }
    
    //获得银行名称 或 代码    name可为代码，也可为名称   keyForValue默认通过代码找名称
    class func getBankName(name : String , keyForValue : Bool = true) -> String {
        
        var str                     = ""
        let bankInfo : NSDictionary = ["CMB":"招商银行","ICBC":"工商银行","CEB":"光大银行","GDB":"广发银行","CCB":"建设银行","CMBC":"民生银行","ABC":"农业银行","SPDB":"浦发银行","CIB":"兴业银行","BOC":"中国银行","CITIC":"中信银行","COMM":"交通银行"]
        if !keyForValue {
            for kv in bankInfo {
                if kv.value as! String == name {
                    str = kv.key as! String
                }
            }
        }else{
            str                     = bankInfo.objectForKey(name) + ""
        }
        return str
    }
    
    //获取当前显示的View的controller
    class func getCurrentController() -> UIViewController {
        var result : UIViewController!
        var win = UIApplication.sharedApplication().keyWindow
        if win?.windowLevel != UIWindowLevelNormal {
            let wins = UIApplication.sharedApplication().windows as NSArray
            for w in wins {
                if (w as! UIWindow).windowLevel == UIWindowLevelNormal {
                    win = w as? UIWindow
                    break
                }
            }
        }
        
        let frontView = (win!.subviews as NSArray).objectAtIndex(0) as! UIView
        let nextRes = frontView.nextResponder()
        if nextRes != nil && nextRes!.isKindOfClass(UIViewController.self) {
            result = nextRes as! UIViewController
        }else{
            result = win?.rootViewController
        }
        return result
    }
    
    //格式化数值信息
    class func formatTotalAmount(price : CGFloat) -> String {
        var newPrice : CGFloat = 0
        var moneyUnit = "万"
        if price > 10_000 {
            newPrice = price / 10_000
        }else{
            newPrice = price
            moneyUnit = ""
        }
        
        if price > 100_000_000 {
            newPrice = price / 100_000_000
            moneyUnit = "亿"
        }
        
        var newStr : NSString!
        if newPrice >= 1000 {
            newStr = NSString(format: "%.0f%@", newPrice , moneyUnit)
        }else if newPrice >= 100 {
            newStr = NSString(format: "%.1f%@", newPrice , moneyUnit)
        }else{
            newStr = NSString(format: "%.2f%@", newPrice , moneyUnit)
        }
        
        return newStr as String
    }
    //获取文件路径
    class func getDocumentPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    //获取appdelegate
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    //往controller中添加tabBar
    class func addTabBarToController(controller : UIViewController) {
        let tab = BottomTabBar.shareBottomTabBar(CGRect(x: 0, y: controller.view.bounds.height - TABBAR_HEIGHT, width: controller.view.bounds.width, height: TABBAR_HEIGHT) , delegate : controller)
//        tab.barDelegate         = RootVCConfig.sharedInstance
        controller.view.addSubview(tab)
        tab.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(controller.view)
            maker.right.equalTo()(controller.view)
            maker.bottom.equalTo()(controller.view)
            maker.height.equalTo()(TABBAR_HEIGHT)
        }
    }
    //设置tabBar的badge
    class func setBadgeNumber(index : Int ,num : Int) {
        let tab = BottomTabBar.shareBottomTabBar(CGRectZero, delegate: nil)
//        tab.badgeIndex = index
        tab.budgeNum = num
    }
    
    class func getUUID() -> String {
        if let uuid = Commond.getUserDefaults("uuid") as? String {
            return uuid
        }
        let puuid = CFUUIDCreate(nil)
        let uuidStr = CFUUIDCreateString(nil, puuid)
        let result = String(CFStringCreateCopy(nil, uuidStr))
        Commond.setUserDefaults(result, key: "uuid")
        return result
    }
    
    class func getDeviceToken() -> String {
        var token   = ""
        if let t = Commond.getUserDefaults("deviceToken") as? String {
            token   = t
        }
        return token
    }
    
    //获取设备唯一号 （UUID + TOKEN）
    class func getUniqueDeviceId() -> String {
        let uuid     = self.getUUID()
        let token    = self.getDeviceToken()
        let deviceId = "\(token)_" + uuid
        
        // print("\(deviceId)")
        
        return deviceId
    }
    
    class func rotateImage(aImage :UIImage) -> UIImage?
    {
        
        let imgRef      = aImage.CGImage
        let width       = CGFloat(CGImageGetWidth(imgRef))
        let height      = CGFloat(CGImageGetHeight(imgRef))
        
        var transform   = CGAffineTransform()
        var bounds      = CGRectMake(CGFloat(0), CGFloat(0), width, height)
        
        let scaleRatio : CGFloat = 1.0
        var boundHeight : CGFloat = 0
        
        let orient = aImage.imageOrientation;
        
        switch orient
        {
            
        case UIImageOrientation.Up:
            transform       = CGAffineTransformIdentity
        case UIImageOrientation.UpMirrored:
            transform       = CGAffineTransformMakeTranslation(width, CGFloat(0.0))
            transform       = CGAffineTransformScale(transform, -1.0, 1.0)
        case UIImageOrientation.Down:
            transform       = CGAffineTransformMakeTranslation(width, height)
            transform       = CGAffineTransformRotate(transform, CGFloat(M_PI))
        case UIImageOrientation.DownMirrored:
            transform       = CGAffineTransformMakeTranslation(0.0, height)
            transform       = CGAffineTransformScale(transform, 1.0, -1.0)
        case UIImageOrientation.LeftMirrored:
            boundHeight     = bounds.height
            bounds.size.height  = bounds.width
            bounds.size.width   = boundHeight
            transform           = CGAffineTransformMakeTranslation(height, width)
            transform           = CGAffineTransformScale(transform, -1.0, 1.0)
            transform           = CGAffineTransformRotate(transform, CGFloat(3.0 * M_PI / 2.0))
        case UIImageOrientation.Left:
            boundHeight         = bounds.height
            bounds.size.height  = bounds.width
            bounds.size.width   = boundHeight
            transform           = CGAffineTransformMakeTranslation(0.0, width)
            transform           = CGAffineTransformRotate(transform, CGFloat(3.0 * M_PI / 2.0))
        case UIImageOrientation.RightMirrored:
            boundHeight         = bounds.height
            bounds.size.height  = bounds.width
            bounds.size.width   = boundHeight
            transform           = CGAffineTransformMakeScale(-1.0, 1.0)
            transform           = CGAffineTransformRotate(transform, CGFloat(M_PI / 2.0))
        case UIImageOrientation.Right:
            boundHeight         = bounds.height
            bounds.size.height  = bounds.width
            bounds.size.width   = boundHeight
            transform           = CGAffineTransformMakeTranslation(height, 0.0)
            transform           = CGAffineTransformRotate(transform, CGFloat(M_PI / 2.0))
            
        }
        
        
        UIGraphicsBeginImageContext(bounds.size);
        
        
        
        let  context = UIGraphicsGetCurrentContext();
        
        
        if (orient == UIImageOrientation.Right || orient == UIImageOrientation.Left)
        {
            CGContextScaleCTM(context, -scaleRatio, scaleRatio);
            CGContextTranslateCTM(context, -height, 0);
        }else
        {
            CGContextScaleCTM(context, scaleRatio, -scaleRatio);
            CGContextTranslateCTM(context, 0, -height);
        }
        
        CGContextConcatCTM(context, transform);
        
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        return imageCopy;
        
    }
    
    class func ducumentFolder() -> String
    {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
    }
    
    class func getNetWorkStatus() -> String
    {
        if AFNetworkReachabilityManager.sharedManager().networkReachabilityStatus == AFNetworkReachabilityStatus.ReachableViaWiFi
        {
            return "wifi"
        }else
        {
            let netInfo     = CTTelephonyNetworkInfo()
            let info        = netInfo.currentRadioAccessTechnology
            if info == nil || info!.length() == 0 //模拟器
            {
                return "wifi"
            }
            if info == CTRadioAccessTechnologyCDMA1x || info == CTRadioAccessTechnologyGPRS || info == CTRadioAccessTechnologyEdge
            {
                return "2G"
            }else if info == CTRadioAccessTechnologyLTE
            {
                return "4G"
            }else
            {
                return "3G"
            }
        }
    }
    
    class func openWindowLevel() {
        dispatch_async(dispatch_get_main_queue(), {
            if let window = UIApplication.sharedApplication().keyWindow {
                window.windowLevel = UIWindowLevelStatusBar + 1
            }
        })
    }
    
    class func closeWindowLevel() {
        dispatch_async(dispatch_get_main_queue(), {
            if let window = UIApplication.sharedApplication().keyWindow {
                window.windowLevel = UIWindowLevelNormal
            }
        })
    }
    
    private var newVersionURLString : String!
    
    func updateVersion(updateVersion : String?)
    {
        let manager :AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        let url :String = "http://itunes.apple.com/lookup"
        let requestSuccess = {
            (operation :AFHTTPRequestOperation?, responseObject :AnyObject!) -> Void in
            
            let json                = responseObject as! NSDictionary
            let infoArr : NSArray  = json["results"]! as! NSArray
            
            if infoArr.count > 0
            {
                let releaseInfo : NSDictionary      = infoArr[0] as! NSDictionary
                let lastVersion : String            = releaseInfo["version"] + ""
                self.newVersionURLString            = releaseInfo["trackViewUrl"] + ""
                let bundleInfo = NSBundle.mainBundle().infoDictionary
                let appVersion = bundleInfo!["CFBundleVersion"] + ""
                
                if updateVersion != nil
                {
                    if updateVersion!.compare(appVersion) == NSComparisonResult.OrderedDescending || updateVersion!.compare(appVersion) == NSComparisonResult.OrderedSame
                    {
                        let alert : UIAlertView = UIAlertView(title: "请更新最新版本", message: "您的版本太旧，已无法使用", delegate: self, cancelButtonTitle: "去升级")
                        alert.tag               = 100
                        alert.show()
                        return
                    }
                }
                
                let hasClose    : Bool              = NSUserDefaults.standardUserDefaults().boolForKey("close")
                
                if hasClose
                {
                    return
                }
                
                if lastVersion.compare(appVersion) == NSComparisonResult.OrderedDescending
                {
                    let alert = SMAlertView(title: "新版本通知", message: "发现新的私募圈版本", delegate: self, cancelButtonTitle: "不再提示", otherButtonTitles: "我要去更新")
                    alert.tag               = 101
                    alert.show()
                }
            }
        }
        
        let failue  =
        {(operation :AFHTTPRequestOperation?, error :NSError!) -> Void in
        }
        
        manager.POST(url, parameters: ["id" : "1024403503"], success: requestSuccess, failure: failue)
    }
    
    
    class func getPercentData(num : Double, times : Double = 100, needSymbol : Bool    = true) -> String
    {
        let num0                        = abs(num)
        
        var symbol  : String            = "+"
        if num < 0
        {
            symbol                      = "-"
        }else if num == 0
        {
            symbol                      = ""
        }else
        {
            symbol                      = "+"
        }
        let num1                        = num0 / times
        var result  : String            = ""
        if needSymbol
        {
            
            result                      = String(format: "\(symbol)%.2f%%", num1)
        }else
        {
            result                      = String(format: "%.2f%%", num1)
        }
        return  result
    }
    
}

var GlobalMainQueue                 : dispatch_queue_t
{
    return dispatch_get_main_queue()
}

@available(iOS 8.0, *)
var GlobalUserInteractiveQueue      : dispatch_queue_t
{
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
}

@available(iOS 8.0, *)
var GlobalUserInitiatedQueue        : dispatch_queue_t
{
    return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
}

@available(iOS 8.0, *)
var GlobalUtilityQueue              : dispatch_queue_t
{
    return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
}

@available(iOS 8.0, *)
var GlobalBackgroundQueue           : dispatch_queue_t
{
    return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
}

func +(left : AnyObject?, right : String) -> String
{
    return left == nil ? "" : "\(left!)" + right
}



extension NSURLRequest
{
    
}

