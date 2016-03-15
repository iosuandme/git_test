//
//  HomeBenefitRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/9.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class HomeBenefitRequest: BaseRequest {
    
    required init(currentPage : Int , maxSize : Int) {
        super.init()
        self.isPostMethod   = false
        self.addReqParam("maxSize", value: "\(maxSize)", isSign: false)
        self.addReqParam("currentPage", value: "\(currentPage)", isSign: false)
    }
    
    override func getRelativeURL() -> String {
        return "zgh/bidCharityList"
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func needUnifiableLoading() -> Bool {
        return false
    }
    
    override func decodeJsonRequestData(responseDic: Dictionary<String, AnyObject>) -> BaseData {
        let benefitData                          = HomeBenefitData()
        if let rows = responseDic["rows"] as? Array<Dictionary<String, AnyObject>> {
            benefitData.cjxnfsCode              = 10000
                var list                        = Array<HomeProjectData>()
                for row in rows {
                    let project                 = HomeProjectData()
                    project.type                = 1
                    project.bidNo               = row["id"] + ""
                    project.borrowLimit         = (row as NSDictionary).parseNumber("total", numberType: ParseNumberType.int) as! Int
                    project.timePeriod          = "\((project.borrowLimit / 10000))"
                    project.rate                = row["org"] + ""
                    project.process             = (Double((row as NSDictionary).parseNumber("collected", numberType: ParseNumberType.int) as! Int) / Double(project.borrowLimit) * 100).format(".0")
                    let bidStatus               = row["bidStatus"] + ""
                    switch bidStatus {
                    case "BIDING" :
                        project.status          = "立即捐款"
                    default :
                        project.status          = "捐款完成"
                    }
                    project.title               = row["title"] + ""
                    list.append(project)
                }
                benefitData.benefitList         = list
        }else{
            benefitData.cjxnfsCode              = 10001
            benefitData.responseMsg             = "数据获取失败"
        }
        return benefitData
    }
}
