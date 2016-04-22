//
//  UCBankCardsData.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/21.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCBankCardsData: BaseData {
    var cardList        : Array<UCBankCardInfo> = Array()
}

struct UCBankCardInfo {
    var cardId          : String = ""
    var cardNo          : String = ""
    var cardName        : String = ""
    var desc            : String = ""
    var isSelected      : Bool   = false
}
