//
//  YRPageControl.swift
//  QminiFund
//
//  Created by zhangyr on 15/10/20.
//  Copyright © 2015年 quchaogu. All rights reserved.
//

import UIKit

enum YRPageType : Int {
    case Circle
    case Rectangle
    case DoubleCircle
}

@objc protocol YRPageControlDelegate : NSObjectProtocol {
   optional
    func pageControl(pageControl : YRPageControl , didSelectedPage page : Int)
}

class YRPageControl: UIView , YRPageItemDelegate {

    ///style for page control (default is .Circle)
    var pageControlStyle              : YRPageType     = .Circle {
        didSet {
            initAllItems()
        }
    }
    ///count of pages (default is 0)
    var numberOfPages                 : Int            = 0 {
        didSet {
            initAllItems()
        }
    }
    ///current page to show (default is 0)
    var currentPage                   : Int            = 0 {
        didSet {
            selectedItem()
        }
    }
    ///color for current page (default is whiteColor)
    var currentPageIndicatorTintColor : UIColor        =  UIColor.whiteColor()
    ///color for other page that not show now (default is lightGrayColor)
    var indicatorTintColor            : UIColor        =  UIColor.lightGrayColor()
    ///duration for animation (default is 0.2)
    var duration                      : NSTimeInterval = 0.2
    ///delegate for page control (comply with YRPageControlDelegate)
    weak var delegate                 : YRPageControlDelegate?
    ///size for rectangle (only for rectangle)
    var sizeOfRectangle               : CGSize         = CGSizeMake(16, 2) {
        didSet {
            initAllItems()
        }
    }
    ///radius for circle (only for circle)
    var radius                        : CGFloat        = 2.5 {
        didSet {
            initAllItems()
        }
    }
    ///space for each item (default is 2)
    var space                         : CGFloat        = 2 {
        didSet {
            initAllItems()
        }
    }
    ///outside circle color (only for double circle , default is white)
    var outsideColor                  : UIColor        = UIColor.whiteColor()
    ///pageControl enable (default is true)
    var pageControlEnabled            : Bool           = true
    
    
    func initAllItems() {
        
        currentPage = 0
        lastItem    = 0
        
        var width : CGFloat = 0
        
        switch pageControlStyle {
        case .Circle :
            width = CGFloat(numberOfPages) * radius * 2 + CGFloat(numberOfPages - 1) * space
        case .Rectangle :
            width = CGFloat(numberOfPages) * sizeOfRectangle.width + CGFloat(numberOfPages - 1) * space
        case .DoubleCircle :
            width = CGFloat(numberOfPages) * radius * 2 + CGFloat(numberOfPages - 1) * space
        }
        
        contentArray.removeAll(keepCapacity: false)
        
        if contentView != nil {
            
            for v in contentView.subviews {
                v.removeFromSuperview()
            }
        }else{
            contentView = UIView()
            self.addSubview(contentView)
        }
        
        contentView.mas_remakeConstraints({ (maker) -> Void in
            maker.centerX.equalTo()(self)
            maker.top.equalTo()(self)
            maker.bottom.equalTo()(self)
            maker.width.equalTo()(width)
        })
        
        addItem()
        
    }
    
    func addItem() {
        
        for i in 0 ..< numberOfPages {
            
            switch pageControlStyle {
            case .Circle :
                let cItem                 = YRPageCircleItem()
                cItem.didselectedColor    = currentPageIndicatorTintColor
                cItem.didNotSelectedColor = indicatorTintColor
                cItem.radius              = radius
                cItem.duration            = duration
                cItem.delegate            = self
                cItem.tag                 = i
                if i == currentPage {
                    cItem.didSelected()
                }else{
                    cItem.didNotSelected()
                }
                self.contentView.addSubview(cItem)
                cItem.mas_makeConstraints({ (maker) -> Void in
                    maker.left.equalTo()(self.contentView).offset()((self.radius * 2 + self.space) * CGFloat(i))
                    maker.centerY.equalTo()(self.contentView)
                    maker.width.equalTo()(self.radius * 2)
                    maker.height.equalTo()(self.radius * 2)
                })
                contentArray.append(cItem)
            case .Rectangle :
                let rItem                 = YRPageRectItem()
                rItem.didselectedColor    = currentPageIndicatorTintColor
                rItem.didNotSelectedColor = indicatorTintColor
                rItem.duration            = duration
                rItem.delegate            = self
                rItem.tag                 = i
                if i == currentPage {
                    rItem.didSelected()
                }else{
                    rItem.didNotSelected()
                }
                self.contentView.addSubview(rItem)
                rItem.mas_makeConstraints({ (maker) -> Void in
                    maker.left.equalTo()(self.contentView).offset()((self.sizeOfRectangle.width + self.space) * CGFloat(i))
                    maker.centerY.equalTo()(self.contentView)
                    maker.width.equalTo()(self.sizeOfRectangle.width)
                    maker.height.equalTo()(self.sizeOfRectangle.height)
                })
                contentArray.append(rItem)
            case .DoubleCircle :
                let dItem                 = YRPageDoubleCircleItem()
                dItem.didselectedColor    = currentPageIndicatorTintColor
                dItem.didNotSelectedColor = indicatorTintColor
                dItem.radius              = radius
                dItem.duration            = duration
                dItem.delegate            = self
                dItem.outsideColor        = outsideColor
                dItem.tag                 = i
                if i == currentPage {
                    dItem.didSelected()
                }else{
                    dItem.didNotSelected()
                }
                self.contentView.addSubview(dItem)
                dItem.mas_makeConstraints({ (maker) -> Void in
                    maker.left.equalTo()(self.contentView).offset()((self.radius * 2 + self.space) * CGFloat(i))
                    maker.centerY.equalTo()(self.contentView)
                    maker.width.equalTo()(self.radius * 2)
                    maker.height.equalTo()(self.radius * 2)
                })
                contentArray.append(dItem)
            }
            
            
        }
        
    }
    
    func selectedItem() {
        
        if currentPage == lastItem || currentPage >= contentArray.count {
            //print("错误位置")
            return
        }
        
        let item  = contentArray[currentPage]
        let oItem = contentArray[lastItem]
        item.didSelected()
        oItem.didNotSelected()
        lastItem  = currentPage
    }
    
    
    func pageItemClickWithTag(tag: Int) {
        if pageControlEnabled {
            delegate?.pageControl!(self, didSelectedPage: tag)
        }
    }
    
    private var contentView  : UIView!
    private var contentArray : Array<YRPageItem> = Array()
    private var lastItem     : Int               = 0
}
