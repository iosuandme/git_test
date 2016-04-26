//
//  UCGetCardListRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/26.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCGetCardListRequest: BaseRequest {

    required init(token : String) {
        super.init()
        
        self.isPostMethod = true
        self.addHttpHeader(["X-Trend-LToken" : token])
        
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRelativeURL() -> String {
        return "center/bankCardList"
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func decodeJsonRequestData(responseDic: Dictionary<String, AnyObject>) -> BaseData {
        let bankData                                = UCBankCardsData()
        if let _ = responseDic["banks"] as? Array<AnyObject> {
            bankData.cjxnfsCode                     = 10000
        }else{
            bankData.cjxnfsCode                     = 10001
            bankData.responseMsg                    = "数据获取失败"
        }
        if let bankList = responseDic["data"] as? Array<Dictionary<String , AnyObject>> {
            for bank in bankList {
                let tmp                             = UCBankCardInfo()
                tmp.cardName                        = (bank["banks"] as? Dictionary<String , AnyObject>)?["text"] + ""
                tmp.cardNo                          = bank["bankNumber"] + ""
                tmp.desc                            = bank["status"] + "" == "1" ? "默认绑定银行卡(不可更改)" : "非绑定银行卡"
                bankData.cardList.append(tmp)
            }
        }
        return bankData
    }
    
}
