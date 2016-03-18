//
//  HomeBenefitDetailData.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/15.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class HomeBenefitDetailData: BaseData , UIWebViewDelegate {
    
    var id          : String = ""
    var title       : String = ""
    var bidStatus   : String = ""
    var total       : Int    = 0
    var collected   : Int    = 0
    var org         : String = ""
    var content     : String        = "" {
        didSet {
            if !content.isEmpty {
                webView             = UIWebView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 32, height: 50))
                webView.hidden      = true
                webView.delegate    = self
                UtilTool.getAppDelegate().window?.addSubview(webView)
                webView.loadHTMLString(content, baseURL: nil)
            }
        }
    }
    var contentHeight   : CGFloat   = 0
    private var webView : UIWebView!
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.sizeToFit()
        self.contentHeight      = webView.frame.maxY
        webView.removeFromSuperview()
        webView.delegate        = nil
    }
    
}
