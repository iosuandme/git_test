//
//  HomeBenefitListViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/15.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class HomeBenefitListViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate {
    
    private var tableView       : UITableView?
    private var currentPage     : Int {
        set {
            if newValue < 1 {
                _p          = 1
            }else{
                _p          = newValue
            }
        }
        get {
            return _p
        }
    }
    private var maxSize         : Int                    = 10
    private var _p              : Int                    = 1
    
    private var benefitList     : Array<HomeProjectData> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title              = "公益项目"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func initUI() {
        super.initUI()
        tableView                                = UITableView()
        tableView?.showsVerticalScrollIndicator  = false
        tableView?.separatorStyle                = .None
        tableView?.backgroundColor               = UIColor.clearColor()
        tableView?.dataSource                    = self
        tableView?.delegate                      = self
        tableView?.registerClass(HomeInvestCell.self, forCellReuseIdentifier: "investCell")
        self.view.addSubview(tableView!)
        
        tableView?.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.view)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(self.view)
            maker.bottom.equalTo()(self.view)
        }
        
        setupRefresh()
    }
    
    override func needRefrshData() -> Bool {
        return true
    }
    
    private func setupRefresh(){
        
        tableView?.removeHeader()
        tableView?.removeFooter()
        weak var blockSelf = self
        tableView?.addHeaderWithCallback(callback:{
            blockSelf!.currentPage = 1
            blockSelf!.refreshData()
        })
        
        tableView?.addFooterWithCallback({ () -> Void in
            blockSelf!.currentPage++
            blockSelf!.refreshData()
        })
    }
    
    private func endRefresh() {
        tableView?.headerEndRefreshing()
        tableView?.footerEndRefreshing()
    }
    
    override func refreshData() {
        
        HomeService.getHomeBenefitData(currentPage, maxSize: maxSize, completion: { (benefit) -> Void in
            self.endRefresh()
            if benefit?.cjxnfsCode == 10000 {
                let data = benefit as! HomeBenefitData
                if self.currentPage == 1 {
                    self.benefitList  = data.benefitList
                }else{
                    self.benefitList += data.benefitList
                }
                if data.benefitList.count < self.maxSize {
                    self.tableView?.removeFooter()
                }else{
                    self.setupRefresh()
                }
                self.tableView?.reloadData()
            }else{
                UtilTool.noticError(view: self.view, msg: benefit!.responseMsg!)
                self.currentPage--
            }
            }) { (error) -> Void in
                self.endRefresh()
                UtilTool.noticError(view: self.view, msg: error.msg!)
                self.currentPage--
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return benefitList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell            = tableView.dequeueReusableCellWithIdentifier("investCell", forIndexPath: indexPath) as! HomeInvestCell
        cell.projectData    = benefitList[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let benefitVc           = HomeBenefitDetailViewController()
        benefitVc.id            = benefitList[indexPath.row].bidNo
        self.navigationController?.pushViewController(benefitVc, animated: true)
    }

}
