//
//  HomeService.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/9.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class HomeService: BaseService {
    
    class func getHomeInvestDataWithMaxSize(maxSize : String , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request     = HomeInvestRequest(maxSize: maxSize)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func getHomeBenefitData(currentPage : Int = 1 , maxSize : Int = 2 , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request     = HomeBenefitRequest(currentPage: currentPage, maxSize: maxSize)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func getHomeBenefitDetailData(id : String, needContent : Bool = true , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request     = HomeBenefitDetailRequest(id: id , needContent: needContent)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
    class func getHomeBenefitRecordData(id : String , currentPage : Int , maxSize : Int , completion : ((BaseData?) -> Void),failure : ((QCGError!) -> Void)) {
        let request     = HomeBenefitRecordRequest(id: id, currentPage: currentPage, maxSize: maxSize)
        self.doRequest(request, completion: completion, failure: failure)
    }
    
}
