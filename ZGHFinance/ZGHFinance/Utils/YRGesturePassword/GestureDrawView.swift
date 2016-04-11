//
//  GestureDrawView.swift
//  YRGesturePasswordView
//
//  Created by zhangyr on 16/1/12.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

protocol GestureDrawViewDelegate : NSObjectProtocol {
    
    /**
     手势绘制完成
     - parameter 回调参数: drawView:绘制手势视图,key:绘制密码串,timeInterval:绘制时间戳
     - returns: 是否清除当前绘制图案
     */
    func gestureDrawViewDidDrawn(drawView : GestureDrawView , keys : Array<Int> , timeInterval : Int) -> Bool
}

class GestureDrawView: UIView , GesturePointItemDelegate {
    
    ///手势点的直径
    lazy var itemWidth  : CGFloat   = 82 * SCALE_WIDTH_6
    ///是否可绘制
    lazy var canDraw    : Bool      = true
    ///划线颜色
    lazy var lineColor  : UIColor   = UIColor.whiteColor()//.colorWithAlphaComponent(0.6)
    ///划线宽度
    lazy var lineWidth  : CGFloat   = 3 * SCALE_WIDTH_6

    private var space   : CGFloat {
        return (self.bounds.width - 3 * itemWidth) / 2
    }
    private lazy var pointItems  : Array<GesturePointItem> = Array()
    private weak var delegate    : GestureDrawViewDelegate?
    private lazy var keys        : Array<Int>   = Array()
    
    init(frame: CGRect , delegate : GestureDrawViewDelegate) {
        super.init(frame: frame)
        self.delegate           = delegate
        self.backgroundColor    = UIColor.clearColor()
        initUI()
    }
    
    private func initUI() {
        
        let gr              = UIPanGestureRecognizer(target: self, action: #selector(GestureDrawView.panAction(_:)))
        self.addGestureRecognizer(gr)
        for i in 0 ... 8 {
            let item        = GesturePointItem(frame: CGRect(x: CGFloat(i % 3) * (itemWidth + space), y: CGFloat(i / 3) * (itemWidth + space), width: itemWidth, height: itemWidth), delegate: self)
            item.tag        = i
            self.addSubview(item)
            pointItems.append(item)
        }
    }
    
    func gesturePointItemSelected(item: GesturePointItem, tag: Int) {
        keys.append(tag)
    }
    
    @objc private func panAction(gr : UIGestureRecognizer) {
        if !canDraw {
            return
        }
        let state   =   gr.state
        let loc     =   gr.locationInView(self)
        switch state {
        case .Possible :
            checkPointInItem(loc)
            drawLine(loc, isBegan: false)
        case .Began :
            GesturePointItem.cancelAllItemsSelected()
            keys.removeAll()
            checkPointInItem(loc)
            drawLine(loc, isBegan: true)
        case .Changed :
            checkPointInItem(loc)
            drawLine(loc, isBegan: false)
        case .Ended :
            didEndDraw()
        case .Cancelled :
            didEndDraw()
        default :
            didEndDraw()
        }
    }
    
    private func didEndDraw() {
        if delegate!.gestureDrawViewDidDrawn(self, keys: keys, timeInterval: Int(NSDate().timeIntervalSince1970)) {
            keys.removeAll()
            GesturePointItem.cancelAllItemsSelected()
            currentPoint        = nil
            self.setNeedsDisplay()
        }else{
            GesturePointItem.errorItemsHighlight()
            canDraw             = false
            keys.removeAll()
            currentPoint        = nil
            self.setNeedsDisplay()
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                GesturePointItem.cancelAllItemsSelected()
                self.canDraw    = true
            })
        }
    }
    
    private func drawLine(point : CGPoint , isBegan : Bool) {
        currentPoint    = point
        self.setNeedsDisplay()
    }
    
    private var currentPoint : CGPoint!
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextClearRect(context, self.bounds)
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        CGContextSetLineWidth(context, lineWidth)
        if keys.count > 0 {
            let k       = keys.first!
            let first   = pointItems[k]
            CGContextMoveToPoint(context, first.center.x, first.center.y)
            if keys.count > 1 {
                for i in 1 ..< keys.count {
                    let k   = keys[i]
                    let tmp = pointItems[k]
                    CGContextAddLineToPoint(context, tmp.center.x, tmp.center.y)
                    CGContextMoveToPoint(context, tmp.center.x, tmp.center.y)
                }

            }
            if currentPoint != nil {
                CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y)
            }
            CGContextStrokePath(context)
            CGContextRestoreGState(context)
        }
    }
    
    private func checkPointInItem(point : CGPoint) {
        for item in pointItems {
            if CGRectContainsPoint(item.frame, point) {
                item.touchesMovedInItem()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class GestureShowView : UIView {
    
    var selectedArray        : Array<Int>    = Array() {
        didSet {
            for i in 0 ... 8 {
                let point               = points[i]
                point.backgroundColor   = unselectedColor
            }
            
            for index in selectedArray {
                let point               = points[index]
                point.backgroundColor   = selectedColor
            }
        }
    }
    
    lazy var pointWidth      : CGFloat       = 8 * SCALE_WIDTH_6
    lazy var selectedColor   : UIColor       = UIColor.whiteColor()
    lazy var unselectedColor : UIColor       = UIColor.whiteColor().colorWithAlphaComponent(0.2)
    
    private var space        : CGFloat {return (self.bounds.width - 3 * pointWidth) / 2}
    private lazy var points  : Array<UIView> = Array()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    private func initUI() {
        
        for i in 0 ... 8 {
            let point                   = UIView(frame: CGRect(x: CGFloat(i % 3) * (pointWidth + space), y: CGFloat(i / 3) * (pointWidth + space), width: pointWidth, height: pointWidth))
            point.tag                   = i
            point.layer.cornerRadius    = pointWidth / 2
            point.backgroundColor       = unselectedColor
            self.addSubview(point)
            points.append(point)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
