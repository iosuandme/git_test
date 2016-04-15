//
//  BaseRequest.swift
//  cjxnfs
//
//  Created by zhangyr on 15/6/17.
//  Copyright (c) 2015年 cjxnfs. All rights reserved.
//

import UIKit

let NO_NETWORK              = 10001

enum ServerType : Int
{
    case Base = 1
    case UC
    case QCGBase
    case QCGUC
}

class QCGError : NSObject
{
    var msg         : String?
    var error       : NSError?
    var reqUrl      : AFHTTPRequestOperation?
    
    required init(msg : String?, error : NSError? , reqUrl : AFHTTPRequestOperation?)
    {
        self.msg    = msg
        self.error  = error
        self.reqUrl = reqUrl
    }
}

class BaseRequest: NSObject
{
    let requestManager              : QCGHTTPRequestOperationManager = QCGHTTPRequestOperationManager.sharedOperationManager
    var completionBlock             : ((BaseData?) -> Void)?            //请求完成的回调
    var failureBlock                : ((QCGError!) -> Void)?             //请求失败的回调
    private var requestParamDic     : Dictionary<String, AnyObject>?    //请求所有参数
    private var requestCommonDic    : Dictionary<String, String>?       //请求通用参数
    private var postFileParaDic     : Dictionary<String, AnyObject>?    //需要post上传的文件字典
    var isPostMethod                : Bool              = false
    var timeout                     : NSTimeInterval    = 20.0
    var outputType                  : String            = "json"
    private var httpHeader          : Dictionary<String , String>?      = nil   //http头
    
    static  var requests            : Dictionary<String, AFHTTPRequestOperation>   = Dictionary<String, AFHTTPRequestOperation>()
    private var currentOperation    : AFHTTPRequestOperation?
    
    
    
    private var toastView           : ToastView?
    
    
    enum RequestOutputType : Int
    {
        case OUTPUT_XML = 1
        case OUTPUT_JSON
        case OUTPUT_BIN
    }
    
    func getServerType() -> ServerType
    {
        return ServerType.Base
    }
    
    func getRelativeURL() -> String
    {
        preconditionFailure("The method 'getRelativeURL' must be overridden")
    }
    
    func getRequestVersion() -> String
    {
        return "1.1"
    }
    
    func needUnifiableLoading() -> Bool
    {
        if IOS_7 {
            return false
        }
        return true
    }
    
    func needCommonParameters() -> Bool {
        return true
    }
    
    func needOriginData() -> Bool {
        return false
    }
    
    func decodeJsonRequestData(responseDic : Dictionary<String,AnyObject>) -> BaseData
    {
        let baseData : BaseData         = BaseData()
        baseData.cjxnfsCode             = responseDic["code"] as? Int
        baseData.responseMsg            = responseDic["msg"] as? String
        baseData.responseData           = responseDic["data"]
        return baseData
    }
    
    func decodeBinRequestData(responseDic : Dictionary<String,AnyObject>) -> BaseData
    {
        preconditionFailure("The method 'decodeBinRequestData' must be overridden")
    }
    
    func setOutputType(type : RequestOutputType) -> Void
    {
        var typeStr = "json"
        
        switch type
        {
        case RequestOutputType.OUTPUT_JSON:
            typeStr = "json"
        case RequestOutputType.OUTPUT_XML:
            typeStr = "xml"
        case RequestOutputType.OUTPUT_BIN:
            typeStr = "bin"
        }
        
        self.outputType = typeStr
    }
    
    func setTimeoutSeconds(seconds : NSTimeInterval) -> Void
    {
        self.timeout = seconds
    }
    
    /**
     为请求增加参数。签名为后续做准备
     
     - parameter key:    参数键
     - parameter value:  参数值
     - parameter isSign: 该参数是否参与签名算法
     */
    func addReqParam(key : String, value : String, isSign :Bool) -> Void
    {
        if requestParamDic == nil
        {
            requestParamDic = Dictionary<String,AnyObject>()
        }
        
        if !isSign
        {
            requestParamDic![key] = value
        }
        
    }
    
    func addHttpHeader(header : Dictionary<String , String>?)
    {
        
        self.httpHeader = header
        
    }
    
    /**
     上传文件，post文件地址
     
     - parameter key:   文件参数key
     - parameter value: 文件值，绝对路径
     */
    func addPostFileURL(key : String! ,value : String!, isSign : Bool) -> Void
    {
        if postFileParaDic == nil
        {
            self.postFileParaDic = Dictionary<String,AnyObject>()
        }
        
        if !isSign
        {
            self.postFileParaDic![key] = value
        }
    }
    /**
     上传文件，post文件地址
     
     - parameter key:   文件参数key
     - parameter value: 文件值，绝对路径
     */
    func addPostFileData(key : String ,value : NSData, isSign : Bool) -> Void
    {
        if postFileParaDic == nil
        {
            self.postFileParaDic = Dictionary<String,AnyObject>()
        }
        
        if !isSign
        {
            self.postFileParaDic![key] = value
        }
    }
    
    
    /**
     发起请求
     
     - parameter success: 请求完成的回调
     - parameter failure: 请求失败的回调
     */
    func doRequest() -> Void
    {
        let relativeURL : String = self.getRelativeURL()
        let url : String    = NetCommonFun.getServerUrl(self.getServerType())
        var startReq    : Bool   = true
        if !(AFNetworkReachabilityManager.sharedManager().reachable)
        {
            let error       : NSError   = NSError(domain: "no network!", code: NO_NETWORK, userInfo: ["relativeURL" : relativeURL, "serverType" : url])
            let qcgError    : QCGError  = QCGError(msg: "请检查您的手机网络", error: error , reqUrl : nil)
            startReq             = false
            self.failureBlock!(qcgError)
            return
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if self.needUnifiableLoading()
        {
            toastView           = ToastView.showMessage("加载中...", withTarget: nil, andAction: nil)
            toastView?.hideBgView()
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                if startReq {
                    self.toastView?.showBgView()
                }
            }
        }
        
        
        let requestSuccess  =
        {
            (operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
            
            startReq             = false
            BaseRequest.requests.removeValueForKey(NSStringFromClass(self.classForCoder))
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false;
            
            var baseData : BaseData?
            if self.outputType == "json" && responseObject is Dictionary<String,AnyObject>
            {
                
                baseData = self.decodeJsonRequestData(responseObject as! Dictionary<String,AnyObject>)
                if baseData != nil
                {
                    baseData!.httpResponseCode      = operation.response?.statusCode
                    baseData!.response              = operation.response
                    if baseData!.httpResponseCode == 200 && baseData!.cjxnfsCode == 10003 //检测出未登录
                    {
                        let defaults        = NSUserDefaults.standardUserDefaults()
                        let deviceToken     = defaults.stringForKey("deviceToken")
                        if deviceToken != nil
                        {
                        }
                        UtilCookie.logout()
                    }
                }
                
            }else if self.outputType == "bin"
            {
                baseData = self.decodeBinRequestData(responseObject as! Dictionary<String,AnyObject>)
                if baseData != nil
                {
                    baseData!.response          = operation.response
                    baseData!.httpResponseCode  = operation.response!.statusCode
                }
                
            }else
            {
                baseData                            = BaseData()
                if responseObject is NSData {
                    baseData?.responseData          = NSString(data: responseObject as! NSData, encoding: NSUTF8StringEncoding)
                    baseData?.responseMsg           = "数据异常"
                }else{
                    baseData?.responseData              = responseObject
                    if let code = Int(responseObject + "") {
                        baseData?.cjxnfsCode            = code
                        baseData?.responseMsg           = "请求失败（\(code)）"
                    }else{
                        baseData?.cjxnfsCode            = 10004
                        baseData?.responseMsg           = "数据异常"
                    }
                }
            }
            if(self.completionBlock != nil)
            {
                self.completionBlock!(baseData)
            }
            
            self.toastView?.dismiss()
        }
        
        let requestFailure =
        {
            (operation :AFHTTPRequestOperation?, erro :NSError!) -> Void in
            startReq             = false
            BaseRequest.requests.removeValueForKey(NSStringFromClass(self.classForCoder))
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if self.failureBlock != nil
            {
                var qcgError : QCGError?
                if erro.code == -1003 && UtilCheck.isLogin()//Code=-1003 "未能找到使用指定主机名的服务器。"   域名错误，登出。
                {
                    qcgError    = QCGError(msg: "请检查您的网络！", error: erro , reqUrl : operation)
                    let defaults        = NSUserDefaults.standardUserDefaults()
                    let deviceToken     = defaults.stringForKey("deviceToken")
                    if deviceToken != nil
                    {
                    }
                    UtilCookie.logout()
                }else if erro.code == 404
                {
                    qcgError    = QCGError(msg: "服务器开小差了", error: erro , reqUrl : operation)
                }else
                {
                    qcgError    = QCGError(msg: "请检查您的网络", error: erro , reqUrl : operation)
                }
                
                self.failureBlock!(qcgError!)
            }
            
            self.toastView?.dismiss()
        }
        if needCommonParameters() {
            self.prepareCommonParameters()
        }
        if self.requestParamDic == nil
        {
            self.requestParamDic = Dictionary<String,AnyObject>()
        }
        requestManager.requestSerializer.timeoutInterval            = timeout
        if needOriginData() {
            requestManager.responseSerializer                       = AFCompoundResponseSerializer()
        }else{
            requestManager.responseSerializer                       = QCGHTTPRequestOperationManager.keepResponseSerializer!
        }
        requestManager.responseSerializer.acceptableContentTypes    = NSSet(array: ["application/json", "text/json", "text/javascript" , "text/plain","text/html"]) as Set<NSObject>
        if httpHeader != nil {
            for (key , value) in httpHeader! {
                requestManager.requestSerializer.setValue(value, forHTTPHeaderField: key)
            }
        }
        if isPostMethod
        {
            //服务处理公共参数在一个公共区，在做doget，dopost之前处理的。需要client提供一个不分httpmethod的url
            let postUrl         = self.getUrlWithParameter(url + relativeURL, parameters: requestCommonDic!)
            if postFileParaDic != nil && postFileParaDic!.count > 0
            {
                requestManager.POST(postUrl!, parameters: self.requestParamDic, constructingBodyWithBlock:
                    {   (formData:AFMultipartFormData!) in
                        
                        for (_, value) in self.postFileParaDic!
                        {
                            if value is String
                            {
                                do
                                {
                                    try formData.appendPartWithFileURL(NSURL.fileURLWithPath(value as! String), name: "fileName")
                                }catch
                                {
                                    
                                }
                            } else if value is NSData
                            {
                                formData.appendPartWithFormData((value as! NSData), name: "fileBin")
                            }else
                            {
                                preconditionFailure("post文件只支持全路径和NSData两种类型")
                            }
                            
                        }
                    }
                    , success: requestSuccess, failure: requestFailure)
            }else
            {
                currentOperation    = requestManager.POST(postUrl!, parameters: self.requestParamDic, success: requestSuccess, failure: requestFailure)
            }
            
        }else
        {
            if requestCommonDic != nil
            {
                for key : String in self.requestCommonDic!.keys
                {
                    self.requestParamDic![key] = self.requestCommonDic![key]
                }
            }
            currentOperation        = requestManager.GET(url + relativeURL, parameters: requestParamDic, success: requestSuccess, failure: requestFailure)
        }
        
        BaseRequest.requests[NSStringFromClass(self.classForCoder)] = currentOperation
        
    }
    
    func cancel() -> Void
    {
        self.completionBlock    = nil;
        self.failureBlock       = nil;
        if currentOperation != nil
        {
            if !currentOperation!.cancelled
            {
                currentOperation!.cancel()
            }
        }
    }
    
    /// 取消所有排队中的请求
    class func cancelAll()
    {
        if BaseRequest.requests.count > 0
        {
            for (_, value) in BaseRequest.requests
            {
                if !value.cancelled && !value.finished
                {
                    value.setCompletionBlockWithSuccess(nil, failure: nil)
                    value.cancel()
                }
                
            }
        }
        
        QCGHTTPRequestOperationManager.sharedOperationManager.operationQueue.cancelAllOperations()
        
    }
    
    class func cancelRequest(requestKey : String)
    {
        if requestKey.length() <= 0
        {
            return
        }
        
        if BaseRequest.requests.count <= 0
        {
            return
        }
        
        if !BaseRequest.requests.keys.contains(requestKey)
        {
            return
        }
        
        if let operation     = BaseRequest.requests[requestKey]
        {
            if !operation.cancelled && !operation.finished
            {
                operation.setCompletionBlockWithSuccess(nil, failure: nil)
                operation.cancel()
                ToastView.dismissAllToasts()
            }
        }
        
        
    }
    
    ///拼接url
    private func getUrlWithParameter(url : String, parameters : Dictionary<String, String>!) -> String?
    {
        var result : String?     = nil
        if url.length() == 0
        {
            result  = nil
        }
        if parameters == nil || parameters.count == 0
        {
            result  = url
        }
        
        let range0   = url.rangeOfString("?")
        
        var tmpUrl0  = url
        if range0 == nil
        {
            tmpUrl0  = tmpUrl0 + "?"
        }
        
        let range   = tmpUrl0.rangeOfString("?")
        
        if range!.endIndex == tmpUrl0.endIndex
        {
            var tmpUrl  = tmpUrl0
            for (key, value) in parameters
            {
                tmpUrl += "\(key)=\(value.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)&"
            }
            result  = tmpUrl.substringToIndex(tmpUrl.endIndex.advancedBy(-1))
        }else
        {
            if range!.endIndex < tmpUrl0.endIndex
            {
                let range1 = tmpUrl0.rangeOfString("&")
                if range1 != nil
                {
                    if range1!.endIndex == tmpUrl0.endIndex
                    {
                        var tmpUrl  = tmpUrl0
                        for (key, value) in parameters
                        {
                            tmpUrl += "\(key)=\(value.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)&"
                        }
                        result  = tmpUrl.substringToIndex(tmpUrl.endIndex.advancedBy(-1))
                    }else
                    {
                        var tmpUrl  = tmpUrl0 + "&"
                        for (key, value) in parameters
                        {
                            tmpUrl += "\(key)=\(value.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)&"
                        }
                        result  = tmpUrl.substringToIndex(tmpUrl.endIndex.advancedBy(-1))
                    }
                    
                }else
                {
                    var tmpUrl  = tmpUrl0 + "&"
                    for (key, value) in parameters
                    {
                        tmpUrl += "\(key)=\(value.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)&"
                    }
                    result  = tmpUrl.substringToIndex(tmpUrl.endIndex.advancedBy(-1))
                }
            }else
            {
                result  = tmpUrl0
            }
        }
        
        return result
    }
    /**
     通用参数准备，设备id，设备平台,发布渠道等等信息
     */
    private func prepareCommonParameters() -> Void
    {
        if requestCommonDic == nil
        {
            self.requestCommonDic = Dictionary<String, String>()
        }
        let device      = UIDevice.currentDevice()
        let version     = device.systemVersion
        let sysName     = device.systemName
        let deviceid    = UtilTool.getUniqueDeviceId()
        let bundleInfo  = NSBundle.mainBundle().infoDictionary
        let appVersion  = bundleInfo!["CFBundleVersion"] + ""
        self.requestCommonDic!["platform"]      = "ios"
        self.requestCommonDic!["screenSize"]    = NSStringFromCGSize(UIScreen.mainScreen().bounds.size)
        self.requestCommonDic!["apiversion"]    = self.getRequestVersion()
        self.requestCommonDic!["os_version"]    = sysName + version
        self.requestCommonDic!["brand"]         = "Apple"
        self.requestCommonDic!["app_version"]   = appVersion
        self.requestCommonDic!["device_id"]     = deviceid
    }
    
    
}
