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
    private var realName        : BaseButton!
    private var phoneLabel      : UILabel!
    private var accountAmount   : UILabel!
    private var loverCoin       : UILabel!
    private var useableAmount   : UILabel!
    private var totalProfit     : UILabel!
    
    private let options = [["icon" : "uc_bankcard" , "title" : "我的银行卡"] , ["icon" : "uc_info" , "title" : "账户安全"] , ["icon" : "uc_software" , "title" : "更多信息"]]
    
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
        
        tableView                       = UITableView()
        tableView?.dataSource           = self
        tableView?.delegate             = self
        tableView?.separatorStyle       = .None
        tableView?.backgroundColor      = UtilTool.colorWithHexString("#efefef")
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ucCell")
        self.view.addSubview(tableView!)
        tableView?.mas_makeConstraints({ (maker) in
            maker.left.equalTo()(self.view)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(self.view)
            maker.bottom.equalTo()(self.view)
        })
        
        initHeader()
    }
    
    private func initHeader() {
        let headerView                  = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 318))
        headerView.backgroundColor      = UtilTool.colorWithHexString("#efefef")
        
        let topView                     = UIView()
        topView.backgroundColor         = UIColor.whiteColor()
        headerView.addSubview(topView)
        topView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(headerView)
            maker.right.equalTo()(headerView)
            maker.top.equalTo()(headerView)
            maker.height.equalTo()(108)
        }
        
        let avatar                      = UIImageView(image: UIImage(named: "uc_login_icon.jpg"))
        avatar.userInteractionEnabled   = true
        avatar.layer.cornerRadius       = 25
        let tap                         = UITapGestureRecognizer(target: self, action: #selector(UserCenterViewController.tapAction))
        avatar.addGestureRecognizer(tap)
        headerView.addSubview(avatar)
        avatar.mas_makeConstraints { (maker) in
            maker.left.equalTo()(topView).offset()(32)
            maker.centerY.equalTo()(topView)
            maker.width.equalTo()(50)
            maker.height.equalTo()(50)
        }
        
        nameLabel                       = UILabel()
        nameLabel.font                  = UIFont.systemFontOfSize(14)
        nameLabel.textColor             = UtilTool.colorWithHexString("#666")
        nameLabel.text                  = "测试号"
        topView.addSubview(nameLabel)
        nameLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(avatar.mas_right).offset()(60)
            maker.top.equalTo()(topView).offset()(20)
            maker.height.equalTo()(14)
        }
        
        let nameHint                    = UILabel()
        nameHint.font                   = UIFont.systemFontOfSize(12)
        nameHint.textColor              = UtilTool.colorWithHexString("#a3a3a3")
        nameHint.text                   = "真实姓名："
        topView.addSubview(nameHint)
        nameHint.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.nameLabel)
            maker.top.equalTo()(self.nameLabel.mas_bottom).offset()(14)
            maker.height.equalTo()(12)
        }
        
        realName                        = BaseButton()
        realName.contentHorizontalAlignment = .Left
        realName.titleLabel?.font       = UIFont.systemFontOfSize(12)
        realName.setTitle("未认证", forState: UIControlState.Normal)
        realName.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        realName.addTarget(self, action: #selector(UserCenterViewController.realNameVerify), forControlEvents: UIControlEvents.TouchUpInside)
        topView.addSubview(realName)
        realName.mas_makeConstraints { (maker) in
            maker.left.equalTo()(nameHint.mas_right).offset()(4)
            maker.right.equalTo()(topView).offset()(-16)
            maker.centerY.equalTo()(nameHint)
            maker.height.equalTo()(20)
        }
        
        let phoneHint                   = UILabel()
        phoneHint.font                  = UIFont.systemFontOfSize(12)
        phoneHint.textColor             = UtilTool.colorWithHexString("#a3a3a3")
        phoneHint.text                  = "手机号码："
        topView.addSubview(phoneHint)
        phoneHint.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.nameLabel)
            maker.top.equalTo()(nameHint.mas_bottom).offset()(14)
            maker.height.equalTo()(12)
        }
        
        phoneLabel                      = UILabel()
        phoneLabel.font                 = UIFont.systemFontOfSize(12)
        phoneLabel.textColor            = UtilTool.colorWithHexString("#666")
        phoneLabel.text                 = "158****4759"
        topView.addSubview(phoneLabel)
        phoneLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.realName)
            maker.right.centerY().equalTo()(phoneHint)
            maker.height.equalTo()(12)
        }
        
        let rechargeBtn                 = BaseButton()
        rechargeBtn.layer.cornerRadius  = 4
        rechargeBtn.titleLabel?.font    = UIFont.systemFontOfSize(14)
        rechargeBtn.backgroundColor     = UtilTool.colorWithHexString("#53a0e3")
        rechargeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rechargeBtn.setTitle("充值", forState: UIControlState.Normal)
        rechargeBtn.addTarget(self, action: #selector(UserCenterViewController.rechargeAction), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.addSubview(rechargeBtn)
        rechargeBtn.mas_makeConstraints { (maker) in
            maker.left.equalTo()(headerView).offset()(32)
            maker.right.equalTo()(headerView).offset()(-32)
            maker.top.equalTo()(topView.mas_bottom).offset()(16)
            maker.height.equalTo()(40)
        }
        
        let bottomView                  = UIView()
        bottomView.backgroundColor      = UIColor.whiteColor()
        headerView.addSubview(bottomView)
        bottomView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(headerView)
            maker.right.equalTo()(headerView)
            maker.top.equalTo()(rechargeBtn.mas_bottom).offset()(16)
            maker.bottom.equalTo()(headerView).offset()(-16)
        }
        
        let accountHint                 = UILabel()
        accountHint.font                = UIFont.systemFontOfSize(12)
        accountHint.textColor           = UtilTool.colorWithHexString("#a3a3a3")
        accountHint.text                = "账户总资产(元)"
        bottomView.addSubview(accountHint)
        accountHint.mas_makeConstraints { (maker) in
            maker.left.equalTo()(bottomView).offset()(32)
            maker.top.equalTo()(bottomView).offset()(14)
            maker.height.equalTo()(12)
        }
        
        accountAmount                   = UILabel()
        accountAmount.font              = UIFont.systemFontOfSize(14)
        accountAmount.textColor         = UtilTool.colorWithHexString("#ff6600")
        accountAmount.text              = "0"
        bottomView.addSubview(accountAmount)
        accountAmount.mas_makeConstraints { (maker) in
            maker.left.equalTo()(accountHint)
            maker.top.equalTo()(accountHint.mas_bottom).offset()(10)
            maker.height.equalTo()(14)
        }
        
        let loverHint                   = UILabel()
        loverHint.font                  = UIFont.systemFontOfSize(12)
        loverHint.textColor             = UtilTool.colorWithHexString("#a3a3a3")
        loverHint.text                  = "爱心币(个)"
        bottomView.addSubview(loverHint)
        loverHint.mas_makeConstraints { (maker) in
            maker.left.equalTo()(bottomView.mas_centerX)
            maker.top.equalTo()(accountHint)
            maker.height.equalTo()(12)
        }
        
        loverCoin                       = UILabel()
        loverCoin.font                  = UIFont.systemFontOfSize(14)
        loverCoin.textColor             = UtilTool.colorWithHexString("#ff6600")
        loverCoin.text                  = "0"
        bottomView.addSubview(loverCoin)
        loverCoin.mas_makeConstraints { (maker) in
            maker.left.equalTo()(loverHint)
            maker.top.equalTo()(self.accountAmount)
            maker.height.equalTo()(14)
        }
        
        let sep                         = UIView()
        sep.backgroundColor             = UtilTool.colorWithHexString("#efefef")
        bottomView.addSubview(sep)
        sep.mas_makeConstraints { (maker) in
            maker.left.equalTo()(bottomView).offset()(32)
            maker.right.equalTo()(bottomView).offset()(-32)
            maker.top.equalTo()(self.loverCoin.mas_bottom).offset()(10)
            maker.height.equalTo()(0.5)
        }
        
        let leftHint                    = UILabel()
        leftHint.font                   = UIFont.systemFontOfSize(12)
        leftHint.textColor              = UtilTool.colorWithHexString("#a3a3a3")
        leftHint.text                   = "可用余额(元)"
        bottomView.addSubview(leftHint)
        leftHint.mas_makeConstraints { (maker) in
            maker.left.equalTo()(accountHint)
            maker.top.equalTo()(self.accountAmount.mas_bottom).offset()(20)
            maker.height.equalTo()(12)
        }
        
        useableAmount                   = UILabel()
        useableAmount.font              = UIFont.systemFontOfSize(14)
        useableAmount.textColor         = UtilTool.colorWithHexString("#ff6600")
        useableAmount.text              = "0"
        bottomView.addSubview(useableAmount)
        useableAmount.mas_makeConstraints { (maker) in
            maker.left.equalTo()(leftHint)
            maker.top.equalTo()(leftHint.mas_bottom).offset()(10)
            maker.height.equalTo()(14)
        }
        
        let profitHint                  = UILabel()
        profitHint.font                 = UIFont.systemFontOfSize(12)
        profitHint.textColor            = UtilTool.colorWithHexString("#a3a3a3")
        profitHint.text                 = "累计收益(元)"
        bottomView.addSubview(profitHint)
        profitHint.mas_makeConstraints { (maker) in
            maker.left.equalTo()(loverHint)
            maker.top.equalTo()(self.loverCoin.mas_bottom).offset()(20)
            maker.height.equalTo()(12)
        }
        
        totalProfit                     = UILabel()
        totalProfit.font                = UIFont.systemFontOfSize(14)
        totalProfit.textColor           = UtilTool.colorWithHexString("#ff6600")
        totalProfit.text                = "0"
        bottomView.addSubview(totalProfit)
        totalProfit.mas_makeConstraints { (maker) in
            maker.left.equalTo()(profitHint)
            maker.top.equalTo()(self.useableAmount)
            maker.height.equalTo()(14)
        }
        
        tableView?.tableHeaderView      = headerView
    }
    
    //MARK: SELS
    
    @objc private func rechargeAction() {
        print("充值")
    }
    
    @objc private func realNameVerify() {
        print("认证")
    }
    
    @objc private func tapAction() {
        print("头像")
    }
    
    override func needSetBackIcon() -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell                    = tableView.dequeueReusableCellWithIdentifier("ucCell", forIndexPath: indexPath)
        let dic                     = options[indexPath.row]
        cell.imageView?.image       = UIImage(named: dic["icon"]!)
        cell.textLabel?.text        = dic["title"]
        cell.textLabel?.font        = UIFont.systemFontOfSize(14)
        cell.textLabel?.textColor   = UtilTool.colorWithHexString("#a8a8a9")
        cell.accessoryType          = .DisclosureIndicator
        if indexPath.row != 2 {
            let sep                 = UIView()
            sep.backgroundColor     = UtilTool.colorWithHexString("#efefef")
            cell.addSubview(sep)
            sep.mas_makeConstraints { (maker) in
                maker.left.equalTo()(cell)
                maker.right.equalTo()(cell)
                maker.bottom.equalTo()(cell)
                maker.height.equalTo()(1)
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
}
