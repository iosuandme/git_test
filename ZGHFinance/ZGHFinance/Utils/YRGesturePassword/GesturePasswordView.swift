//
//  GesturePasswordView.swift
//  YRGesturePasswordView
//
//  Created by zhangyr on 16/1/12.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

extension String {
    //MD5加密
    func md5Format() -> String {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.destroy()
        
        return String(hash)
    }
}

enum GestureVerifyStyle : Int {
    ///手势设置
    case Set
    ///手势修改
    case Change
    ///手势验证
    case Verify
    ///手势关闭
    case Close
}

protocol GesturePasswordViewDelegate : NSObjectProtocol {
    func gesturePasswordSetResult(passView : GesturePasswordView) -> Bool
    func gesturePasswordChangeResult(passView : GesturePasswordView) -> Bool
    func gesturePasswordVerifyResult(passView : GesturePasswordView) -> Bool
    func gesturePasswordCanceled(passView : GesturePasswordView)
    func gesturePasswordForgot(passView : GesturePasswordView)
}

class GesturePasswordView: UIView , GestureDrawViewDelegate {

    lazy var infoFontSize        : CGFloat            = 14
    lazy var textColor           : UIColor            = UIColor.whiteColor()
    lazy var tipsFontSize        : CGFloat            = 12
    lazy var errorColor          : UIColor            = UtilTool.colorWithHexString("#ec3d4b")
    lazy var maxTimes            : Int                = 5
    lazy var minCount            : Int                = 4
    var userKey                 : String             = "" {
        didSet {
            infoLabel.text  = UtilTool.encryMobileMiddle(userKey)
        }
    }
    var tipsText            : String                  = "" {
        didSet {
            tipsLabel.text  = tipsText
        }
    }
    
    private var verifyStyle      : GestureVerifyStyle = .Set

    private weak var delegate    : GesturePasswordViewDelegate?
    private var gestureShowView  : GestureShowView!
    private var infoLabel        : UILabel!
    private var tipsLabel        : UILabel!
    private var gestureView      : GestureDrawView!
    private var actionBtn        : UIButton!
    private var tmpValue         : String   = ""
    private var tmpVerify        : Bool     = false
    
    init(frame: CGRect , delegate : GesturePasswordViewDelegate? , style : GestureVerifyStyle) {
        super.init(frame: frame)
        self.delegate   = delegate
        verifyStyle     = style
        initUI()
    }
    
    private func initUI() {
        gestureShowView             = GestureShowView(frame: CGRect(x: 0, y: 0, width: 38 * SCALE_WIDTH_6, height: 38 * SCALE_WIDTH_6))
        var space : CGFloat         = 95
        if verifyStyle != .Verify {
            space                  -= 64
        }
        gestureShowView.center      = CGPointMake(self.bounds.width / 2, space * SCALE_HEIGHT_6)
        self.addSubview(gestureShowView)
        infoLabel                   = UILabel(frame: CGRect(x: 0, y: gestureShowView.frame.maxY + 15 * SCALE_HEIGHT_6, width: self.bounds.width, height: infoFontSize + 1))
        infoLabel.font              = UIFont.systemFontOfSize(infoFontSize)
        infoLabel.textColor         = textColor
        infoLabel.textAlignment     = .Center
        infoLabel.text              = userKey
        self.addSubview(infoLabel)
        tipsLabel                   = UILabel(frame: CGRect(x: 0, y: infoLabel.frame.maxY + 15 * SCALE_HEIGHT_6, width: self.bounds.width, height: tipsFontSize + 1))
        tipsLabel.font              = UIFont.systemFontOfSize(tipsFontSize)
        tipsLabel.textColor         = textColor
        tipsLabel.textAlignment     = .Center
        tipsLabel.text              = tipsText
        self.addSubview(tipsLabel)
        gestureView                 = GestureDrawView(frame: CGRect(x: 35 * SCALE_WIDTH_6, y: tipsLabel.frame.maxY + 40 * SCALE_WIDTH_6, width: self.bounds.width - 70 * SCALE_WIDTH_6, height: self.bounds.width - 70 * SCALE_WIDTH_6) , delegate : self)
        self.addSubview(gestureView)
        var btnFrame                = CGRectZero
        switch verifyStyle {
        case .Set:
            break
        case .Verify :
            btnFrame                = CGRect(x: self.bounds.width - 85, y: self.bounds.height - 40, width: 75, height: 40)
        case .Change :
            fallthrough
        case .Close:
            btnFrame                = CGRect(x: self.bounds.width - 85, y: self.bounds.height - 40 - 64, width: 75, height: 40)
        }
        if verifyStyle != .Set {
            let btnTitle                = "忘记手势密码"
            actionBtn                   = UIButton(frame: btnFrame)
            actionBtn.setTitle(btnTitle, forState: UIControlState.Normal)
            actionBtn.contentMode       = .Right
            actionBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            actionBtn.titleLabel?.font  = UIFont.systemFontOfSize(12)
            actionBtn.addTarget(self, action: "buttonAction", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(actionBtn)
        }
        showTips()
    }
    
    func gestureDrawViewDidDrawn(drawView: GestureDrawView, keys: Array<Int>, timeInterval: Int) -> Bool {
        if keys.count == 0 {
            return false
        }
        gestureShowView.selectedArray   = keys
        if verifyStyle == .Set && keys.count < minCount && tmpValue.isEmpty {
            tipsText                    = "手势密码最少\(minCount)位，请重新绘制"
            return false
        }
        var keyStr                      = ""
        for k in keys {
            keyStr                     += "\(k)"
        }
        switch verifyStyle {
        case .Set:
            return setAction(keyStr)
        case .Change :
            if !tmpVerify {
                tmpVerify       = verifyAction(keyStr , needSucc: false)
                if tmpVerify {
                    tipsText    = "绘制新的解锁图案"
                    if actionBtn != nil {
                        actionBtn.hidden    = true
                    }
                    verifyStyle = .Set
                }
                return tmpVerify
            }else{
                return false
            }
        case .Verify :
            return verifyAction(keyStr)
        case .Close :
            return verifyAction(keyStr , isClose : true)
        }
    }
    
    private func setAction(keyStr : String) -> Bool {
        if tmpValue.isEmpty {
            tmpValue                = keyStr
            tipsText                = "再次绘制解锁图案"
        }else{
            if tmpValue == keyStr {
                GestureKeychain.addObject(userKey, value: keyStr.md5Format())
                tipsText            = "设置成功"
                delegate?.gesturePasswordSetResult(self)
            }else{
                tmpValue            = ""
                tipsText            = "两次密码不一致，请重新绘制"
                return false
            }
        }
        return true
    }
    
    private func verifyAction(keyStr : String , needSucc : Bool = true , isClose : Bool = false) -> Bool {
        if let val = GestureKeychain.getValueForKey(userKey)  where keyStr.md5Format() == val {
            if needSucc {
                delegate?.gesturePasswordVerifyResult(self)
            }
            if isClose {
                GestureKeychain.deleteObject(userKey)
            }
        }else{
            maxTimes--
            if maxTimes == 0 {
                delegate?.gesturePasswordForgot(self)
                GestureKeychain.deleteObject(userKey)
            }else{
                tipsText            = "手势密码错误，还可验证\(maxTimes)次"
                return false
            }
        }
        return true
    }
    
    private func showTips() {
        switch verifyStyle {
        case .Set:
            tipsText    = "绘制解锁图案"
        case .Change :
            tipsText    = "请输入原解锁图案"
        case .Verify :
            tipsText    = "验证手势密码"
        case .Close :
            tipsText    = "验证手势密码"
        }
    }
    
    @objc private func buttonAction() {
            GestureKeychain.deleteObject(userKey)
            delegate?.gesturePasswordForgot(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
