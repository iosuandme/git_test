//
//  UCRegisterRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/10.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCRegisterRequest: BaseRequest {

    required init(params : Dictionary<String , AnyObject>) {
        super.init()
        self.isPostMethod = true
        self.addReqParam("cellPhone", value: params["cellPhone"] + "", isSign: false)
        self.addReqParam("loginPassword", value: params["loginPassword"] + "", isSign: false)
        self.addReqParam("checkCode", value: params["checkCode"] + "", isSign: false)
        self.addReqParam("username", value: params["username"] + "", isSign: false)
    }
    
    override func getRelativeURL() -> String {
        return "sign-up/phone"
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func decodeJsonRequestData(responseDic: Dictionary<String, AnyObject>) -> BaseData {
        let userData                            = UCUserData()
        if let _ = responseDic["result"] as? Dictionary<String , AnyObject> {
            userData.cjxnfsCode                 = 10000
            userData.responseMsg                = "注册成功"
        }else{
            userData.cjxnfsCode                 = 10001
            userData.responseMsg                = "注册失败"
        }
        return userData
    }
    
}
