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
        self.addReqParam("banks", value: (params["bankName"] + "").lowercaseString, isSign: false)
        self.addReqParam("bankNumber", value: params["bankNo"] + "", isSign: false)
        self.addReqParam("bankLocation", value: params["location"] + "", isSign: false)
        self.addReqParam("checkCode", value: params["mbCode"] + "", isSign: false)
        self.addReqParam("locationId", value: "1", isSign: false)
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRelativeURL() -> String {
        return "cloud/f/apps/user-bankCard/add"
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func needOriginData() -> Bool {
        return true
    }
}
