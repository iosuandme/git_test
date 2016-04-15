//
//  UCBankPickerView.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/4/15.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

protocol UCBankPickerViewDelegate : NSObjectProtocol {
    func pickerViewDidSelectedWithName(name : String)
}

class UCBankPickerView: UIView , UIPickerViewDataSource , UIPickerViewDelegate {
    
    private var pickerView  : UIPickerView!
    var delegate            : UCBankPickerViewDelegate?
    var dataSource          : Array<String>! {
        didSet {
            if dataSource != nil {
                pickerView.reloadAllComponents()
            }
        }
    }
    var selectedIndex       : Int   = 0 {
        didSet {
            if dataSource != nil && dataSource.count > selectedIndex {
                pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor        = UIColor.whiteColor()
        
        let line                    = UIView()
        line.backgroundColor        = UtilTool.colorWithHexString("#ddd")
        self.addSubview(line)
        line.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
            maker.top.equalTo()(self)
            maker.height.equalTo()(1)
        }
        
        let cancelBtn               = BaseButton()
        cancelBtn.titleLabel?.font  = UIFont.systemFontOfSize(14)
        cancelBtn.setTitle("取消", forState: UIControlState.Normal)
        cancelBtn.setTitleColor(UtilTool.colorWithHexString("#a8a8a9"), forState: UIControlState.Normal)
        cancelBtn.addTarget(self, action: #selector(UCBankPickerView.cancelAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(cancelBtn)
        cancelBtn.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self).offset()(5)
            maker.top.equalTo()(line.mas_bottom)
            maker.width.equalTo()(60)
            maker.height.equalTo()(39)
        }
        
        let doneBtn                 = BaseButton()
        doneBtn.titleLabel?.font    = UIFont.systemFontOfSize(14)
        doneBtn.setTitle("完成", forState: UIControlState.Normal)
        doneBtn.setTitleColor(UtilTool.colorWithHexString("#53a0e3"), forState: UIControlState.Normal)
        doneBtn.addTarget(self, action: #selector(UCBankPickerView.doneAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(doneBtn)
        doneBtn.mas_makeConstraints { (maker) in
            maker.right.equalTo()(self).offset()(-5)
            maker.top.equalTo()(line.mas_bottom)
            maker.width.equalTo()(60)
            maker.height.equalTo()(39)
        }
        
        pickerView                          = UIPickerView()
        pickerView.dataSource               = self
        pickerView.delegate                 = self
        pickerView.showsSelectionIndicator  = true
        pickerView.backgroundColor          = UtilTool.colorWithHexString("#efefef")
        self.addSubview(pickerView)
        pickerView.mas_makeConstraints { (maker) in
            maker.left.equalTo()(self)
            maker.right.equalTo()(self)
            maker.top.equalTo()(doneBtn.mas_bottom)
            maker.bottom.equalTo()(self)
        }
        
    }
    
    @objc private func cancelAction() {
        dismiss()
    }
    
    @objc private func doneAction() {
        delegate?.pickerViewDidSelectedWithName(dataSource[pickerView.selectedRowInComponent(0)])
        dismiss()
    }
    
    func showInView(view : UIView) {
        self.frame          = CGRectMake(0, view.frame.size.height, view.frame.size.width, 240)
        view.addSubview(self)
        UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.frame.origin.y -= self.frame.size.height
        }) { (Bool) in
        }
    }
    
    private func dismiss() {
        UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { 
            self.frame.origin.y += self.frame.size.height
            }) { (Bool) in
                self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource == nil ? 0 : dataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let v               = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40))
        v.font              = UIFont.systemFontOfSize(14)
        v.textColor         = UtilTool.colorWithHexString("#666")
        v.textAlignment     = .Center
        v.text              = dataSource[row]
        return v
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        guard let v = super.hitTest(point, withEvent: event) else {
            dismiss()
            return nil
        }
        return v
    }
    

}
