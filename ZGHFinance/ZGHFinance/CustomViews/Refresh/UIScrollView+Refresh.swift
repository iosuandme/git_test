//
//  UIScrollView+Refresh.swift
//  RefreshExample
//
//  Created by zhangyr on 15/5/7.
//  Copyright (c) 2015年 cjxnfs. All rights reserved.
//

import UIKit



extension UIScrollView {
    func addHeaderWithCallback(needTop : Bool = false , callback:(() -> Void)!){
        let header:RefreshHeaderView = RefreshHeaderView.footer(needTop)
        self.addSubview(header)
        header.beginRefreshingCallback = callback
        header.addState(RefreshState.Normal)
    }
    
    func removeHeader()
    {
        
        for view : AnyObject in self.subviews{
            if view is RefreshHeaderView{
                view.removeFromSuperview()
            }
        }
    }
    
    
    func headerBeginRefreshing()
    {
        
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                object.beginRefreshing()
            }
        }
        
    }
    
    
    func headerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                object.endRefreshing()
            }
        }
        
    }
    
    func setHeaderHidden(hidden:Bool)
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                let view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
        
    }
    
    func isHeaderHidden()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                let view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
        
    }
    
   func addFooterWithCallback( callback:(() -> Void)!)
   {
        var hasSub = false
    
        for view : UIView in self.subviews
        {
            if view is RefreshFooterView
            {
                hasSub  = true
                break
            }
        }
        if !hasSub
        {
            let footer:RefreshFooterView = RefreshFooterView.footer()
            self.addSubview(footer)
            footer.beginRefreshingCallback = callback
            footer.addState(RefreshState.Normal)
        }
    }
    
    
     func removeFooter()
    {
    
        for view : AnyObject in self.subviews{
            if view is RefreshFooterView{
                view.removeFromSuperview()
            }
        }
    }
    
    func footerBeginRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                object.beginRefreshing()
            }
        }
        
    }

    
    func footerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                object.endRefreshing()
            }
        }
     
    }
  
    func setFooterHidden(hidden:Bool)
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                let view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
        
    }
    
    func isFooterHidden()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                let view:UIView  = object as! UIView
                view.hidden = hidden
            }
        }
        
    }
  
 


}