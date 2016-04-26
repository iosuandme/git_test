//
//  UCProjectPayRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/26.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCProjectPayRequest: BaseRequest {
    
    private var isBenefit   : Bool  = true
    
    required init(isBenefit : Bool , data : Dictionary<String , AnyObject>) {
        super.init()
        self.isBenefit          = isBenefit
        self.isPostMethod       = true
        self.addHttpHeader(["X-Trend-LToken" : data["token"] + ""])
        self.addReqParam("bidId", value: data["bidId"] + "", isSign: false)
        self.addReqParam("money", value: data["money"] + "", isSign: false)
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRelativeURL() -> String {
        return isBenefit ? "charity/donate" : "bid/safeSubmittion"
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func decodeJsonRequestData(responseDic: Dictionary<String, AnyObject>) -> BaseData {
        let data                        = BaseData()
        if let succ = responseDic["success"] as? Bool {
            if succ {
                data.cjxnfsCode         = 10000
            }else{
                data.cjxnfsCode         = 10001
                if let msg = responseDic["msg"] as? String {
                    data.responseMsg    = msg
                }else{
                    data.responseMsg    = responseDic["message"] + ""
                }
            }
        }else{
            data.cjxnfsCode             = 10002
        }
        return data
    }
}
