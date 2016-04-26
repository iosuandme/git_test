//
//  UCAddBankCardRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/26.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCAddBankCardRequest: BaseRequest {

    required init(params : Dictionary<String , AnyObject>) {
        super.init()
        self.isPostMethod = true
        self.addHttpHeader(["X-Trend-LToken" : params["token"] + ""])
        
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRelativeURL() -> String {
        return "cloud/f/apps/ user-bankCard/add"
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
}
