//
//  UCService.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/16.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCService: BaseService {
    
    class func loginActionWithUsername(username : String , loginPassword : String , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request = UCLoginRequest(username: username, loginPassword: loginPassword)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func sendMbCodeWithPhone(phone : String , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request = UCMobileCodeRequest(phone: phone)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func registerActionWithParams(params : Dictionary<String , AnyObject> , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request = UCRegisterRequest(params: params)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func getUserDataWithToken(token : String , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request = UCGetUserDataRequest(token: token)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func getAccountDataWithToken(token : String , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request = UCGetAccountDataRequest(token: token)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func verifyAuthInfo(data : Dictionary<String , AnyObject> , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request = UCVerifyRequest(data: data)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func getUserBankCardList(token : String , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request = UCGetCardListRequest(token: token)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func payForBidWithParams(isBenefit : Bool , params : Dictionary<String , AnyObject> , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request = UCProjectPayRequest(isBenefit: isBenefit, data: params)
        self.doRequest(request, completion: completion, failure: failure)
    }
}
