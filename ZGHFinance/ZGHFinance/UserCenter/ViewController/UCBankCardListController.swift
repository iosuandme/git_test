//
//  UCBankCardListController.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/21.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

enum BankCardOptionType : Int {
    case Add = 0
    case Select
}

class UCBankCardListController: BaseViewController {
    
    var userInfo            : UCUserInfoData?
    var optionType          : BankCardOptionType        = .Add
    var selectionData       : UCBankCardInfo?
    var callBack            : ((UCBankCardInfo) -> Void)?
    private var tableView   : UITableView?
    private var cardList    : Array<UCBankCardInfo>     = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        if optionType == .Add {
            self.title                           = "银行卡管理"
        }else{
            self.title                           = "选择银行卡"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    override func initUI() {
        super.initUI()
        tableView                                = UITableView()
        tableView?.showsVerticalScrollIndicator  = false
        tableView?.separatorStyle                = .None
        tableView?.backgroundColor               = UIColor.clearColor()
        tableView?.dataSource                    = self
        tableView?.delegate                      = self
        tableView?.registerClass(UCBankCardCell.self, forCellReuseIdentifier: "bankCardCell")
        self.view.addSubview(tableView!)
        
        tableView?.mas_makeConstraints { (maker) -> Void in
            maker.left.equalTo()(self.view)
            maker.right.equalTo()(self.view)
            maker.top.equalTo()(self.view)
            maker.bottom.equalTo()(self.view)
        }
        
        if optionType == .Add {
            let fv                              = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 70))
            fv.backgroundColor                  = UtilTool.colorWithHexString("#efefef")
            let addCard                         = BaseButton()
            addCard.backgroundColor             = UtilTool.colorWithHexString("#53a0e3")
            addCard.titleLabel?.font            = UIFont.systemFontOfSize(14)
            addCard.layer.cornerRadius          = 4
            addCard.layer.masksToBounds         = true
            addCard.setTitle("添加银行卡", forState: UIControlState.Normal)
            addCard.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            addCard.addTarget(self, action: #selector(UCBankCardListController.addCardAction), forControlEvents: UIControlEvents.TouchUpInside)
            fv.addSubview(addCard)
            addCard.mas_makeConstraints({ (maker) in
                maker.left.equalTo()(fv).offset()(32)
                maker.right.equalTo()(fv).offset()(-32)
                maker.centerY.equalTo()(fv)
                maker.height.equalTo()(40)
            })
            
            tableView?.tableFooterView          = fv
        }
        
        setupRefresh()
    }
    
    @objc private func addCardAction() {
        let addVc                               = UCAddBankCardViewController()
        addVc.userInfo                          = userInfo
        self.navigationController?.pushViewController(addVc, animated: true)
    }
    
    override func needRefrshData() -> Bool {
        return false
    }
    
    private func setupRefresh(){
        
        tableView?.removeHeader()
        weak var blockSelf = self
        tableView?.addHeaderWithCallback(callback:{
            blockSelf!.refreshData()
        })
    }
    
    private func endRefresh() {
        tableView?.headerEndRefreshing()
    }
    
}

//tableView DataSource & Delegate
extension UCBankCardListController : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bankCardCell", forIndexPath: indexPath) as! UCBankCardCell
        cell.bankCardInfo   = cardList[indexPath.row]
        cell.index          = indexPath.row
        cell.delegate       = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 138
    }
    
}

//UCBankCardCell delegate
extension UCBankCardListController : UCBankCardCellDelegate {
    
    func bankCardChoosenWithIndex(index: Int) {
        if optionType == .Select {
            callBack?(cardList[index])
            self.navigationController?.popViewControllerAnimated(true)
        }else{
            print(cardList[index].cardName)
        }
    }
}

//Net
extension UCBankCardListController {
    
    override func refreshData() {
        
        if let userData = Commond.getUserDefaults("userData") as? UCUserData {
            UCService.getUserBankCardList(userData.loginToken, completion: { (data) in
                self.endRefresh()
                if data?.cjxnfsCode == 10000 {
                    self.cardList = (data as! UCBankCardsData).cardList
                    self.showSelected()
                }else{
                    UtilTool.noticError(view: self.view, msg: data!.responseMsg!)
                }
                }, failure: { (error) in
                    self.endRefresh()
                    UtilTool.noticError(view: self.view, msg: error.msg!)
            })
        }else{
            endRefresh()
            UtilTool.noticError(view: self.view, msg: "未登录")
        }
    }
    
    private func showSelected() {
        if optionType == .Select {
            for d in cardList {
                if selectionData != nil {
                    if selectionData?.cardId == d.cardId {
                        d.isSelected    = true
                    }else{
                        d.isSelected    = false
                    }
                }else{
                    d.isSelected    = false
                }
            }
            
        }
        tableView?.reloadData()
    }
    
}
