//
//  UCInputView.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/17.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

enum UCInputViewType : Int {
    case Normal
    case WithButton
}

@objc protocol UCInputViewDelegate : NSObjectProtocol {
    optional
    func inputViewDidChanged(inputView : UCInputView , withInputString string : String)
    optional
    func inputViewButtonTap(inputView : UCInputView)
}

class UCInputView: UIView {
    
    var textString              : String? {
        get {
            return textField.text
        }
        
        set {
            textField.text  = textString
        }
    }
    var iconImage               : UIImage? {
        didSet {
            icon.image                  = iconImage
        }
    }
    var placeholder             : String = ""{
        didSet {
            textField.placeholder   = placeholder
        }
    }
    var secureTextEntry         : Bool   = false {
        didSet {
            textField.secureTextEntry   = secureTextEntry
        }
    }
    private var icon            : UIImageView!
    private var textField       : UITextField!
    private var button          : BaseButton?
    private var sepLine         : UIView?
    private weak var delegate   : UCInputViewDelegate?
    
    
    init(type: UCInputViewType , delegate : UCInputViewDelegate , needLine : Bool) {
        super.init(frame: CGRectZero)
        
        icon                        = UIImageView()
        icon.image                  = iconImage
        
        textField                   = UITextField()
        textField.placeholder       = placeholder
        textField.secureTextEntry   = secureTextEntry
        textField.font              = UIFont.systemFontOfSize(12)
        textField.textColor         = UtilTool.colorWithHexString("#666")
        
        if type == .WithButton {
            button                  = BaseButton()
            button?.backgroundColor = UtilTool.colorWithHexString("")
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
