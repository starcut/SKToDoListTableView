//
//  PickerEditView.swift
//  PickerEditView
//
//  Created by 清水 脩輔 on 2019/04/19.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit
import FSCalendar

protocol PickerEditViewDelegate {
    func adjustEditViewHeight(height: CGFloat)
    
    func changeDate(dateString: String)
    
    func changeTime(timeString: String)
}

extension PickerEditViewDelegate {
    func adjustEditViewHeight(height: CGFloat) {}
    
    func changeDate(dateString: String) {}
    
    func changeTime(timeString: String) {}
}

class PickerEditView: UIView {
    // カレンダー
    @IBOutlet weak var calendar: FSCalendar!
    // 時間のPicker
    @IBOutlet weak var timePicker: UIDatePicker!
    // カレンダーのBaseView
    @IBOutlet weak var calendarBaseView: UIView!
    // 時間のPickerのBaseView
    @IBOutlet weak var timePickerBaseView: UIView!
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
        
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        self.calendarBaseView.isHidden = true
        self.timePickerBaseView.isHidden = true
    }
    
    func displayCalendarButton() {
        self.calendarBaseView.isHidden = !self.calendarBaseView.isHidden
        
        var height: CGFloat = 0.0
        if !self.calendarBaseView.isHidden {
            height = self.calendarHeight.constant
        }
        self.timePickerBaseView.isHidden = true
        UIView.animate(withDuration: ANIMATION_DURATION,
                       animations: {
                        self.delegate?.adjustEditViewHeight(height: height)
        }, completion: nil)
    }
    
    func displayTimePickerButton() {
        self.calendarBaseView.isHidden = true
        self.timePickerBaseView.isHidden = !self.timePickerBaseView.isHidden
        
        var height: CGFloat = 0.0
        if !self.timePickerBaseView.isHidden {
            height = self.timePickerHeight.constant
        }
        UIView.animate(withDuration: ANIMATION_DURATION,
                       animations: {
                        self.delegate?.adjustEditViewHeight(height: height)
        }, completion: nil)
    }
    
    /// datePickerの値が変更されたら呼ばれる
    @IBAction private func didValueChangedDatePicker(_ sender: UIDatePicker) {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        self.delegate?.changeTime(timeString: formatter.string(from: sender.date))
    }
}

extension PickerEditView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.layoutIfNeeded()
        self.calendar.frame = self.calendarBaseView.bounds
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "YYYY/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
        self.delegate?.changeDate(dateString: formatter.string(from: date))
    }
}

extension PickerEditView: FSCalendarDataSource {
    
}
