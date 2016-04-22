//
//  UCMoreInfoViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/17.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UCMoreInfoViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate{

    
    private var tableView       : UITableView!
    private var loginBtn        : BaseButton!
    private var dataSource      : Array<Dictionary<String , AnyObject>>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title              = "更多信息"
    }
    
    override func initUI() {
        super.initUI()
        
        tableView                               = UITableView()
        tableView.dataSource                    = self
        tableView.delegate                      = self
        tableView.separatorStyle                = .None
        tableView.backgroundColor               = UtilTool.colorWithHexString("#efefef")
        tableView.showsVerticalScrollIndicator  = false
        self.view.addSubview(tableView)
        
        tableView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.view)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(self.view)
            maker.bottom.equalTo()(self.view)
        }
        
        let fv                                  = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        let hintLabel                           = UILabel()
        hintLabel.textColor                     = UtilTool.colorWithHexString("#a8a8a9")
        hintLabel.font                          = UIFont.systemFontOfSize(12)
        hintLabel.textAlignment                 = .Right
        hintLabel.text                          = "客服工作时间：9:00 - 18:00"
        fv.addSubview(hintLabel)
        
        hintLabel.mas_makeConstraints { (maker) in
            maker.right.equalTo()(fv).offset()(-16)
            maker.top.equalTo()(fv).offset()(12)
            maker.height.equalTo()(12)
        }
        
        loginBtn                                = BaseButton()
        loginBtn.backgroundColor                = UtilTool.colorWithHexString("#ff6600")
        loginBtn.titleLabel?.font               = UIFont.systemFontOfSize(15)
        loginBtn.setTitle("退出登录", forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.layer.cornerRadius             = 4
        loginBtn.layer.masksToBounds            = true
        loginBtn.addTarget(self, action: #selector(UCMoreInfoViewController.longinAction), forControlEvents: UIControlEvents.TouchUpInside)
        fv.addSubview(loginBtn)
        
        loginBtn.mas_makeConstraints { (maker) in
            maker.left.equalTo()(fv).offset()(16)
            maker.right.equalTo()(fv).offset()(-16)
            maker.top.equalTo()(hintLabel.mas_bottom).offset()(12)
            maker.height.equalTo()(40)
        }
        
        tableView.tableFooterView               = fv
        
    }
    
    @objc private func longinAction() {
        
        if UtilCheck.isLogin() {
            UtilCookie.logout()
            refreshData()
        }else{
            let loginVc         = UCLoginViewController()
            loginVc.callBack    = {Void in
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.2 * Double(NSEC_PER_SEC))),  dispatch_get_main_queue(), { 
                    self.refreshData()
                })
            }
            presentViewController(UtilTool.getAppDelegate().navi, animated: true, completion: nil)
        }
        
    }
    
    override func refreshData() {
        dataSource          =  Array()
        loginBtn.setTitle("登录", forState: UIControlState.Normal)
        loginBtn.tag        = 888
        if UtilCheck.isLogin() {
            if let user = Commond.getUserDefaults("userData") as? UCUserData {
                let userInfo    = ["title" : "当前用户" , "detail" : user.username]
                dataSource?.append(userInfo)
            }
            loginBtn.setTitle("退出登录", forState: UIControlState.Normal)
        }
        dataSource?.append(["title" : "官方微信" , "detail" : "中赣核普惠金融"])
        dataSource?.append(["title" : "官方微博" , "detail" : "http://weibo.com/u/5598275109"])
        dataSource?.append(["title" : "客服电话" , "detail" : "400-061-7796"])
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource == nil ? 0 : dataSource!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell                        = tableView.dequeueReusableCellWithIdentifier("moreInfoCell")
        if cell == nil {
            cell                        = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "moreInfoCell")
        }
        cell?.selectionStyle            = .None
        cell?.backgroundColor           = UIColor.whiteColor()
        cell?.textLabel?.font           = UIFont.systemFontOfSize(14)
        cell?.textLabel?.textColor      = UtilTool.colorWithHexString("#666")
        cell?.textLabel?.text           = dataSource?[indexPath.row]["title"] + ""
        cell?.detailTextLabel?.font     = UIFont.systemFontOfSize(14)
        if indexPath.row == dataSource!.count - 1 {
            cell?.detailTextLabel?.textColor = UtilTool.colorWithHexString("#ff6600")
        }else{
            cell?.detailTextLabel?.textColor = UtilTool.colorWithHexString("#666")
        }
        cell?.detailTextLabel?.text     = dataSource?[indexPath.row]["detail"] + ""
        let sepLine                     = UIView()
        sepLine.backgroundColor         = UtilTool.colorWithHexString("#ddd")
        cell?.contentView.addSubview(sepLine)
        sepLine.mas_makeConstraints { (maker) in
            maker.left.equalTo()(sepLine.superview)
            maker.right.equalTo()(sepLine.superview)
            maker.bottom.equalTo()(sepLine.superview)
            maker.height.equalTo()(0.5)
        }
        return cell!
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == dataSource!.count - 1 {
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://4000617796")!)
        }
    }
}
