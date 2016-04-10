//
//  UserCenterViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/8.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class UserCenterViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate{
    
    private var tableView       : UITableView?
    private var nameLabel       : UILabel!
    private var realNameLabel   : UILabel!
    private var phoneLabel      : UILabel!
    private var accountAmount   : UILabel!
    private var loverCoin       : UILabel!
    private var useableAmount   : UILabel!
    private var totalProfit     : UILabel!
    
    private let options = [["icon" : "" , "title" : "我的银行卡"] , ["icon" : "" , "title" : "账户安全"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title                  = "我的账户"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UtilTool.addTabBarToController(self)
    }
    
    override func initUI() {
        super.initUI()
        
        tableView                   = UITableView()
        tableView?.dataSource       = self
        tableView?.delegate         = self
        tableView?.backgroundColor  = UtilTool.colorWithHexString("#efefef")
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ucCell")
        self.view.addSubview(tableView!)
        tableView?.mas_makeConstraints({ (maker) in
            maker.left.equalTo()(self.view)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(self.view)
            maker.bottom.equalTo()(self.view)
        })
        
        let headerView              = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 300))
        
        let topView                 = UIView()
        topView.backgroundColor     = UIColor.whiteColor()
        
        
        
        
    }
    
    private func initHeader() {
        
    }
    
    override func needSetBackIcon() -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCellWithIdentifier("ucCell", forIndexPath: indexPath)
        let dic                 = options[indexPath.row]
        cell.imageView?.image   = UIImage(named: dic["icon"]!)
        cell.textLabel?.text    = dic["title"]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
}
