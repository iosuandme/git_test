//
//  UCLoginRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/16.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCLoginRequest: BaseRequest {

    required init(username : String , loginPassword : String) {
        super.init()
        self.isPostMethod   = true
        self.addReqParam("username", value: username, isSign: false)
        self.addReqParam("loginPassword", value: loginPassword, isSign: false)
    }
    
    override func getServerType() -> ServerType {
        return .UC
    }
    
    override func getRelativeURL() -> String {
        return "small/users/login"
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func needUnifiableLoading() -> Bool {
        return false
    }
    
    override func decodeJsonRequestData(responseDic: Dictionary<String, AnyObject>) -> BaseData {
        let userData                            = UCUserData()
        if let error = responseDic["error"] as? Dictionary<String , AnyObject> {
            userData.cjxnfsCode                 = Int(error["code"] + "")
            userData.responseMsg                = error["msg"] + ""
        }else if let result = responseDic["result"] as? Dictionary<String , AnyObject> {
            userData.cjxnfsCode                 = 10000
            userData.loginToken                 = result["loginToken"] + ""
            userData.username                   = result["username"] + ""
            userData.id                         = result["id"] + ""
        }else{
            userData.cjxnfsCode                 = 10001
            userData.responseMsg                = "数据获取失败"
        }
        return userData
    }
    
}
