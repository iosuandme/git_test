//
//  HomeInvestRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/9.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class HomeInvestRequest: BaseRequest {

    required init(maxSize : String) {
        super.init()
        self.isPostMethod   = false
        self.addReqParam("maxSize", value: maxSize, isSign: false)
    }
    
    override func getRelativeURL() -> String {
        return "rest/indexBids"
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func needUnifiableLoading() -> Bool {
        return true
    }
    
    override func decodeJsonRequestData(responseDic: Dictionary<String, AnyObject>) -> BaseData {
        let investData                          = HomeInvestData()
        if let bids = responseDic["companyBids"] as? Dictionary<String, AnyObject> {
            investData.cjxnfsCode               = 10000
            if let rows = bids["rows"] as? Array<Dictionary<String, AnyObject>> {
                var list                        = Array<HomeProjectData>()
                for row in rows {
                    let project                 = HomeProjectData()
                    project.type                = 0
                    project.bidNo               = row["id"] + ""
                    project.borrowLimit         = (row as NSDictionary).parseNumber("borrowLimit", numberType: ParseNumberType.int) as! Int
                    project.timePeriod          = (row["borrowTimeLimit"] as? Dictionary<String,AnyObject>)?["timePeriod"] + ""
                    project.rate                = Double(row["rate"] + "") == nil ? "0" :Double(row["rate"] + "")!.formatDecimal(false)
                    project.process             = row["process"] + ""
                    project.status              = (row["status"] as? Dictionary<String,AnyObject>)?["text"] + ""
                    project.title               = row["title"] + ""
                    list.append(project)
                }
                investData.investList           = list
            }
            
        }else{
            investData.cjxnfsCode               = 10001
            investData.responseMsg              = "数据获取失败"
        }
        return investData
    }
    
}
