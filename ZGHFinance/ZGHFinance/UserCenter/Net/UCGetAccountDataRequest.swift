//
//  UCGetAccountDataRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/11.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCGetAccountDataRequest: BaseRequest {

    required init(token : String) {
        super.init()
        self.isPostMethod   = true
        self.addHttpHeader(["X-Trend-LToken" : token])
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRelativeURL() -> String {
        return "center/userBoard"
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func decodeJsonRequestData(responseDic: Dictionary<String, AnyObject>) -> BaseData {
        let accountInfo                         = UCAccountInfoData()
        if responseDic.count > 0 {
            accountInfo.cjxnfsCode              = 10000
            accountInfo.balance                 = Double(responseDic["balance"] + "") ?? 0
            accountInfo.countEarnings           = Double(responseDic["countEarnings"] + "") ?? 0
            accountInfo.financialFund           = Double(responseDic["financialFund"] + "") ?? 0
            accountInfo.frozenFund              = Double(responseDic["frozenFund"] + "") ?? 0
        }else{
            accountInfo.cjxnfsCode              = 10001
            accountInfo.responseMsg             = "账户信息获取失败"
        }
        return accountInfo
    }
    
}
