//
//  HomeData.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/9.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class HomeData: NSObject {
    
    var investData  : HomeInvestData!
    var benefitData : HomeBenefitData!
}

class HomeInvestData : BaseData {
    var investList  : Array<HomeProjectData>! = Array()
}

class HomeBenefitData : BaseData {
    var benefitList : Array<HomeProjectData>  = Array()
}

class HomeProjectData : NSObject , UIWebViewDelegate {
    
    var type            : Int       = 0  //0项目1公益
    var bidNo           : String    = ""
    var borrowLimit     : Int       = 0
    var timePeriod      : String    = ""
    var rate            : String    = "0"
    var process         : String    = "0"
    var status          : String    = ""
    var title           : String    = ""
    
}
