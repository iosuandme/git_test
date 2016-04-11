//
//  HomeRollImageView.swift
//  quchaogu
//
//  Created by zhangyr on 15/7/6.
//  Copyright (c) 2015年 quchaogu. All rights reserved.
//  轮播图视图

import UIKit

@objc protocol HomeRollImageViewDelegate : NSObjectProtocol {
    
    optional
    func touchImageInHomeForParam(target : String , link_url : String , link_title : String)
    
}

class HomeRollImageView: UIView , UIScrollViewDelegate {
    
    private var images        : [Dictionary<String,AnyObject>]!
    private var pageControl   : YRPageControl!
    var timer                 : NSTimer!
    private var scrollView    : UIScrollView!
    private weak var delegate : HomeRollImageViewDelegate?

    init(frame : CGRect , delegate : HomeRollImageViewDelegate?) {
        super.init(frame: frame)
        self.delegate = delegate
        self.backgroundColor = UIColor.clearColor()
        if scrollView == nil {
            scrollView = UIScrollView()
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator   = false
            scrollView.delegate                       = self
            scrollView.pagingEnabled                  = true
            self.addSubview(scrollView)
            scrollView.mas_makeConstraints({ (maker) -> Void in
                maker.left.equalTo()(self)
                maker.top.equalTo()(self)
                maker.bottom.equalTo()(self)
                maker.right.equalTo()(self)
            })
        }
    }
    
    
    func showScrollView(imageArr : [Dictionary<String,AnyObject>]) {
        
        images = imageArr
        if images == nil || images.count == 0 {
            return
        }
        
        removeTimer()
        if scrollView != nil {
            scrollView.delegate      = self
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
            for v in scrollView.subviews {
                if v is UIImageView || v is BaseButton {
                    v.removeFromSuperview()
                }
            }
        }
        
        scrollView.contentSize                    = CGSizeMake(CGFloat(images.count + 1) * SCREEN_WIDTH, 0)
        var tmpView : UIView!
        for i in 0 ..< images.count {
            let img = UIImageView()
            if images[i].count == 1 {
                img.image               = UIImage(named: images[i]["imgName"] + "")
            }else{
                img.sd_setImageWithURL(NSURL(string: images[i]["img_url"] + ""), placeholderImage: nil)
            }
            let btn = BaseButton()
            btn.tag = i
            btn.addTarget(self, action: #selector(HomeRollImageView.nextImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            scrollView.addSubview(img)
            scrollView.addSubview(btn)
            if tmpView != nil {
                img.mas_makeConstraints({ (maker) -> Void in
                    maker.left.equalTo()(tmpView.mas_right)
                    maker.top.equalTo()(self.scrollView)
                    maker.height.equalTo()(self.scrollView)
                    maker.width.equalTo()(SCREEN_WIDTH)
                })
            }else{
                img.mas_makeConstraints({ (maker) -> Void in
                    maker.left.equalTo()(self.scrollView)
                    maker.top.equalTo()(self.scrollView)
                    maker.height.equalTo()(self.scrollView)
                    maker.width.equalTo()(SCREEN_WIDTH)
                })
            }
            tmpView = img
            btn.mas_makeConstraints({ (maker) -> Void in
                maker.top.equalTo()(img)
                maker.left.equalTo()(img)
                maker.bottom.equalTo()(img)
                maker.right.equalTo()(img)
            })
        }
        let img                     = UIImageView()
        if images[0].count == 1 {
            img.image               = UIImage(named: images[0]["imgName"] + "")
        }else{
            img.sd_setImageWithURL(NSURL(string: images[0]["img_url"] + ""), placeholderImage: nil)
        }
        let btn                     = BaseButton()
        btn.tag                     = images.count
        btn.addTarget(self, action: #selector(HomeRollImageView.touchImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        scrollView.addSubview(img)
        scrollView.addSubview(btn)
        img.mas_makeConstraints({ (maker) -> Void in
            maker.left.equalTo()(tmpView.mas_right)
            maker.top.equalTo()(self.scrollView)
            maker.height.equalTo()(self.scrollView)
            maker.width.equalTo()(SCREEN_WIDTH)
        })
        btn.mas_makeConstraints({ (maker) -> Void in
            maker.left.equalTo()(img)
            maker.top.equalTo()(img)
            maker.bottom.equalTo()(img)
            maker.right.equalTo()(img)
        })
        if pageControl == nil {
            pageControl                               = YRPageControl()
            self.addSubview(pageControl)
            pageControl.mas_makeConstraints({ (maker) -> Void in
                maker.centerX.equalTo()(self.scrollView)
                maker.height.equalTo()(10)
                maker.bottom.equalTo()(self).offset()(-8)
                maker.width.equalTo()(CGFloat(self.images.count * 20))
            })
        }
        pageControl.numberOfPages                 = images.count
        pageControl.currentPage                   = 0
        pageControl.currentPageIndicatorTintColor = UtilTool.colorWithHexString("#ffffff")
        pageControl.indicatorTintColor            = UtilTool.colorWithHexString("#ffffff80")
        pageControl.pageControlEnabled            = false
        pageControl.space                         = 5
        pageControl.pageControlStyle              = .DoubleCircle
        pageControl.radius                        = 6
        addTimer()
    }
    
    func touchImage(btn : BaseButton) {
        
        var dic : Dictionary<String,AnyObject>!
        if btn.tag == images.count {
            dic = images[0]
        }else{
            dic = images[btn.tag]
        }
        delegate?.touchImageInHomeForParam?(dic["action"] + "", link_url: dic["link_url"] + "", link_title: dic["link_title"] + "")
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x > CGFloat(images.count) * scrollView.frame.size.width {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }else if scrollView.contentOffset.x < 0 {
            scrollView.contentOffset = CGPointMake(CGFloat(images.count - 1) * scrollView.frame.size.width + scrollView.frame.size.width / 2 - 0.5, 0)
        }
        let scrollviewW:CGFloat      = scrollView.frame.size.width;
        let x:CGFloat                = scrollView.contentOffset.x + 0.5;
        let page:Int                 = (Int)((x + scrollviewW / 2) / scrollviewW);
        self.pageControl.currentPage = page;
        if page >= images.count {
            self.pageControl.currentPage = 0
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    func addTimer(){
        
        if timer == nil {
            timer = NSTimer(timeInterval: 5, target: self, selector: #selector(HomeRollImageView.nextImage(_:)), userInfo: nil, repeats: true)
        }
        
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func removeTimer(){
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func nextImage(sender:AnyObject!){
        var page = self.pageControl.currentPage
        page += 1
        let x = CGFloat(page) * scrollView.frame.size.width
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.scrollView.contentOffset = CGPointMake(x, 0)
            }) { (Bool) -> Void in
                if page == self.images.count {
                    self.scrollView.contentOffset = CGPointMake(0, 0)
                    self.pageControl.currentPage  = 0
                }
        }
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
