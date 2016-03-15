//
//  FinanceDetailRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/14.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class FinanceDetailRequest: BaseRequest {
    
    private var financeId   : String = ""
    
    required init(id : String) {
        super.init()
        financeId           = id
        self.isPostMethod   = false
    }
    
    override func getRelativeURL() -> String {
        return "rest/invest/list/" + financeId
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func decodeJsonRequestData(responseDic: Dictionary<String, AnyObject>) -> BaseData {
        let detailData                      = FinanceDetailData()
        
        if let bid = responseDic["bid"] as? Dictionary<String, AnyObject> {
            let dic                         = bid as NSDictionary
            detailData.cjxnfsCode           = 10000
            let headerData                  = FinanceDetailHeadData()
            headerData.expectProfit         = responseDic["investIncome"] + ""
            headerData.collected            = dic.parseNumber("collected", numberType: ParseNumberType.int) as! Int
            headerData.type                 = 0
            headerData.bidNo                = bid["id"] + ""
            headerData.borrowLimit          = dic.parseNumber("borrowLimit", numberType: ParseNumberType.int) as! Int
            headerData.timePeriod           = (bid["borrowTimeLimit"] as? Dictionary<String,AnyObject>)?["timePeriod"] + ""
            headerData.rate                 = Double(bid["rate"] + "") == nil ? "0" :Double(bid["rate"] + "")!.formatDecimal(false)
            headerData.process              = bid["process"] + ""
            headerData.status               = (bid["status"] as? Dictionary<String,AnyObject>)?["text"] + ""
            headerData.title                = bid["title"] + ""
            
            let otherData                   = FinanceDetailOtherData()
            var oData                       = FinanceDetailCellData()
            oData.title                     = "借款描述"
            oData.text                      = bid["content"] + ""
            oData.type                      = .Text
            otherData.otherDatas.append(oData)
            
            if let companyInfo = bid["loanCompany"] as? Dictionary<String,AnyObject> {
                oData                       = FinanceDetailCellData()
                oData.title                 = "借款人信息"
                let companyName             = companyInfo["name"] + ""
                let companyType             = (companyInfo["economicType"] as? Dictionary<String,AnyObject>)?["text"] + ""
                let companyAddr             = companyInfo["address"] + ""
                let registerAmount          = companyInfo["registeredCapital"] + ""
                let foundDate               = UtilDateTime.formatTime("yyyy-MM-dd", time_interval: (companyInfo as NSDictionary).parseNumber("buildDate", numberType: ParseNumberType.int) as! Int / 1000)
                oData.text                  = "公司名称    \(companyName)\n公司类型    \(companyType)\n公司地址    \(companyAddr)\n注册资本    \(registerAmount)\n成立时间    \(foundDate)"
                oData.type                  = .Options
                oData.attributeArray        = ["公司名称","公司类型","公司地址","注册资本","成立时间"]
                otherData.otherDatas.append(oData)
            }
            
            oData                       = FinanceDetailCellData()
            oData.title                 = "借款记录信息"
            oData.text                  = "总借款记录  355笔\n已发布借款  330笔\n还款中借款  154笔\n已完成借款  176笔"
            oData.type                  = .Options
            oData.attributeArray        = ["总借款记录","已发布借款","还款中借款","已完成借款"]
            otherData.otherDatas.append(oData)
            
            oData                       = FinanceDetailCellData()
            oData.title                 = "风险控制信息"
            oData.text                  = bid["remark"] + ""
            oData.type                  = .Text
            otherData.otherDatas.append(oData)
            
            detailData.headerData       = headerData
            detailData.otherData        = otherData
        }else{
            detailData.cjxnfsCode           = 10001
            detailData.responseMsg          = "数据获取失败"
        }
        return detailData
    }
    
}
