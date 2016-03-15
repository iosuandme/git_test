//
//  BaseData.swift
//  cjxnfs
//
//  Created by zhangyr on 15/6/18.
//  Copyright (c) 2015年 cjxnfs. All rights reserved.
//

import UIKit

class BaseData: NSObject
{
    private var _responseMsg    : String    = ""
    private var _cjxnfsCode   : Int       = -100
    
    var response                : NSHTTPURLResponse?
    var httpResponseCode        : Int?
    var cjxnfsCode            : Int?
    {
        get
        {
            return              _cjxnfsCode
        }
        
        set
        {
            if newValue != nil
            {
                _cjxnfsCode       = newValue!
            }else
            {
                _responseMsg        = "服务繁忙，请稍候再试"
            }
        }
    }
    
    var responseMsg             : String?
    {
        get
        {
            return              _responseMsg
        }
        set
        {
            if newValue != nil
            {
                _responseMsg    = newValue!
            }
        }
    }
    var responseData            : AnyObject?
    
    
//    func description() -> String
//    {
//        return "response:\(response)\n httpResponseCode: \(httpResponseCode)\n cjxnfsCode: \(cjxnfsCode)\n responseMsg: \(responseMsg)\n responseData: \(responseData)\n "
//    }
}
