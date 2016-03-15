//
//  RefreshBaseView.swift
//  RefreshExample
//
//  Created by zhangyr on 15/5/7.
//  Copyright (c) 2015年 cjxnfs. All rights reserved.
//
//  下拉刷新控件
//
import UIKit

//控件的刷新状态
enum RefreshState {
    case  Pulling               // 松开就可以进行刷新的状态
    case  Normal                // 普通状态
    case  Refreshing            // 正在刷新中的状态
    case  WillRefreshing
}

//控件的类型
enum RefreshViewType {
    case  TypeHeader             // 头部控件
    case  TypeFooter             // 尾部控件
}
let RefreshLabelTextColor:UIColor = UtilTool.colorWithHexString("#666")


class RefreshBaseView: UIView {
    
 
    //  父控件
    var scrollView:UIScrollView!
    var scrollViewOriginalInset:UIEdgeInsets!
    
    // 内部的控件
    var statusLabel:UILabel!
    var arrowImage:UIImageView!
    var activityView:UIActivityIndicatorView!
    
    //回调
    var beginRefreshingCallback:(()->Void)?
    
    // 交给子类去实现 和 调用
    var  oldState:RefreshState?
    
    var State:RefreshState = RefreshState.Normal{
    willSet{
    }
    didSet{
        
    }
    
    }
    
    func setState(newValue:RefreshState){
        
        
        if self.State != RefreshState.Refreshing {
            
            scrollViewOriginalInset = self.scrollView.contentInset;
        }
        if self.State == newValue {
            return
        }
        switch newValue {
        case .Normal:
            self.arrowImage.hidden = false
            self.activityView.stopAnimating()
            break
        case .Pulling:
            break
        case .Refreshing:
            self.arrowImage.hidden = true
            activityView.startAnimating()
            beginRefreshingCallback!()
            break
        default:
            break
            
        }


    }
    
    
    //控件初始化
    init(frame: CGRect , needTop : Bool = false) {
        super.init(frame: frame)
       
        
        //状态标签
        statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        statusLabel.center = CGPointMake((frame.size.width - 60) / 2, 10)
        //statusLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        statusLabel.font = UIFont(name: "AvenirNext-Bold", size: 10)
        statusLabel.textColor = RefreshLabelTextColor
        statusLabel.backgroundColor =  UIColor.clearColor()
        statusLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(statusLabel)
        //箭头图片
        arrowImage = UIImageView(frame: CGRectMake(statusLabel.frame.minX,0, 20, 20))
        //arrowImage.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        arrowImage.center = CGPointMake((frame.size.width - 60) / 2 - 30, 10)
        self.addSubview(arrowImage)
        //状态标签
        activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.color = RefreshLabelTextColor
        activityView.frame = arrowImage.frame
        activityView.transform  = CGAffineTransformMakeScale(0.7, 0.7)
        //activityView.autoresizingMask = self.arrowImage.autoresizingMask
        self.addSubview(activityView)
         //自己的属性
        //self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
        //设置默认状态
        self.State = RefreshState.Normal;
        
        if needTop {
            //initIntroView()
        }
        
    }
    
    /*private func initIntroView() {
        let introView       = UIView()
        
        let iv1             = MainIntroduceView()
        let idata1          = IntroduceData()
        idata1.icon         = "main_intro_high_profit"
        idata1.title        = "超高收益"
        idata1.desc         = "10%活期利率\n收益自动复投"
        iv1.introData       = idata1
        
        let iv2             = MainIntroduceView()
        let idata2          = IntroduceData()
        idata2.icon         = "main_intro_less_danger"
        idata2.title        = "绝低风险"
        idata2.desc         = "最高20%\n安全保障金"
        iv2.introData       = idata2
        
        let iv3             = MainIntroduceView()
        let idata3          = IntroduceData()
        idata3.icon         = "main_intro_back_faster"
        idata3.title        = "随时支取"
        idata3.desc         = "随时赎回\n提现一天到账"
        iv3.introData       = idata3
        
        self.addSubview(introView)
        introView.addSubview(iv1)
        introView.addSubview(iv2)
        introView.addSubview(iv3)
        
        introView.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self)
            maker.width.equalTo()(self)
            maker.bottom.equalTo()(self.statusLabel.mas_top).offset()(-10)
            maker.height.equalTo()(88)
        }
        
        iv1.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(introView)
            maker.top.equalTo()(introView)
            maker.width.equalTo()(SCREEN_WIDTH / 3)
            maker.height.equalTo()(introView)
        }
        
        iv2.mas_makeConstraints { (maker) -> Void in
            maker.centerX.equalTo()(introView)
            maker.top.equalTo()(introView)
            maker.width.equalTo()(SCREEN_WIDTH / 3)
            maker.height.equalTo()(introView)
        }
        
        iv3.mas_makeConstraints { (maker) -> Void in
            maker.right.equalTo()(introView)
            maker.top.equalTo()(introView)
            maker.width.equalTo()(SCREEN_WIDTH / 3)
            maker.height.equalTo()(introView)
        }
    }*/

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
         //箭头
        if self is RefreshFooterView {
            let arrowX = self.frame.size.width * 0.5 - 80
            self.arrowImage.center = CGPointMake(arrowX, self.frame.size.height * 0.5)
        }
        
        //指示器
        self.activityView.center = self.arrowImage.center
    }
    
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
        // 旧的父控件
         
        if (self.superview != nil) {
            self.superview?.removeObserver(self,forKeyPath:RefreshContentOffset as String,context: nil)
            
            }
        // 新的父控件
        if (newSuperview != nil) {
            newSuperview.addObserver(self, forKeyPath: RefreshContentOffset as String, options: NSKeyValueObservingOptions.New, context: nil)
            var rect:CGRect = self.frame
            // 设置宽度   位置
            rect.size.width = newSuperview.frame.size.width
            rect.origin.x = 0
            self.frame = frame;
            //UIScrollView
            scrollView = newSuperview as! UIScrollView
            scrollViewOriginalInset = scrollView.contentInset;
        }
    }
    
    //显示到屏幕上
    override func drawRect(rect: CGRect) {
        self.superview!.drawRect(rect)
        if self.State == RefreshState.WillRefreshing {
            self.State = RefreshState.Refreshing
        }
    }
    
    // 刷新相关
    // 是否正在刷新
    func isRefreshing()->Bool{
        return RefreshState.Refreshing == self.State;
    }
    
    // 开始刷新
    func beginRefreshing(){
        // self.State = RefreshState.Refreshing;
        if (self.window != nil) {
            self.State = RefreshState.Refreshing;
        } else {
            //不能调用set方法
            State = RefreshState.WillRefreshing;
            super.setNeedsDisplay()
        }
        
    }
    
    //结束刷新
    func endRefreshing(){
        let delayInSeconds:Double = 0.3
        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds));
        
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.State = RefreshState.Normal;
            })
    }
}







