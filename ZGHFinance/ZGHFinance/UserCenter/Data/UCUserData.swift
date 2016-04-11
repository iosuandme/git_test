//
//  UCUserData.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/16.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCUserData: BaseData , NSCoding {

    var loginName   : String = ""
    var password    : String = ""
    var loginToken  : String = ""
    var username    : String = ""
    var id          : String = ""
    var timeStamp   : Int    = 0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        loginName   = aDecoder.decodeObjectForKey("loginName") + ""
        password    = aDecoder.decodeObjectForKey("password") + ""
        loginToken  = aDecoder.decodeObjectForKey("loginToken") + ""
        username    = aDecoder.decodeObjectForKey("username") + ""
        id          = aDecoder.decodeObjectForKey("id") + ""
        timeStamp   = Int(aDecoder.decodeInt64ForKey("timeStamp"))
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(loginName, forKey: "loginName")
        aCoder.encodeObject(password, forKey: "password")
        aCoder.encodeObject(loginToken, forKey: "loginToken")
        aCoder.encodeObject(username, forKey: "username")
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeInt64(Int64(timeStamp), forKey: "timeStamp")
    }
    
}
