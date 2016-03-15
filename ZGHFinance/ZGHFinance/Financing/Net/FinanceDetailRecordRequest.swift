//
//  FinanceDetailRecordRequest.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/15.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class FinanceDetailRecordRequest: BaseRequest {

    required init(id : String , currentPage : Int , maxSize : Int) {
        super.init()
        self.isPostMethod   = false
        self.addReqParam("bidId", value: id, isSign: false)
        self.addReqParam("currentPage", value: "\(currentPage)", isSign: false)
        self.addReqParam("maxSize", value: "\(maxSize)", isSign: false)
    }
    
    override func getRelativeURL() -> String {
        return "rest/submittions"
    }
    
    override func getServerType() -> ServerType {
        return .Base
    }
    
    override func getRequestVersion() -> String {
        return "1.0"
    }
    
    override func decodeJsonRequestData(responseDic: Dictionary<String, AnyObject>) -> BaseData {
        let recordData                          = FinanceRecordData()
        if let rows = responseDic["rows"] as? Array<Dictionary<String , AnyObject>> {
            recordData.cjxnfsCode               = 10000
            var recordList                      = Array<FinanceRecordDetailData>()
            for rDic in rows {
                let tmpDic                      = rDic as NSDictionary
                let record                      = FinanceRecordDetailData()
                record.name                     = (rDic["user"] as? Dictionary<String , AnyObject>)?["username"] + ""
                record.amount                   = tmpDic.parseNumber("amount", numberType: ParseNumberType.int) as! Int
                record.enableAmount             = tmpDic.parseNumber("validMoney", numberType: ParseNumberType.int) as! Int
                record.time                     = tmpDic.parseNumber("createTime", numberType: ParseNumberType.int) as! Int
                recordList.append(record)
            }
            recordData.recordList               = recordList
        }else{
            recordData.cjxnfsCode               = 10001
            recordData.responseMsg              = "数据获取失败"
        }
        return recordData
    }
    
}
