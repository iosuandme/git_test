//
//  UCDeleteBankCardRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/27.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCDeleteBankCardRequest: BaseRequest {
    
    private var id : String = ""

    required init(params : Dictionary<String , AnyObject>) {
        super.init()
        self.isPostMethod = false
        self.addHttpHeader(["X-Trend-LToken" : params["token"] + ""])
        id                = params["bankId"] + ""
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRelativeURL() -> String {
        return "cloud/f/apps/user-bankCard/delete/" + id
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func needOriginData() -> Bool {
        return true
    }
    
}
