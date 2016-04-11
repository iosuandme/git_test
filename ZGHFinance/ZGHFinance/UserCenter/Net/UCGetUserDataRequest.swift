//
//  UCGetUserDataRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/11.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCGetUserDataRequest: BaseRequest {

    required init(token : String) {
        super.init()
        self.isPostMethod   = true
        self.addHttpHeader(["X-Trend-LToken" : token])
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRelativeURL() -> String {
        return "center/getUserInfo"
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func decodeJsonRequestData(responseDic: Dictionary<String, AnyObject>) -> BaseData {
        let userInfo                    = UCUserInfoData()
        if responseDic.count > 0 {
            userInfo.cjxnfsCode         = 10000
            userInfo.username           = responseDic["username"] + ""
            userInfo.realname           = responseDic["realname"] + ""
            userInfo.idCard             = responseDic["idCard"] + ""
            userInfo.cellPhone          = responseDic["cellPhone"] + ""
            userInfo.loveCoins          = Int(responseDic["loveCoins"] + "") ?? 0
        }else{
            userInfo.cjxnfsCode         = 10001
            userInfo.responseMsg        = "用户信息获取失败"
        }
        return userInfo
    }
}
