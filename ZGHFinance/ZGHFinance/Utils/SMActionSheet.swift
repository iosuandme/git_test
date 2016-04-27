//
//  SMActionSheet.swift
//  QminiFund
//
//  Created by zhangyr on 15/11/4.
//  Copyright © 2015年 cjxnfs. All rights reserved.
//

import UIKit

@objc protocol SMActionSheetDelegate : NSObjectProtocol {
    optional
    func SMAlertSheet(sheet : SMActionSheet , clickButtonAtIndex buttonIndex : Int)
}

class SMActionSheet: UIView {
    
    var cancelButtonIndex      : Int {return 0}
    var destructiveButtonIndex : Int {
        if destructiveButtonTitle == nil && destructiveButtonImage == nil {
            return -1
        }else{
            return 1
        }
    }
    var itemSpace              : CGFloat = 0
    var titleFontSize          : CGFloat = 10
    var titleColor             : UIColor = UtilTool.colorWithHexString("#a8a8a9")
    var sheetFontSize          : CGFloat = 12
    var sheetColor             : UIColor = UtilTool.colorWithHexString("#666")
    var bgColor                : UIColor = UtilTool.colorWithHexString("#ffffff")
    var lineColor              : UIColor = UtilTool.colorWithHexString("#ddd")
    var shadowColor            : UIColor = UtilTool.colorWithHexString("#0000007d")
    weak var delegate          : SMActionSheetDelegate?
    var title                  : String?
    var cancelButtonTitle      : String? {
        didSet {
            if cancelButtonImage != nil {
                var dic = _titleImages![0]
                dic["title"] = cancelButtonTitle
            }else{
                if cancelButtonTitle != nil {
                    if oldValue == nil {
                        let dic : [String : AnyObject?] = ["title" : cancelButtonTitle , "image" : cancelButtonImage]
                        if _titleImages == nil {
                            _titleImages = Array()
                        }
                        _titleImages?.insert(dic, atIndex: 0)
                    }else{
                        var dic = _titleImages![0]
                        dic["title"] = cancelButtonTitle
                    }
                }
            }
        }
    }
    var cancelButtonImage      : UIImage? {
        didSet {
            if cancelButtonTitle != nil {
                var dic = _titleImages![0]
                dic["image"] = cancelButtonImage
            }else{
                if cancelButtonImage != nil {
                    if oldValue == nil {
                        let dic : [String : AnyObject?] = ["title" : cancelButtonTitle , "image" : cancelButtonImage]
                        if _titleImages == nil {
                            _titleImages = Array()
                        }
                        _titleImages?.insert(dic, atIndex: 0)
                    }else{
                        var dic = _titleImages![0]
                        dic["image"] = cancelButtonImage
                    }
                }
            }
        }
    }
    var destructiveButtonTitle : String? {
        didSet {
            if destructiveButtonImage != nil {
                var dic = _titleImages!.last!
                dic["title"] = destructiveButtonTitle
            }else{
                if destructiveButtonTitle != nil {
                    if oldValue == nil {
                        let dic : [String : AnyObject?] = ["title" : destructiveButtonTitle , "image" : destructiveButtonImage]
                        if _titleImages == nil {
                            _titleImages = Array()
                        }
                        _titleImages?.append(dic)
                    }else{
                        var dic = _titleImages!.last!
                        dic["title"] = destructiveButtonTitle
                    }
                }
            }
        }
    }
    var destructiveButtonImage : UIImage? {
        didSet {
            if destructiveButtonTitle != nil {
                var dic = _titleImages!.last!
                dic["image"] = destructiveButtonImage
            }else{
                if destructiveButtonImage != nil {
                    if oldValue == nil {
                        let dic : [String : AnyObject?] = ["title" : destructiveButtonTitle , "image" : destructiveButtonImage]
                        if _titleImages == nil {
                            _titleImages = Array()
                        }
                        _titleImages?.append(dic)
                    }else{
                        var dic = _titleImages!.last!
                        dic["image"] = destructiveButtonImage
                    }
                }
            }
        }
    }
    
    private var _titleImages   : [[String : AnyObject?]]?
    private var _listView      : UIView?
    private var _shadowView    : UIView?
    private var _animationView : UIView?
    
    convenience init(title: String?, delegate: SMActionSheetDelegate?, cancelButtonTitle: String? , cancelButtonImage : UIImage? , destructiveButtonTitle: String? , destructiveImage : UIImage?) {
        self.init(frame : CGRectZero)
        self.title                  = title
        self.delegate               = delegate
        self.cancelButtonTitle      = cancelButtonTitle
        self.cancelButtonImage      = cancelButtonImage
        self.destructiveButtonTitle = destructiveButtonTitle
        self.destructiveButtonImage = destructiveImage
        
        if cancelButtonTitle != nil || cancelButtonImage != nil {
            _titleImages = Array()
            let dic : [String : AnyObject?] = ["title" : cancelButtonTitle , "image" : cancelButtonImage]
            _titleImages?.append(dic)
        }
        
        if destructiveButtonTitle != nil || destructiveImage != nil {
            if _titleImages == nil {
                _titleImages = Array()
            }
            let dic : [String : AnyObject?] = ["title" : destructiveButtonTitle , "image" : destructiveImage]
            _titleImages?.append(dic)
        }
        
    }
    
    convenience init(title: String?, delegate: SMActionSheetDelegate?, cancelButtonTitle: String?, cancelButtonImage : UIImage? , destructiveButtonTitle: String?,destructiveImage : UIImage?, moreButtonTitles: [String?]? , moreImages : [UIImage?]?) {
        self.init(title: title, delegate: delegate, cancelButtonTitle: cancelButtonTitle, cancelButtonImage : cancelButtonImage , destructiveButtonTitle: destructiveButtonTitle , destructiveImage : destructiveImage )
        //var tmpDic : [String : AnyObject?]?
        /*if destructiveButtonTitle != nil || destructiveImage != nil {
            if moreButtonTitles != nil || moreImages != nil {
                tmpDic = _titleImages?.last!
                _titleImages?.removeLast()
            }
        }*/
        
        if moreButtonTitles != nil && moreImages != nil {
            if moreButtonTitles?.count != moreImages?.count {
                return
            }
            if _titleImages == nil {
                _titleImages = Array()
            }
            for i in 0 ..< moreButtonTitles!.count {
                let dic : [String : AnyObject?] = ["title" : moreButtonTitles![i] , "image" : moreImages![i]]
                _titleImages?.append(dic)
            }
        }else if moreButtonTitles != nil {
            if _titleImages == nil {
                _titleImages = Array()
            }
            for i in 0 ..< moreButtonTitles!.count {
                let dic : [String : AnyObject?] = ["title" : moreButtonTitles![i] , "image" : nil]
                _titleImages?.append(dic)
            }
        }else if moreImages != nil {
            if _titleImages == nil {
                _titleImages = Array()
            }
            for i in 0 ..< moreImages!.count {
                let dic : [String : AnyObject?] = ["title" : nil , "image" : moreImages![i]]
                _titleImages?.append(dic)
            }
        }
        
        /*if tmpDic != nil {
            _titleImages?.append(tmpDic!)
        }*/
    }
    
    func addButtonWithTitle(title : String? , image : UIImage?) {
        
        if title == nil && image == nil {
            return
        }
        
        var tmpDic : [String : AnyObject?]?
        if destructiveButtonTitle != nil || destructiveButtonImage != nil {
                tmpDic = _titleImages?.last!
                _titleImages?.removeLast()
        }
        
        if _titleImages == nil {
            _titleImages = Array()
        }
        
        let dic : [String : AnyObject?] = ["title" : title , "image" : image]
        _titleImages?.append(dic)
        
        if tmpDic != nil {
            _titleImages?.append(tmpDic!)
        }
    }
    
    
    func showInView(targetView : UIView) {
        if _titleImages == nil || _titleImages?.count < 1 {
            return
        }
        
        let tuple = calculateHeights()
        
        self.frame = CGRect(x: 0, y: targetView.bounds.height - tuple.sh, width: targetView.bounds.width, height: tuple.sh)
        targetView.addSubview(self)
        
        _animationView = UIView(frame: CGRect(x: 0, y: tuple.sh, width: self.bounds.width, height: tuple.sh))
        self.addSubview(_animationView!)
        
        _listView                  = UIView()
        _listView?.backgroundColor = bgColor
        _listView?.layer.cornerRadius      = 5
        _listView?.layer.masksToBounds     = true
        
        _animationView?.addSubview(_listView!)
        _listView?.mas_makeConstraints { (maker) -> Void in
            maker.top.equalTo()(self._animationView).offset()(10)
            maker.left.equalTo()(self._animationView).offset()(20)
            maker.right.equalTo()(self._animationView).offset()(-20)
            maker.height.equalTo()(tuple.vh)
        }
        
        initUI()
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self._animationView?.frame = CGRect(x: 0, y: 0, width: targetView.bounds.width, height: tuple.sh)
            }, completion: nil)
        
    }
    
    func initUI() {
        
        var tmpBtn : UIButton?
        
        for i in 0 ..< _titleImages!.count {
            
            if (cancelButtonTitle != nil || cancelButtonImage != nil) && i == 0 {
                let btn = UIButton()
                btn.titleLabel?.font = UIFont.systemFontOfSize(sheetFontSize)
                btn.setTitleColor(sheetColor, forState: UIControlState.Normal)
                btn.setTitle(_titleImages![i]["title"] as? String, forState: UIControlState.Normal)
                btn.setImage(_titleImages![i]["image"] as? UIImage, forState: UIControlState.Normal)
                btn.backgroundColor = bgColor
                btn.addTarget(self, action: #selector(SMActionSheet.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                btn.tag = i
                btn.layer.cornerRadius  = 5
                btn.layer.masksToBounds = true
                if cancelButtonImage != nil && cancelButtonTitle != nil {
                    btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
                    btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
                }
                _animationView?.addSubview(btn)
                
                btn.mas_makeConstraints({ (maker) -> Void in
                    maker.left.equalTo()(self._animationView).offset()(20)
                    maker.right.equalTo()(self._animationView).offset()(-20)
                    maker.bottom.equalTo()(self._animationView).offset()(-10)
                    maker.height.equalTo()(40)
                })
            }else{
                
                var index = 1
                if cancelButtonTitle != nil || cancelButtonImage != nil {
                    index = 0
                }
                let btn              = UIButton()
                btn.titleLabel?.font = UIFont.systemFontOfSize(sheetFontSize)
                btn.setTitleColor(sheetColor, forState: UIControlState.Normal)
                btn.setTitle(_titleImages![i]["title"] as? String, forState: UIControlState.Normal)
                btn.setImage(_titleImages![i]["image"] as? UIImage, forState: UIControlState.Normal)
                btn.backgroundColor  = bgColor
                btn.addTarget(self, action: #selector(SMActionSheet.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                btn.tag              = i + index
                if _titleImages![i]["title"] != nil && _titleImages![i]["image"] is UIImage {
                    btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                    btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
                }
                self._listView?.addSubview(btn)
                
                btn.mas_makeConstraints({ (maker) -> Void in
                    maker.left.equalTo()(self._listView)
                    maker.right.equalTo()(self._listView)
                    if tmpBtn != nil {
                        maker.bottom.equalTo()(tmpBtn?.mas_top)
                    }else{
                        maker.bottom.equalTo()(self._listView)
                    }
                    maker.height.equalTo()(40)
                })
                
                if i != _titleImages!.count - 1 {
                    let line             = UILabel()
                    line.backgroundColor = lineColor
                    _animationView?.addSubview(line)
                    line.mas_makeConstraints({ (maker) -> Void in
                        maker.left.equalTo()(self._listView)
                        maker.right.equalTo()(self._listView)
                        maker.top.equalTo()(btn)
                        maker.height.equalTo()(0.5)
                    })
                }
                if i == 1 && (destructiveButtonTitle != nil || destructiveButtonImage != nil){
                    btn.setTitleColor(UtilTool.colorWithHexString("#ff6600"), forState: UIControlState.Normal)
                }
                tmpBtn = btn
            }
        }
        
        if title != nil {
            let titleLabel           = UILabel()
            titleLabel.font          = UIFont.systemFontOfSize(titleFontSize)
            titleLabel.textColor     = titleColor
            titleLabel.textAlignment = .Center
            titleLabel.text          = title
            self._listView?.addSubview(titleLabel)
            
            titleLabel.mas_makeConstraints({ (maker) -> Void in
                maker.top.equalTo()(self._listView).offset()(10)
                maker.left.equalTo()(self._listView).offset()(10)
                maker.right.equalTo()(self._listView).offset()(-10)
                maker.height.equalTo()(self.titleFontSize + 2)
            })
            
            let line             = UILabel()
            line.backgroundColor = lineColor
            self.addSubview(line)
            line.mas_makeConstraints({ (maker) -> Void in
                maker.left.equalTo()(titleLabel)
                maker.right.equalTo()(titleLabel)
                maker.bottom.equalTo()(titleLabel).offset()(10)
                maker.height.equalTo()(0.5)
            })
        }
    }
    
    func buttonClick(btn : UIButton) {
        
        delegate?.SMAlertSheet!(self, clickButtonAtIndex: btn.tag)
        dismissView(false)
    }
    
    private func dismissView(needCallBack : Bool = true) {
        
        let tuple = calculateHeights()
        if needCallBack {
            delegate?.SMAlertSheet!(self, clickButtonAtIndex: cancelButtonIndex)
        }
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self._animationView?.frame.origin.y += tuple.sh
            }){ (Bool) -> Void in
                self.removeFromSuperview()
        }
    }
    
    private func calculateHeights() ->(sh : CGFloat , vh : CGFloat)  {
        
        var height  : CGFloat = 0
        var vHeight : CGFloat = 0
        
        if title != nil {
            height  += 20 + titleFontSize + 2
        }
        
        if _titleImages != nil && _titleImages?.count > 0 {
            var c = 1
            if cancelButtonTitle != nil || cancelButtonImage != nil && _titleImages?.count > 1 {
                c = 2
            }
            height += 40 * CGFloat(_titleImages!.count) + itemSpace * CGFloat(_titleImages!.count - c)
        }
        
        vHeight = height
        
        if cancelButtonTitle != nil || cancelButtonImage != nil {
            height  += 10
            vHeight -= 40
        }
        
        height += 20
        return (height , vHeight)
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let v = super.hitTest(point, withEvent: event)
        if v == nil {
            dismissView()
        }
        return v
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _shadowView                  = UIView()
        _shadowView?.backgroundColor = shadowColor
        self.addSubview(_shadowView!)
        _shadowView?.mas_makeConstraints({ (maker) -> Void in
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
            maker.bottom.equalTo()(self)
            maker.height.equalTo()(SCREEN_HEIGHT)
        })
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
