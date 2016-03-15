//
//  HomeBenefitDetailRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/15.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class HomeBenefitDetailRequest: BaseRequest {

    private var benefitId   : String = ""
    
    required init(id : String) {
        super.init()
        benefitId           = id
        self.isPostMethod   = false
    }
    
    override func getRelativeURL() -> String {
        return "zgh/bidCharityDetail/" + benefitId
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func decodeJsonRequestData(responseDic: Dictionary<String, AnyObject>) -> BaseData {
        let benefitDetail                   = HomeBenefitDetailData()
        if let bc = responseDic["bc"] as? Dictionary<String , AnyObject> {
            let tmpDic                      = bc as NSDictionary
            benefitDetail.cjxnfsCode        = 10000
            benefitDetail.title             = bc["title"] + ""
            benefitDetail.id                = bc["id"] + ""
            let bidStatus                   = bc["bidStatus"] + ""
            switch bidStatus {
            case "BIDING" :
                benefitDetail.bidStatus     = "捐款中"
            default :
                benefitDetail.bidStatus     = "捐款完成"
            }
            benefitDetail.total             = tmpDic.parseNumber("total", numberType: ParseNumberType.int) as! Int
            benefitDetail.collected         = tmpDic.parseNumber("collected", numberType: ParseNumberType.int) as! Int
            benefitDetail.org               = bc["org"] + ""
            benefitDetail.content           = bc["content"] + ""
            
        }else{
            benefitDetail.cjxnfsCode        = 10001
            benefitDetail.responseMsg       = "数据获取失败"
        }
        return benefitDetail
    }
}
