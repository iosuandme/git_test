//
//  FinancingService.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/9.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class FinancingService: BaseService {
    
    class func getFinancingListWithPage(currentPage : Int , maxSize : Int , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request     = FinancingListRequest(currentPage: currentPage, maxSize: maxSize)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func getFinancingDetailData(id : String , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request     = FinanceDetailRequest(id: id)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func getFinancingRecordList(id : String , currentPage : Int , maxSize : Int , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request     = FinanceDetailRecordRequest(id: id, currentPage: currentPage, maxSize: maxSize)
        self.doRequest(request, completion: completion, failure: failure)
    }
}
