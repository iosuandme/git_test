//
//  SelectedSegmentedBar.swift
//  quchaogu
//
//  Created by zhangyr on 15/6/23.
//  Copyright (c) 2015年 quchaogu. All rights reserved.
//

import UIKit


@objc protocol SelectedSegmentedBarDelegate : NSObjectProtocol {
    
    func selectedItemForSegmentedBar(segmentedBar : SelectedSegmentedBar , selectedSegmentedIndex : Int)
    
}

class SelectedSegmentedBar: UIView {
    
    private weak var delegate : SelectedSegmentedBarDelegate!
    private var lastBtn : BaseButton!
    private var selectedLabel : UILabel!
    var index : Int = 0 {
        willSet{
            if index != newValue {
                let btn = self.viewWithTag(newValue) as! BaseButton
                selectedLabel.frame.origin.x = CGFloat(btn.tag) * btn.bounds.width
                btn.setTitleColor(UtilTool.colorWithHexString("#666"), forState: UIControlState.Normal)
                lastBtn.setTitleColor(UtilTool.colorWithHexString("#a3a3a3"), forState: UIControlState.Normal)
                lastBtn = btn
            }
        }
    }

    init(frame: CGRect , items : [AnyObject] , delegate : SelectedSegmentedBarDelegate) {
        super.init(frame: frame)
        self.delegate        = delegate
        self.backgroundColor = UIColor.whiteColor()
        let btnW = frame.size.width / CGFloat(items.count)
        let btnH = frame.size.height - 2
        for i in 0 ..< items.count {
           
            let btn = BaseButton(frame: CGRect(x: CGFloat(i) * btnW, y: 0, width: btnW, height: btnH))
            btn.tag = i
            btn.setTitle(items[i] as? String, forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(12)
            btn.setTitleColor(UtilTool.colorWithHexString("#a3a3a3"), forState: UIControlState.Normal)
            if i == 0 {
                btn.setTitleColor(UtilTool.colorWithHexString("#666"), forState: UIControlState.Normal)
                lastBtn = btn
            }
            btn.addTarget(self, action: #selector(SelectedSegmentedBar.selectedItem(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(btn)
        }
        
        selectedLabel = UILabel(frame: CGRect(x: 0, y: btnH, width: btnW, height: 2))
        selectedLabel.backgroundColor = UtilTool.colorWithHexString("#53a0e3")
        self.addSubview(selectedLabel)
    }
    
    func selectedItem(btn : BaseButton) {
        
        if btn !== lastBtn {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.selectedLabel.frame.origin.x = CGFloat(btn.tag) * btn.bounds.width
                }) { (Bool) -> Void in
                    
                    btn.setTitleColor(UtilTool.colorWithHexString("#666"), forState: UIControlState.Normal)
                    self.delegate.selectedItemForSegmentedBar(self, selectedSegmentedIndex: btn.tag)
                    self.lastBtn.setTitleColor(UtilTool.colorWithHexString("#a3a3a3"), forState: UIControlState.Normal)
                    self.lastBtn = btn
            }
        }
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
