//
//  UCMobileCodeRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/21.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCMobileCodeRequest: BaseRequest {
    
    required init(phone : String) {
        super.init()
        self.isPostMethod   = false
        self.addReqParam("phone", value: phone, isSign: false)
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRelativeURL() -> String {
        return "check/sendCode"
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
}
