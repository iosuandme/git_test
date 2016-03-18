//
//  UCCheckLoginValidRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/16.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCCheckLoginValidRequest: BaseRequest {
    
    required init(loginToken : String) {
        super.init()
        self.isPostMethod = false
        self.addHttpHeader(["X-Trend-LToken" : loginToken])
    }
    
    override func getServerType() -> ServerType {
        return .UC
    }
    
    override func getRelativeURL() -> String {
        return "users/session"
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func needUnifiableLoading() -> Bool {
        return false
    }
    
    override func needCommonParameters() -> Bool {
        return false
    }
    
    
    
}
