//
//  GesturePointItem.swift
//  YRGesturePasswordView
//
//  Created by zhangyr on 16/1/11.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

private var CANCEL_SELECTED_NOTIFICATION    = "cancelSelectedNoti"
private var HIGHLIGHT_SELECTED_NOTIFICATION = "highlightSelectedNoti"
let SCALE_WIDTH_6                           = UIScreen.mainScreen().bounds.width / 375
let SCALE_HEIGHT_6                          = UIScreen.mainScreen().bounds.height / 667

protocol GesturePointItemDelegate : NSObjectProtocol {
    /**
     被选中的手势点回调
     - parameter 回调参数: item:手势点 , tag:手势点tag
     - returns: 无
     */
    func gesturePointItemSelected(item : GesturePointItem , tag : Int)
}

class GesturePointItem: UIView {

    ///被选中颜色
    lazy var selectedColor          : UIColor   = UIColor.whiteColor().colorWithAlphaComponent(0.2)
    ///未被选中颜色
    lazy var unselectedColor        : UIColor   = UIColor.clearColor()
    ///中心选中半径
    lazy var centerRadius           : CGFloat   = 10 * SCALE_WIDTH_6
    ///中心选中颜色
    lazy var centerColor            : UIColor   = UIColor.whiteColor()
    ///边框宽度
    lazy var borderWidth            : CGFloat   = 2 * SCALE_WIDTH_6
    ///边框颜色
    lazy var borderColor            : UIColor   = UIColor.whiteColor()
    ///错误颜色
    lazy var errorColor             : UIColor   = UtilTool.colorWithHexString("#ec3d4b")
    
    private lazy var hasSelected    : Bool      = false
    private weak var delegate       : GesturePointItemDelegate?
    
    private var centerCircle        : UIView?
    
    /**
     取消所有手势点的选择
     - parameter 参数:无
     - returns:无
     */
    class func cancelAllItemsSelected() {
        NSNotificationCenter.defaultCenter().postNotificationName(CANCEL_SELECTED_NOTIFICATION, object: nil)
    }
    
    class func errorItemsHighlight() {
        NSNotificationCenter.defaultCenter().postNotificationName(HIGHLIGHT_SELECTED_NOTIFICATION, object: nil)
    }
    
    /**
     手势触发
     - parameter 参数:无
     - returns:无
     */
    func touchesMovedInItem() {
        touchesAction()
    }
    
    init(frame: CGRect , delegate : GesturePointItemDelegate) {
        super.init(frame: frame)
        self.delegate   = delegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cancelSelected", name: CANCEL_SELECTED_NOTIFICATION, object: nil)
        initUI()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private func initUI() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderWidth  = borderWidth
        self.layer.borderColor  = borderColor.CGColor
        
        centerCircle                     = UIView(frame: CGRect(x: 0, y: 0, width: 2 * centerRadius, height: 2 * centerRadius))
        centerCircle?.layer.cornerRadius = centerRadius
        centerCircle?.center             = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        centerCircle?.backgroundColor    = unselectedColor
        self.addSubview(centerCircle!)
    }
    
    private func touchesAction() {
        if !hasSelected {
            hasSelected                     = true
            self.backgroundColor            = selectedColor
            centerCircle?.backgroundColor   = centerColor
            delegate?.gesturePointItemSelected(self, tag: self.tag)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "errorSelected", name: HIGHLIGHT_SELECTED_NOTIFICATION, object: nil)
        }
    }
    
    @objc private func cancelSelected() {
        hasSelected                     = false
        self.backgroundColor            = unselectedColor
        self.layer.borderColor          = borderColor.CGColor
        centerCircle?.backgroundColor   = unselectedColor
        NSNotificationCenter.defaultCenter().removeObserver(self, name: HIGHLIGHT_SELECTED_NOTIFICATION, object: nil)
    }
    
    @objc private func errorSelected() {
        centerCircle?.backgroundColor   = errorColor
        self.backgroundColor            = errorColor.colorWithAlphaComponent(0.2)
        self.layer.borderColor          = errorColor.CGColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
