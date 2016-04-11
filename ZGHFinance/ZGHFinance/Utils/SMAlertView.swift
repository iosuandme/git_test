//
//  SMAlertView.swift
//  QminiFund
//
//  Created by zhangyr on 15/10/29.
//  Copyright © 2015年 cjxnfs. All rights reserved.
//

import UIKit

@objc protocol SMAlertViewDelegate : NSObjectProtocol {
    
    optional
    func smAlert(alert : SMAlertView , clickButtonAtIndex buttonIndex : Int)
    optional
    func smAlert(alert : SMAlertView , colorForButtonAtIndex buttonIndex : Int) -> UIColor
    optional
    func smAlert(alert : SMAlertView , enabledButtonAtIndex buttonIndex : Int) -> Bool
}

class SMAlertView: UIView , UITextViewDelegate {
    
    var cancelButtonIndex      : Int { return 0 }
    var needAnimated           : Bool            = true
    var shadowColor            : UIColor         = UtilTool.colorWithHexString("#0000007d")
    var bgColor                : UIColor         = UtilTool.colorWithHexString("#ffffff")
    var titleFontSize          : CGFloat         = 18
    var titleColor             : UIColor         = UtilTool.colorWithHexString("#666")
    var messageFontSize        : CGFloat         = 12
    var messageColor           : UIColor         = UtilTool.colorWithHexString("#999")
    var lineColor              : UIColor         = UtilTool.colorWithHexString("#eee")
    var textAlignment          : NSTextAlignment = .Center
    var lineSpace              : CGFloat         = 3
    var buttonColor            : UIColor         = UtilTool.colorWithHexString("#523a81")
    
    var title                  : String?
    var message                : String?
    weak var delegate          : SMAlertViewDelegate?
    var cancelButtonTitle      : String? {
        didSet {
            if oldValue != nil && cancelButtonTitle != nil {
                _btnArray![0] = cancelButtonTitle!
            }else{
                if cancelButtonTitle != nil {
                    if _btnArray == nil {
                        _btnArray = Array()
                    }
                    _btnArray?.insert(cancelButtonTitle!, atIndex: 0)
                }else{
                    _btnArray?.removeAtIndex(0)
                }
            }
        }
    }
    
    private var _btnArray      : Array<String>?
    private var _shadowView    : UIView?
    private var _titleLabel    : UILabel?
    private var _messageLabel  : UITextView?
    private var _tmpLine       : UILabel?
    private var _paragraphS    : NSMutableParagraphStyle?

    convenience init(title: String?, message: String?, delegate: SMAlertViewDelegate?, cancelButtonTitle: String?) {
        self.init(frame : CGRectZero)
        self.title             = title
        self.message           = message
        self.delegate          = delegate
        self.cancelButtonTitle = cancelButtonTitle
        if cancelButtonTitle != nil {
            _btnArray?.removeAll(keepCapacity: false)
            if _btnArray == nil {
                _btnArray = Array()
            }
            _btnArray?.append(cancelButtonTitle!)
        }
    }
    
    convenience init(title: String, message: String, delegate: SMAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitles firstButtonTitle: String, _ moreButtonTitles: String...) {
        self.init(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle)
        if _btnArray == nil {
            _btnArray = Array()
        }
        _btnArray?.append(firstButtonTitle)
        for t in moreButtonTitles {
            _btnArray?.append(t)
        }
    }
    
    func addButtonWithTitle(title : String) {
        if _btnArray == nil {
            _btnArray = Array()
        }
        _btnArray?.append(title)
    }
    
    func show() {
        initUI()
        _shadowView?.alpha = 0
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            UtilTool.getAppDelegate().window?.addSubview(self._shadowView!)
            if self.needAnimated {
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self._shadowView?.alpha = 1
                    }, completion: nil)
            }else{
                self._shadowView?.alpha = 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _paragraphS              = NSMutableParagraphStyle()
        _paragraphS?.lineSpacing = lineSpace
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        if title == nil && message == nil {
            return
        }
        _shadowView                  = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        _shadowView?.backgroundColor = shadowColor
        self.layer.cornerRadius      = 3
        self.layer.masksToBounds     = true
        self.backgroundColor         = bgColor
        
        if title != nil {
            _titleLabel                = UILabel()
            _titleLabel?.font          = UIFont.systemFontOfSize(titleFontSize)
            _titleLabel?.textColor     = titleColor
            _titleLabel?.textAlignment = textAlignment
            _titleLabel?.numberOfLines = 2
            _titleLabel?.text          = title
            self.addSubview(_titleLabel!)
            
            _titleLabel?.mas_makeConstraints({ (maker) -> Void in
                maker.left.equalTo()(self).offset()(20)
                maker.right.equalTo()(self).offset()(-20)
                maker.top.equalTo()(self).offset()(10)
                maker.height.greaterThanOrEqualTo()(self.titleFontSize)
            })
            
            if message != nil || _btnArray?.count > 0 {
                let line  = UILabel()
                line.backgroundColor = lineColor
                line.hidden          = true
                self.addSubview(line)
                
                line.mas_makeConstraints({ (maker) -> Void in
                    maker.left.equalTo()(self).offset()(10)
                    maker.right.equalTo()(self).offset()(-10)
                    maker.top.equalTo()(self._titleLabel?.mas_bottom)
                    maker.height.equalTo()(0.5)
                })
                _tmpLine = line
            }
        }
        
        if message != nil {
            _messageLabel                         = UITextView()
            _messageLabel?.font                   = UIFont.systemFontOfSize(messageFontSize)
            _messageLabel?.backgroundColor        = UIColor.clearColor()
            _messageLabel?.editable               = true
            _messageLabel?.delegate               = self
            _messageLabel?.attributedText         = NSAttributedString(string: message!, attributes: [NSFontAttributeName : _messageLabel!.font! , NSParagraphStyleAttributeName : _paragraphS! ,NSForegroundColorAttributeName : messageColor])
            _messageLabel?.textContainer.lineFragmentPadding = 0
            self.addSubview(_messageLabel!)
            
            let size    = _messageLabel!.sizeThatFits(CGSize(width: SCREEN_WIDTH - 130, height: messageFontSize * 10))
            //height += size.height + 30 + 1
            
//            let tempStr = message?.stringByReplacingOccurrencesOfString("\n", withString: "")
//            let r    = (tempStr! as NSString).boundingRectWithSize(CGSize(width: SCREEN_WIDTH - 130, height: 999), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : _messageLabel!.font!], context: nil)
//            let rect = (tempStr! as NSString).boundingRectWithSize(CGSize(width: SCREEN_WIDTH - 130, height: messageFontSize * 10), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : _messageLabel!.font!], context: nil)
            let lNum = Int(size.height) / Int(messageFontSize) + message!.countSubString("\n")
            //let sp   = CGFloat( lNum - 1) * (lineSpace + 1)
            /*_messageLabel?.textContainer.size = CGSize(width: rect.width, height: rect.height + sp)*/
            //_messageLabel?.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            if lNum > 2 {
                _messageLabel?.textAlignment = .Left
            }else{
                _messageLabel?.textAlignment = .Center
            }
            
            _messageLabel?.scrollEnabled     = size.height >= messageFontSize * 10
            
            _messageLabel?.mas_makeConstraints({ (maker) -> Void in
                maker.left.equalTo()(self).offset()(20)
                maker.right.equalTo()(self).offset()(-20)
                if self._tmpLine == nil {
                    maker.top.equalTo()(self).offset()(15)
                }else{
                    maker.top.equalTo()(self._tmpLine).offset()(15)
                }
                maker.height.equalTo()(size.height)
            })
            
            if _btnArray?.count > 0 {
                let line  = UILabel()
                line.backgroundColor = lineColor
                self.addSubview(line)
                
                line.mas_makeConstraints({ (maker) -> Void in
                    maker.left.equalTo()(self)
                    maker.right.equalTo()(self)
                    maker.top.equalTo()(self._messageLabel?.mas_bottom).offset()(15)
                    maker.height.equalTo()(0.5)
                })
                _tmpLine = line
            }
        }
        
        if _btnArray?.count > 0 {
            
            if _btnArray?.count == 1 {
                let btn = UIButton()
                btn.setTitleColor(buttonColor, forState: UIControlState.Normal)
                btn.setTitle(_btnArray![0], forState: UIControlState.Normal)
                if cancelButtonTitle != nil {
                    btn.tag              = 0
                    btn.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
                }else{
                    btn.tag              = 1
                    btn.titleLabel?.font = UIFont.systemFontOfSize(15)
                }
                btn.addTarget(self, action: #selector(SMAlertView.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(btn)
                btn.mas_makeConstraints({ (maker) -> Void in
                    maker.left.equalTo()(self)
                    maker.right.equalTo()(self)
                    maker.bottom.equalTo()(self)
                    maker.height.equalTo()(36)
                })
            }else if _btnArray?.count == 2 {
                
                for i in 0 ..< _btnArray!.count {
                    
                    let btn = UIButton()
                    btn.setTitleColor(buttonColor, forState: UIControlState.Normal)
                    btn.setTitle(_btnArray![i], forState: UIControlState.Normal)
                    btn.titleLabel?.font = UIFont.systemFontOfSize(15)
                    if cancelButtonTitle != nil {
                        btn.tag              = i
                        if i == 0 {
                            btn.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
                        }
                    }else{
                        btn.tag              = i + 1
                    }
                    btn.addTarget(self, action: #selector(SMAlertView.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    self.addSubview(btn)
                    let width = (SCREEN_WIDTH - 90) / 2
                    btn.mas_makeConstraints({ (maker) -> Void in
                        maker.left.equalTo()(self).offset()(CGFloat(i) * width)
                        maker.width.equalTo()(width)
                        maker.top.equalTo()(self._tmpLine?.mas_bottom)
                        maker.height.greaterThanOrEqualTo()(36)
                        maker.bottom.equalTo()(self)
                    })
                }
                let line  = UILabel()
                line.backgroundColor = lineColor
                self.addSubview(line)
                line.mas_makeConstraints({ (maker) -> Void in
                    maker.centerX.equalTo()(self)
                    maker.width.equalTo()(0.5)
                    maker.top.equalTo()(self._tmpLine?.mas_bottom)
                    maker.bottom.equalTo()(self)
                })
            }else{
                
                for j in 0 ..< _btnArray!.count {
                    
                    let i = _btnArray!.count - j
                    let btn = UIButton()
                    btn.setTitleColor(buttonColor, forState: UIControlState.Normal)
                    btn.setTitle(_btnArray![i-1], forState: UIControlState.Normal)
                    btn.titleLabel?.font = UIFont.systemFontOfSize(15)
                    if cancelButtonTitle != nil {
                        btn.tag              = i - 1
                        if i == 1 {
                            btn.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
                        }
                    }else{
                        btn.tag              = i
                    }
                    btn.addTarget(self, action: #selector(SMAlertView.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                    self.addSubview(btn)
                    btn.mas_makeConstraints({ (maker) -> Void in
                        maker.left.equalTo()(self)
                        maker.right.equalTo()(self)
                        maker.top.equalTo()(self._tmpLine?.mas_bottom)
                        maker.height.equalTo()(36)
                    })
                    
                    if i != 1 {
                        let line  = UILabel()
                        line.backgroundColor = lineColor
                        self.addSubview(line)
                        
                        line.mas_makeConstraints({ (maker) -> Void in
                            maker.left.equalTo()(self)
                            maker.right.equalTo()(self)
                            maker.top.equalTo()(btn.mas_bottom)
                            maker.height.equalTo()(0.5)
                        })
                        _tmpLine = line
                    }
                }
            }
        }
        _shadowView?.addSubview(self)
        self.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self._shadowView).offset()(45)
            maker.right.equalTo()(self._shadowView).offset()(-45)
            maker.centerY.equalTo()(self._shadowView)
            maker.height.equalTo()(self.calculateHeight())
        }
    }
    
    func buttonClick(btn : UIButton) {
        delegate?.smAlert!(self, clickButtonAtIndex: btn.tag)
        self._shadowView?.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    private func calculateHeight() -> CGFloat {
        
        var height : CGFloat = 0
        if title != nil {
            let rect = (title! as NSString).boundingRectWithSize(CGSize(width: SCREEN_WIDTH - 130, height: titleFontSize * 3 - 1), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : _titleLabel!.font], context: nil)
            height += rect.height + 10 + 1
        }
        
        if message != nil {
            //let tempStr = message?.stringByReplacingOccurrencesOfString("\n", withString: "")
            let size    = _messageLabel!.sizeThatFits(CGSize(width: SCREEN_WIDTH - 130, height: messageFontSize * 10))
            //let rect = (tempStr! as NSString).boundingRectWithSize(CGSize(width: SCREEN_WIDTH - 130, height: messageFontSize * 10), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : _messageLabel!.font! , NSParagraphStyleAttributeName : _paragraphS! ,NSForegroundColorAttributeName : messageColor], context: nil)
            //let sp   = CGFloat(Int(size.height) / Int(messageFontSize) + message!.countSubString("\n") - 1) * (lineSpace + 1)
            height += size.height + 30 + 1 //+ sp
        }
        
        if _btnArray?.count > 0 {
            if _btnArray?.count > 2 {
                height += CGFloat(_btnArray!.count * 36) + CGFloat(_btnArray!.count - 1)
            }else{
                height += 36
            }
        }
        return height
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
    }
}
