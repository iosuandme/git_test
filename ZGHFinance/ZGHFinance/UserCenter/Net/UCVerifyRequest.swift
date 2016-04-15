//
//  UCVerifyRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/15.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCVerifyRequest: BaseRequest {

    required init(data : Dictionary<String , AnyObject>) {
        super.init()
        
        self.isPostMethod       = true
        self.addHttpHeader(["X-Trend-LToken" : data["token"] + ""])
        self.addReqParam("realName", value: data["realname"] + "", isSign: false)
        self.addReqParam("idCard", value: data["idCard"] + "", isSign: false)
        self.addReqParam("phone", value: data["phone"] + "", isSign: false)
        self.addReqParam("checkCode", value: data["checkCode"] + "", isSign: false)
        self.addReqParam("tradePassword", value: data["tradePassword"] + "", isSign: false)
        self.addReqParam("bankCardNo", value: data["bankCardNo"] + "", isSign: false)
        self.addReqParam("pcId", value: data["pcId"] + "", isSign: false)
        self.addReqParam("bankLocation", value: data["bankLocation"] + "", isSign: false)
    }
    
    override func needOriginData() -> Bool {
        return true
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRelativeURL() -> String {
        return "center/tradeAuth"
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
}
