//
//  FinanceDetailData.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/11.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class FinanceDetailData: BaseData {

    var headerData      : FinanceDetailHeadData!
    var otherData       : FinanceDetailOtherData!
    var otherHeight     : CGFloat {
        
        var height      : CGFloat                   = 0
        if otherData != nil {
            for od in otherData.otherDatas {
                height                             += 74
                switch od.type {
                case .Options :
                    if od.text.hasPrefix("公司名称") {
                        height                     += 92
                    }else{
                        height                     += 80
                    }
                case .Text :
                    let paragraph                   = NSMutableParagraphStyle()
                    paragraph.lineSpacing           = 5
                    let rect = od.text.boundingRectWithSize(CGSize(width: SCREEN_WIDTH - 32, height: 999), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSParagraphStyleAttributeName : paragraph , NSFontAttributeName : UIFont.systemFontOfSize(12)], context: nil)
                    height                         += rect.height
                default :
                    break
                }
            }
        }

        return height
    }
}

class FinanceRecordData: BaseData {
    var recordList      : Array<FinanceRecordDetailData> = Array()
}

class FinanceRecordDetailData : NSObject {
    var time            : Int    = 0
    var name            : String = ""
    var amount          : Int    = 0
    var enableAmount    : Int    = 0
}

class FinanceDetailHeadData : HomeProjectData {
    var expectProfit    : String = "0"
    var collected       : Int    = 0
}

class FinanceDetailOtherData : NSObject {
    var otherDatas      : Array<FinanceDetailCellData> = Array()
}
