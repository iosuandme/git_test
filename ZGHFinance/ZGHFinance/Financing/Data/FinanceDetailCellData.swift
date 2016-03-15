//
//  FinanceDeailCellData.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/13.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

enum FinanceDetailType : Int {
    case Text
    case Options
    case Web
}

class FinanceDetailCellData: NSObject {

    var title           : String            = ""
    var text            : NSString            = ""
    var type            : FinanceDetailType = .Text
    var attributeArray  : Array<String>     = Array()
    var attributeString : NSMutableAttributedString {
        let paragraph                       = NSMutableParagraphStyle()
        switch type {
        case .Options :
            paragraph.lineSpacing           = 8
        case .Text :
            paragraph.lineSpacing           = 5
        default :
            break
        }
        let attri                           = NSMutableAttributedString(string: text as String, attributes: [NSParagraphStyleAttributeName : paragraph])
        for s in attributeArray {
            attri.addAttribute(NSForegroundColorAttributeName, value: UtilTool.colorWithHexString("#a3a3a3"), range: text.rangeOfString(s))
        }
        return attri
    }
}
