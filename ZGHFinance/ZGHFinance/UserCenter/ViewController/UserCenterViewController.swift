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
    private var userInfo        : UCUserInfoData? {
        didSet{
            if userInfo != nil {
                showUserInfo()
            }
        }
    }
    private var bankInfo        : Dictionary<String , AnyObject>?
    private var accountInfo     : UCAccountInfoData? {
        didSet{
            if accountInfo != nil {
                showAccountInfo()
            }
        }
    }
    
    
    private let options = [["icon" : "uc_bankcard" , "title" : "我的银行卡"] , ["icon" : "uc_info" , "title" : "账户安全"] , ["icon" : "uc_software" , "title" : "更多信息"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title                  = "我的账户"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserCenterViewController.clearAllInfo), name: "unlogin", object: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UtilTool.addTabBarToController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
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
        avatar.layer.masksToBounds      = true
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
        nameLabel.text                  = "--"
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
        realName.userInteractionEnabled = false
        realName.setTitle("--", forState: UIControlState.Normal)
        realName.setTitleColor(UtilTool.colorWithHexString("#666"), forState: UIControlState.Normal)
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
        phoneLabel.text                 = "--"
        topView.addSubview(phoneLabel)
        phoneLabel.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self.realName)
            maker.right.centerY().equalTo()(phoneHint)
            maker.height.equalTo()(12)
        }
        
        let rechargeBtn                 = BaseButton()
        rechargeBtn.layer.cornerRadius  = 4
        rechargeBtn.tag                 = 888
        rechargeBtn.titleLabel?.font    = UIFont.systemFontOfSize(14)
        rechargeBtn.backgroundColor     = UtilTool.colorWithHexString("#53a0e3")
        rechargeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        rechargeBtn.setTitle("充值", forState: UIControlState.Normal)
        rechargeBtn.addTarget(self, action: #selector(UserCenterViewController.rechargeAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        let withdrawBtn                 = BaseButton()
        withdrawBtn.layer.cornerRadius  = 4
        withdrawBtn.tag                 = 999
        withdrawBtn.titleLabel?.font    = UIFont.systemFontOfSize(14)
        withdrawBtn.backgroundColor     = UtilTool.colorWithHexString("#ff6600")
        withdrawBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        withdrawBtn.setTitle("提现", forState: UIControlState.Normal)
        withdrawBtn.addTarget(self, action: #selector(UserCenterViewController.rechargeAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        headerView.addSubview(rechargeBtn)
        headerView.addSubview(withdrawBtn)
        
        rechargeBtn.mas_makeConstraints { (maker) in
            maker.left.equalTo()(headerView).offset()(32)
            maker.width.equalTo()(withdrawBtn)
            maker.top.equalTo()(topView.mas_bottom).offset()(16)
            maker.height.equalTo()(40)
        }
        withdrawBtn.mas_makeConstraints { (maker) in
            maker.left.equalTo()(rechargeBtn.mas_right).offset()(16)
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
        accountAmount.text              = "--"
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
        
        let infoBtn                     = BaseButton()
        infoBtn.setImage(UIImage(named: "uc_property_icon_warning"), forState: UIControlState.Normal)
        infoBtn.addTarget(self, action: #selector(UserCenterViewController.showInfo), forControlEvents: UIControlEvents.TouchUpInside)
        bottomView.addSubview(infoBtn)
        infoBtn.mas_makeConstraints { (maker) in
            maker.left.equalTo()(loverHint.mas_right).offset()(6)
            maker.centerY.equalTo()(loverHint)
            maker.width.equalTo()(20)
            maker.height.equalTo()(20)
        }
        
        loverCoin                       = UILabel()
        loverCoin.font                  = UIFont.systemFontOfSize(14)
        loverCoin.textColor             = UtilTool.colorWithHexString("#ff6600")
        loverCoin.text                  = "--"
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
        useableAmount.text              = "--"
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
        totalProfit.text                = "--"
        bottomView.addSubview(totalProfit)
        totalProfit.mas_makeConstraints { (maker) in
            maker.left.equalTo()(profitHint)
            maker.top.equalTo()(self.useableAmount)
            maker.height.equalTo()(14)
        }
        
        tableView?.tableHeaderView      = headerView
    }
    
    //MARK: SELS
    
    @objc private func showInfo() {
        let alert               = SMAlertView(title: "什么是爱心币", message: "爱心币是用于捐赠公益项目的代币，首次注册会获取一定数量的爱心币，某些线下活动也能获取爱心币奖励(如投资活动)，爱心币不可通过充值获取。捐赠的爱心币会以等额的价值由中赣核普惠金融资助给公益项目的组织者。", delegate: nil, cancelButtonTitle: "我知道了")
        alert.show()
    }
    
    private func showUserInfo() {
        nameLabel.text          = userInfo?.username
        if !userInfo!.idCard.isEmpty {
            realName.setTitle(userInfo?.realname, forState: UIControlState.Normal)
            realName.setTitleColor(UtilTool.colorWithHexString("#666"), forState: UIControlState.Normal)
            realName.userInteractionEnabled = false
        }else{
            realName.setTitle("未认证", forState: UIControlState.Normal)
            realName.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            realName.userInteractionEnabled = true
        }
        phoneLabel.text         = UtilTool.encryMobileMiddle(userInfo!.cellPhone)
        loverCoin.text          = "\(userInfo!.loveCoins)"
    }
    
    private func showAccountInfo() {
        
        accountAmount.text      = (accountInfo!.financialFund + accountInfo!.balance).formatDecimal(true)
        useableAmount.text      = (accountInfo!.balance - accountInfo!.frozenFund).formatDecimal(true)
        totalProfit.text        = accountInfo!.countEarnings.formatDecimal(true)
    }
    
    @objc private func rechargeAction(btn : BaseButton) {
        
        if !UtilCheck.isLogin() {
            let loginVc         = UCLoginViewController()
            loginVc.callBack    = {Void in
                /*if btn.tag == 888 {
                    self.goRecharge()
                }else{
                    self.goWithdraw()
                }*/
            }
            self.presentViewController(UtilTool.getAppDelegate().navi, animated: true, completion: nil)
        }else{
            if btn.tag == 888 {
                goRecharge()
            }else{
                goWithdraw()
            }
        }
    }
    
    private func goRecharge() {
        if userInfo != nil {
            let rechargeVc          = UCRechargeViewController()
            rechargeVc.cellPhone    = userInfo!.cellPhone
            self.navigationController?.pushViewController(rechargeVc, animated: true)
        }else{
            UtilTool.noticError(view: self.view, msg: "用户信息获取错误")
            refreshData()
        }
        
    }
    
    private func goWithdraw() {
        
    }
    
    @objc private func realNameVerify() {
        if UtilCheck.isLogin() {
            
        }
    }
    
    @objc private func tapAction() {
        if !UtilCheck.isLogin() {
            let loginVc         = UCLoginViewController()
            loginVc.callBack    = {Void in
                print("头像登录")
            }
            self.presentViewController(UtilTool.getAppDelegate().navi, animated: true, completion: nil)
        }
    }
    
    override func needSetBackIcon() -> Bool {
        return false
    }
    
    override func needRefrshData() -> Bool {
        return false
    }
    
    override func refreshData() {
        if UtilCheck.isLogin() {
            if let uData = Commond.getUserDefaults("userData") as? UCUserData {
                
                UCService.getUserDataWithToken(uData.loginToken, completion: { (userData) in
                    if userData?.cjxnfsCode == 10000 {
                        self.userInfo       = userData as? UCUserInfoData
                    }else{
                        UtilTool.noticError(view: self.view, msg: userData!.responseMsg!)
                    }
                    }, failure: { (error) in
                        UtilTool.noticError(view: self.view, msg: error.msg!)
                })
                
                UCService.getAccountDataWithToken(uData.loginToken, completion: { (accountData) in
                    if accountData?.cjxnfsCode == 10000 {
                        self.accountInfo    = accountData as? UCAccountInfoData
                    }else{
                        UtilTool.noticError(view: self.view, msg: accountData!.responseMsg!)
                    }
                    }, failure: { (error) in
                        UtilTool.noticError(view: self.view, msg: error.msg!)
                })
                
                
            }
        }else{
            clearAllInfo()
        }
    }
    
    @objc private func clearAllInfo() {
        nameLabel.text      = "未登录"
        realName.setTitle("--", forState: UIControlState.Normal)
        realName.setTitleColor(UtilTool.colorWithHexString("#666"), forState: UIControlState.Normal)
        realName.userInteractionEnabled = false
        phoneLabel.text     = "--"
        accountAmount.text  = "0"
        loverCoin.text      = "0"
        useableAmount.text  = "0"
        totalProfit.text    = "0"
    }
    
    //MARK: DATASOURCE & DELEGATE
    
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
        cell.selectionStyle         = .None
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if userInfo == nil {
            return
        }
        switch indexPath.row {
        case 0 :
            if UtilCheck.isLogin() {
                if userInfo!.idCard.isEmpty {
                    let verifyVc            = UCVerifyViewController()
                    verifyVc.type           = indexPath.row
                    verifyVc.userData       = userInfo
                    self.navigationController?.pushViewController(verifyVc, animated: true)
                }else{
                    let cardVc              = UCBankCardListController()
                    cardVc.userInfo         = userInfo
                    self.navigationController?.pushViewController(cardVc, animated: true)
                }
            }else{
                let loginVc             = UCLoginViewController()
                loginVc.callBack        = {Void in
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        self.refreshData()
                    })
                    
                }
                self.presentViewController(UtilTool.getAppDelegate().navi, animated: true, completion: nil)
            }
        case 1 :
            if UtilCheck.isLogin() {
                let verifyVc            = UCVerifyViewController()
                verifyVc.type           = indexPath.row
                if bankInfo != nil {
                    userInfo?.bankName  = bankInfo!["bankName"] + ""
                    userInfo?.bankCard  = bankInfo!["bankCard"] + ""
                }
                verifyVc.userData       = userInfo
                self.navigationController?.pushViewController(verifyVc, animated: true)
            }else{
                let loginVc             = UCLoginViewController()
                loginVc.callBack        = {Void in
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { 
                        self.refreshData()
                    })
    
                }
                self.presentViewController(UtilTool.getAppDelegate().navi, animated: true, completion: nil)
            }
        case 2 :
            let moreVc                  = UCMoreInfoViewController()
            self.navigationController?.pushViewController(moreVc, animated: true)
        default :
            break
        }
    }
    
}
