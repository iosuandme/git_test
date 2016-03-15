//
//  BaseService.swift
//  cjxnfs
//
//  Created by zhangyr on 15/6/19.
//  Copyright (c) 2015年 cjxnfs. All rights reserved.
//

import UIKit

class BaseService: NSObject
{
//    static var table    : Dictionary<BaseViewController, BaseRequest>   = Dictionary<BaseViewController, BaseRequest> ()

    func onDestroy() -> Void
    {
        
    }
    
    class func doRequest(request : BaseRequest!, completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void))
    {
//        if controller != nil
//        {
//            table[controller!]                              = request
//        }
        request.completionBlock                             = completion
        request.failureBlock                                = failure
        request.doRequest()
    }
    
    class func cancelRequest(key : String)
    {
        BaseRequest.cancelRequest(key)
    }
    
    /// 慎用，不会回执请求前的状态
    class func cancelAllRequests()
    {
        BaseRequest.cancelAll()
    }
}
