//
//  DatePickerView.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/11.
//

import UIKit

typealias DateSelectedBlock = (_ dateString: String) -> ()

class DatePickerView: UIView {

    @objc var dateSelectedBlock: DateSelectedBlock?
    
    var datePicker: UIDatePicker?
    
    var contentDatePicker: UIView?
    
    var contentDateView: UIView?
    
    var dateFormat: String?
    
    lazy var dateFormatter: DateFormatter? = {
        let dateF: DateFormatter = DateFormatter.init()
        dateF.dateFormat = dateFormat?.count ?? 0 > 0 ? dateFormat : "yyyy-MM-dd"
        return dateF
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        createDatePicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 时间选择器
    func createDatePicker() {
        let pickerHeight: CGFloat = 212
        let areaBottomH: CGFloat = CommonOne().bottomPadding
        contentDatePicker = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        contentDatePicker?.backgroundColor = .clear
        
        contentDateView = UIView(frame: CGRect(x: 0, y: kScreenH-pickerHeight-44, width: kScreenW, height: pickerHeight+44+areaBottomH))
        contentDateView?.backgroundColor = .white
        contentDatePicker?.addSubview(contentDateView!)
        
        datePicker = UIDatePicker()
        contentDateView?.addSubview(datePicker!)
        datePicker?.snp.makeConstraints{(make) in
            make.height.equalTo(pickerHeight)
            make.top.equalTo(44)
            make.left.right.equalToSuperview()
        }
        
        let toolbarView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 44))
        toolbarView.sizeToFit()
        
        let tipLabel = UILabel()
        tipLabel.text = "请选择生日"
        tipLabel.textColor = LDColor(rgbValue: 0x222222, al: 1)
        tipLabel.font.withSize(16.0)
        tipLabel.textAlignment = .center
        toolbarView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        toolbarView.backgroundColor = .white
        datePicker?.backgroundColor = .white
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font.withSize(14.0)
        cancelBtn.setTitleColor(LDColor(rgbValue: 0x111111, al: 1), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        toolbarView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(44)
        }
        
        let okBtn = UIButton()
        okBtn.setTitle("确定", for: .normal)
        okBtn.titleLabel?.font.withSize(14.0)
        okBtn.setTitleColor(LDColor(rgbValue: 0x111111, al: 1), for: .normal)
        okBtn.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        toolbarView.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(44)
        }
        
        contentDateView?.addSubview(toolbarView)
        
        datePicker?.datePickerMode = .date
        let locale: Locale = Locale.init(identifier: "zh_CN")
        datePicker?.locale = locale
        if #available(iOS 13.4, *) {
            datePicker?.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
//        var comps: DateComponents = DateComponents()
//        comps.year = -50
        let calendar: Calendar = Calendar.current
        datePicker?.calendar = calendar
        let showDate: Date? = self.dateFormatter?.date(from: "2000-01-01")
        datePicker?.setDate(showDate ?? Date(), animated: false)
        datePicker?.minimumDate = self.dateFormatter?.date(from: "1970-01-01") // calendar.date(byAdding: comps, to: Date())
        datePicker?.maximumDate = Date()
        datePicker?.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
//        let dateTap = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
//        contentDatePicker?.addGestureRecognizer(dateTap)
        
    }
    
    // MARK: - touch
    @objc func cancelClick() {
        self.dismissDatePickView()
    }
    
    @objc func doneClick() {
        if self.anySubViewScrolling(self.datePicker!) {
            return
        }
        self.dismissDatePickView()
        let date = datePicker?.date
        self.dateFormatter?.dateFormat = dateFormat?.count ?? 0 > 0 ? dateFormat : "yyyy-MM-dd"
        let dateString: String? = self.dateFormatter?.string(from: date ?? Date())
        if (self.dateSelectedBlock != nil) {
            self.dateSelectedBlock!(dateString ?? "")
            self.dateSelectedBlock = nil
        }
    }
    
    @objc func dateChange() {
        // to do...
        datePicker?.setDate(datePicker?.date ?? Date(), animated: false)
    }
    
    @objc func selectDatePicker(_ dateString: String) {
        let currentDate: String = dateString
        let date = dateFormatter?.date(from: currentDate)
        if (date != nil) {
            datePicker?.setDate(date!, animated: false)
        }
    }
    
    // MARK: - 年月日只展示距今满year年的，其他年份不可选
    @objc func dateByAddingToMaxDate(_ year: Int) {
        let calendar: Calendar = Calendar.current
        var comps: DateComponents = DateComponents()
        comps.year = -year
        datePicker?.maximumDate = calendar.date(byAdding: comps, to: Date())
    }
    
    func anySubViewScrolling(_ view: UIView) -> Bool {
        if view.isKind(of: UIScrollView.self) {
            let scrollView: UIScrollView = view as! UIScrollView
            if scrollView.isDragging || scrollView.isDecelerating {
                return true
            }
        }
        for subView in view.subviews {
            if self.anySubViewScrolling(subView) {
                return true
            }
        }
        return false
    }
    
    // MARK: - 设置
//    @objc func dismiss() {
//        self.dismissDatePickView()
//    }
    
    var matchKey :String!
    
    // MARK: - 显示datePick
    @objc func showDatePickView() {
        UIApplication.shared.keyWindow?.addSubview(contentDatePicker!)
        let areaBottomH: CGFloat = CommonOne().bottomPadding
        if #available(iOS 13.4, *) {
//            datePicker?.centerX = self.contentDateView!.frame.size.width * 0.5
        } else {
            // Fallback on earlier versions
        }
        UIView.animate(withDuration: 0.2) {
            self.contentDateView?.frame = CGRect(x: 0, y: kScreenH - self.datePicker!.frame.size.height - 44 - areaBottomH, width: self.contentDateView!.frame.size.width, height: self.contentDateView!.frame.size.height)
            self.contentDatePicker!.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        }
    }
    
    // MARK: - 隐藏datePick
    @objc func dismissDatePickView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentDateView?.frame = CGRect(x: 0, y: kScreenH, width: self.contentDateView!.frame.size.width, height: self.contentDateView!.frame.size.height)
            self.contentDatePicker!.backgroundColor = .clear
        }) { (completed) in
            self.contentDatePicker?.removeFromSuperview()
        }
    }

}
