//
//  NetCommonFun.swift
//  cjxnfs
//
//  Created by zhangyr on 15/6/18.
//  Copyright (c) 2015年 cjxnfs. All rights reserved.
//

import UIKit

class NetCommonFun: NSObject
{
    //test
    static var baseUrlTest          = "http://service.cjxnfs.com/"
    static var ucUrlTest            = "http://service.cjxnfs.com/"
    static var qcgUCTest            = "http://service.cjxnfs.com/"
    static var qcgBaseTest          = "http://service.cjxnfs.com/"
    
    //product
    static var baseUrlProduct       = "http://service.cjxnfs.com/"
    static var ucUrlProduct         = "http://service.cjxnfs.com/"
    static var qcgUCProduct         = "http://service.cjxnfs.com/"
    static var qcgBaseProduct       = "http://service.cjxnfs.com/"
    
    class func getServerUrl(type : ServerType) -> String
    {
        switch type
        {
        case ServerType.Base:
            #if TEST
                return baseUrlTest
            #else
                return baseUrlProduct
            #endif
            
        case ServerType.UC:
            #if TEST
                return ucUrlTest
            #else
                return ucUrlProduct
            #endif
            
        case ServerType.QCGUC:
            #if TEST
                return qcgUCTest
            #else
                return qcgUCProduct
            #endif
            
        case ServerType.QCGBase:
            #if TEST
                return qcgBaseTest
            #else
                return qcgBaseProduct
            #endif


        }
        
    }}
