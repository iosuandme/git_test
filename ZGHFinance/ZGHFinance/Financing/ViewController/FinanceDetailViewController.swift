//
//  FinanceDetailViewController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/10.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

class FinanceDetailViewController: BaseViewController , UITableViewDataSource , UITableViewDelegate , SelectedSegmentedBarDelegate , FinanceDetailHeaderViewDelegate {

    var id                      : String = ""
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
    private var maxSize         : Int                            = 10
    private var _p              : Int                            = 1
    private var selectedIndex   : Int                            = 0
    private var detailData      : FinanceDetailData!
    private var recordList      : Array<FinanceRecordDetailData> = Array()
    private var headerView      : FinanceDetailHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title              = "项目详情"
    }

    override func initUI() {
        super.initUI()
        tableView                                = UITableView()
        tableView?.showsVerticalScrollIndicator  = false
        tableView?.separatorStyle                = .None
        tableView?.backgroundColor               = UIColor.clearColor()
        tableView?.dataSource                    = self
        tableView?.delegate                      = self
        tableView?.registerClass(FinanceRecordCell.self, forCellReuseIdentifier: "recordCell")
        self.view.addSubview(tableView!)
        
        tableView?.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.view)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(self.view)
            maker.bottom.equalTo()(self.view)
        }
        
        let hv                                  = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 235))
        headerView                              = FinanceDetailHeaderView(delegate: self)
        hv.addSubview(headerView!)
        headerView?.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(hv)
            maker.right.equalTo()(hv)
            maker.top.equalTo()(hv)
            maker.bottom.equalTo()(hv).offset()(-10)
        }
        tableView?.tableHeaderView              = hv
        
        setupRefresh()
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
        
        if selectedIndex == 0 {
            tableView?.removeFooter()
            FinancingService.getFinancingDetailData(id, completion: { (detail) -> Void in
                self.endRefresh()
                if detail?.cjxnfsCode == 10000 {
                    self.detailData = detail as! FinanceDetailData
                    self.headerView?.showHeaderData(self.detailData.headerData)
                    self.tableView?.reloadData()
                }else{
                    UtilTool.noticError(view: self.view, msg: detail!.responseMsg!)
                }
                }, failure: { (error) -> Void in
                    self.endRefresh()
                    UtilTool.noticError(view: self.view, msg: error.msg!)
            })
        }else{
            FinancingService.getFinancingRecordList(id, currentPage: currentPage, maxSize: maxSize, completion: { (record) -> Void in
                self.endRefresh()
                if record?.cjxnfsCode == 10000 {
                    let data = record as! FinanceRecordData
                    if self.currentPage == 1 {
                        self.recordList  = data.recordList
                    }else{
                        self.recordList += data.recordList
                    }
                    if data.recordList.count < self.maxSize {
                        self.tableView?.removeFooter()
                    }else{
                        self.setupRefresh()
                    }
                    self.tableView?.reloadData()
                }else{
                    UtilTool.noticError(view: self.view, msg: record!.responseMsg!)
                    self.currentPage--
                }
                }) { (error) -> Void in
                    self.endRefresh()
                    UtilTool.noticError(view: self.view, msg: error.msg!)
                    self.currentPage--
            }
        }
    }
    
    //MARK: DATASOURCE && DELEGATE
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 0 {
            if detailData == nil || detailData.headerData == nil {
                return 0
            }
            return 1
        }else{
            return recordList.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if selectedIndex == 0 {
            let cell        = FinanceDetailCell()
            cell.detailData = detailData.otherData
            return cell
        }
        let cell            = tableView.dequeueReusableCellWithIdentifier("recordCell", forIndexPath: indexPath) as! FinanceRecordCell
        cell.recordInfo     = recordList[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedIndex == 0 {
            if detailData != nil {
                return detailData.otherHeight
            }else{
                return 0
            }
        }else{
            return 94
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hv              = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 36))
        hv.backgroundColor  = UIColor.clearColor()
        let segBar          = SelectedSegmentedBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 36), items: ["项目详情","投标记录"], delegate: self)
        segBar.index        = selectedIndex
        hv.addSubview(segBar)
        return hv
    }
    
    func selectedItemForSegmentedBar(segmentedBar: SelectedSegmentedBar, selectedSegmentedIndex: Int) {
        selectedIndex       = selectedSegmentedIndex
        if selectedSegmentedIndex == 0 {
            tableView?.removeFooter()
            if detailData != nil && detailData.headerData.process == "100" {
                tableView?.reloadData()
            }else{
                refreshData()
            }
        }else{
            refreshData()
        }
    }
    
    func detailHeaderTouchEvent() {
        print("投资")
    }

}
