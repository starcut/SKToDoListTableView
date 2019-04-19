//
//  PickerEditView.swift
//  PickerEditView
//
//  Created by 清水 脩輔 on 2019/04/19.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

protocol PickerEditViewDelegate {
    func adjustEditViewHeight(height: CGFloat)
}

extension PickerEditViewDelegate {
    func adjustEditViewHeight(height: CGFloat) {}
}

class PickerEditView: UIView {
    // カレンダー
    @IBOutlet weak var calendar: CFCalendar!
    // 時間のPicker
    @IBOutlet weak var timePicker: UIDatePicker!
    // カレンダーのBaseView
    @IBOutlet weak var calendarBaseView: UIView!
    // 時間のPickerのBaseView
    @IBOutlet weak var timePickerBaseView: UIView!
    // ヘッダー部分の高さ
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    // カレンダーの高さ
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    // 時間のPickerの高さ
    @IBOutlet weak var timePickerHeight: NSLayoutConstraint!
    
    var delegate: PickerEditViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)),
                                            owner: self,
                                            options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        self.calendarBaseView.isHidden = true
        self.timePickerBaseView.isHidden = true
    }
    
    @IBAction private func pushedCalendarButton() {
        self.calendarBaseView.isHidden = !self.calendarBaseView.isHidden
        self.timePickerBaseView.isHidden = true
        UIView.animate(withDuration: ANIMATION_DURATION,
                       animations: {
                        self.delegate?.adjustEditViewHeight(height: self.headerHeight.constant + self.calendarHeight.constant)
        }, completion: nil)
    }
    
    @IBAction private func pushedTimePickerButton() {
        self.calendarBaseView.isHidden = true
        self.timePickerBaseView.isHidden = !self.timePickerBaseView.isHidden
        UIView.animate(withDuration: ANIMATION_DURATION,
                       animations: {
                        self.delegate?.adjustEditViewHeight(height: self.headerHeight.constant + self.timePickerHeight.constant)
        }, completion: nil)
        
    }
}
