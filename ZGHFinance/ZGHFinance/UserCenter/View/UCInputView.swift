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
    func inputViewButtonTap(inputView : UCInputView , actionButton : UIButton)
}

class UCInputView: UIView , UCInputViewDelegate {
    
    var text                    : String? {
        get {
            return textField.text
        }
        
        set {
            textField.text  = newValue
        }
    }
    var iconImage               : UIImage? {
        didSet {
            icon.image                  = iconImage
        }
    }
    var textColor               : UIColor = UtilTool.colorWithHexString("#666") {
        didSet {
            textField.textColor         = textColor
        }
    }
    var font                    : UIFont = UIFont.systemFontOfSize(12) {
        didSet {
            textField.font              = font
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
    var keyboardType            : UIKeyboardType = .Default {
        didSet {
            textField.keyboardType   = keyboardType
        }
    }
    var btnTitle                : String = "" {
        didSet {
            button?.setTitle(btnTitle, forState: UIControlState.Normal)
        }
    }
    
    private var icon            : UIImageView!
    private var textField       : UITextField!
    private var button          : BaseButton?
    private var sepLine         : UIView?
    private weak var delegate   : UCInputViewDelegate?
    
    
    init(type: UCInputViewType , delegate : UCInputViewDelegate? , needLine : Bool) {
        super.init(frame: CGRectZero)
        
        self.delegate               = delegate
        icon                        = UIImageView()
        icon.image                  = iconImage
        self.addSubview(icon)
        
        textField                   = UITextField()
        textField.placeholder       = placeholder
        textField.secureTextEntry   = secureTextEntry
        textField.font              = font
        textField.textColor         = textColor
        textField.keyboardType      = keyboardType
        textField.addTarget(self, action: #selector(UCInputView.didChanged(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.addSubview(textField)
        
        if type == .WithButton {
            button                      = BaseButton()
            button?.backgroundColor     = UtilTool.colorWithHexString("#53a0e3")
            button?.titleLabel?.font    = UIFont.systemFontOfSize(10)
            button?.setTitle(btnTitle, forState: UIControlState.Normal)
            button?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button?.layer.cornerRadius  = 4
            button?.layer.masksToBounds = true
            button?.addTarget(self, action: #selector(UCInputView.buttonTap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(button!)
        }
        
        var offset : CGFloat            = 0
        if needLine {
            offset                      = -1
            sepLine                     = UIView()
            sepLine?.backgroundColor    = UtilTool.colorWithHexString("#ddd")
            self.addSubview(sepLine!)
        }
        
        icon.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self).offset()(16)
            maker.centerY.equalTo()(self).offset()(offset)
            maker.width.equalTo()(15)
            maker.height.equalTo()(19)
        }
        
        button?.mas_makeConstraints({ (maker) -> Void in
            maker.right.equalTo()(self).offset()(-16)
            maker.centerY.equalTo()(self.icon)
            maker.width.equalTo()(80)
            maker.height.equalTo()(30)
        })
        
        textField.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.icon.mas_right).offset()(24)
            maker.centerY.equalTo()(self.icon)
            if self.button == nil {
                maker.right.equalTo()(self).offset()(-16)
            }else{
                maker.right.equalTo()(self.button?.mas_left).offset()(-16)
            }
            maker.height.equalTo()(self).offset()(offset)
        }
        
        sepLine?.mas_makeConstraints({ (maker) -> Void in
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
            maker.bottom.equalTo()(self)
            maker.height.equalTo()(1)
        })
        
    }
    
    @objc private func buttonTap(button : UIButton) {
        delegate?.inputViewButtonTap?(self, actionButton: button)
    }
    
    @objc private func didChanged(tf : UITextField) {
        delegate?.inputViewDidChanged?(self, withInputString: tf.text!)
    }
    
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
