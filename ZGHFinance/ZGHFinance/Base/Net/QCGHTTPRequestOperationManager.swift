//
//  QCGHTTPRequestOperationManager.swift
//  cjxnfs
//
//  Created by zhangyr on 15/7/30.
//  Copyright (c) 2015年 cjxnfs. All rights reserved.
//

import UIKit

class QCGHTTPRequestOperationManager: AFHTTPRequestOperationManager
{
    static var keepResponseSerializer : AFHTTPResponseSerializer?
    class var sharedOperationManager: QCGHTTPRequestOperationManager
    {
        dispatch_once(&Inner.token)
        {
            Inner.instance                      = QCGHTTPRequestOperationManager()
            keepResponseSerializer              = Inner.instance?.responseSerializer
            let securityPolicy                  = AFSecurityPolicy(pinningMode: AFSSLPinningMode.None)
            securityPolicy.validatesDomainName  = false
            securityPolicy.allowInvalidCertificates = true
            Inner.instance?.securityPolicy      = securityPolicy
        }
        return Inner.instance!
    }
    
    struct Inner {
        static var instance: QCGHTTPRequestOperationManager?
        static var token: dispatch_once_t = 0
    }
}
