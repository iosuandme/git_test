//
//  FinancingListRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/9.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class FinancingListRequest: BaseRequest {

    required init(currentPage : Int , maxSize : Int) {
        super.init()
        self.isPostMethod   = false
        self.addReqParam("currentPage", value: "\(currentPage)", isSign: false)
        self.addReqParam("maxSize", value: "\(maxSize)", isSign: false)
    }
    
    override func getRelativeURL() -> String {
        return "rest/invest/list"
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
        let financingData                       = FinancingListData()
        
        if let rows = responseDic["rows"] as? Array<Dictionary<String, AnyObject>> {
            financingData.cjxnfsCode        = 10000
            var list                        = Array<HomeProjectData>()
            for row in rows {
                let project                 = HomeProjectData()
                project.type                = 0
                project.bidNo               = row["id"] + ""
                project.borrowLimit         = (row as NSDictionary).parseNumber("borrowLimit", numberType: ParseNumberType.int) as! Int
                project.timePeriod          = (row["borrowTimeLimit"] as? Dictionary<String,AnyObject>)?["timePeriod"] + ""
                project.rate                = Double(row["rate"] + "") == nil ? "0" :Double(row["rate"] + "")!.formatDecimal(false)
                project.process             = row["process"] + ""
                let status                  = row["status"] + ""
                switch status {
                case "BIDING" :
                    project.status          = "投标中"
                case "FAIL" :
                    project.status          = "流标"
                case "FILLEDBID" :
                    project.status          = "满标待审"
                case "REPAYMENT" :
                    project.status          = "还款中"
                case "SUCCESSREPAY" :
                    project.status          = "已还款"
                default :
                    project.status          = "投标中"
                    
                }
                project.title               = row["title"] + ""
                list.append(project)
            }
            financingData.financingList     = list
            
        }else{
            financingData.cjxnfsCode        = 10001
            financingData.responseMsg       = "数据获取失败"
        }
        return financingData
    }

}
