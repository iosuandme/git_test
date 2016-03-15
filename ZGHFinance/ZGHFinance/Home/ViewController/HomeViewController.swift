//
//  HomeViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/8.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate{
    
    private var tableView       : UITableView!
    private var homeData         : HomeData    = HomeData()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title              = "首页"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UtilTool.addTabBarToController(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.refreshData()
        }
    }
    
    override func initUI() {
        super.initUI()
        
        tableView                               = UITableView()
        tableView.showsVerticalScrollIndicator  = false
        tableView.separatorStyle                = .None
        tableView.backgroundColor               = UIColor.clearColor()
        tableView.dataSource                    = self
        tableView.delegate                      = self
        tableView.registerClass(HomeInvestCell.self, forCellReuseIdentifier: "investCell")
        self.view.addSubview(tableView)
        
        tableView.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.view)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(self.view)
            maker.bottom.equalTo()(self.view).offset()(-50)
        }
        
        let rollView                            = HomeRollImageView(frame: CGRectMake(0, 0, self.view.bounds.width, 130), delegate: nil)
        tableView.tableHeaderView               = rollView
        rollView.showScrollView([["imgName" : "Banner2.jpg"],["imgName" : "Banner3.jpg"]])
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func refreshData() {
        
        HomeService.getHomeInvestDataWithMaxSize("3", completion: { (invest) -> Void in
            if invest?.cjxnfsCode == 10000 {
                self.homeData.investData = invest as! HomeInvestData
                self.tableView.reloadData()
            }else{
                UtilTool.noticError(view: self.view, msg: invest!.responseMsg!)
            }
            }) { (error) -> Void in
                UtilTool.noticError(view: self.view, msg: error.msg!)
        }
        
        HomeService.getHomeBenefitData(completion:{ (benefit) -> Void in
            if benefit?.cjxnfsCode == 10000 {
                self.homeData.benefitData = benefit as! HomeBenefitData
                if self.checkHasData(0) {
                    self.tableView.reloadData()
                }
            }else{
                UtilTool.noticError(view: self.view, msg: benefit!.responseMsg!)
            }
            }) { (error) -> Void in
                UtilTool.noticError(view: self.view, msg: error.msg!)
        }
        
    }
    
    override func needRefrshData() -> Bool {
        return false
    }
    
    override func needSetBackIcon() -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return homeData.investData  == nil ? 0 : homeData.investData.investList.count
        }else{
            if checkHasData(section) {
                return homeData.benefitData.benefitList.count + 1
            }else{
                return 0
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == homeData.benefitData.benefitList.count {
            let cell                    = UITableViewCell()
            cell.selectionStyle         = .None
            cell.textLabel?.font        = UIFont.systemFontOfSize(14)
            cell.textLabel?.textColor   = UtilTool.colorWithHexString("#666")
            cell.textLabel?.text        = "查看更多公益项目"
            cell.accessoryType          = .DisclosureIndicator
            return cell
        }
        let cell            = tableView.dequeueReusableCellWithIdentifier("investCell", forIndexPath: indexPath) as! HomeInvestCell
        cell.projectData    = indexPath.section == 0 ? homeData.investData.investList[indexPath.row] : homeData.benefitData.benefitList[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == homeData.benefitData.benefitList.count {
            return 44
        }
        return 68
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if checkHasData(section) {
            return 50
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !checkHasData(section) {
            return nil
        }
        let hv                  = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        hv.backgroundColor      = UtilTool.colorWithHexString("#e5e5e5")
        let hintLabel           = UILabel()
        hintLabel.text          = section == 0 ? "推荐投资项目" : "赣核公益"
        hintLabel.font          = UIFont.systemFontOfSize(16)
        hintLabel.textColor     = UtilTool.colorWithHexString("#ff6600")
        hintLabel.textAlignment = .Center
        hv.addSubview(hintLabel)
        
        let line                = UIView()
        line.backgroundColor    = UtilTool.colorWithHexString("#ddd")
        hv.addSubview(line)
        
        hintLabel.mas_makeConstraints { (maker) -> Void in
            maker.center.equalTo()(hv)
        }
        
        line.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(hv)
            maker.right.equalTo()(hv)
            maker.bottom.equalTo()(hv)
            maker.height.equalTo()(1)
        }
        
        return hv
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let detailVc        = FinanceDetailViewController()
            detailVc.id         = homeData.investData.investList[indexPath.row].bidNo
            self.navigationController?.pushViewController(detailVc, animated: true)
        }else{
            if indexPath.row == homeData.benefitData.benefitList.count {
                let benefitVc   = HomeBenefitListViewController()
                self.navigationController?.pushViewController(benefitVc, animated: true)
            }else{
                let benefitVc   = HomeBenefitDetailViewController()
                benefitVc.id    = homeData.benefitData.benefitList[indexPath.row].bidNo
                self.navigationController?.pushViewController(benefitVc, animated: true)
            }
        }
    }
    
    private func checkHasData(section : Int) -> Bool {
        if section == 0 && homeData.investData != nil && homeData.investData.investList.count > 0 {
            return true
        }
        
        if section == 1 && homeData.benefitData != nil && homeData.benefitData.benefitList.count > 0 {
            return true
        }
        
        return false
    }

}
