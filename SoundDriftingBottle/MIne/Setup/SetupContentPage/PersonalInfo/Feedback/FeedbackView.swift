//
//  FeedbackView.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/3/5.
//

import Foundation
import UIKit

//反馈的类型
enum FeedbackType: Int {
    case function = 0   //功能
    case performance    //性能
    case complaint  //投诉
}

class FeedbackView: UIView {
    var labelArr = ["功能问题", "性能问题", "用户投诉"]
    var labelSegmented: UISegmentedControl!
    
    var feedbackView = UIView()
    var contentTextfield: UITextView!
    var placeholder: UITextView!
    
    let photoView = UIView()
    let pushPhotoBtn = UIButton()
    let submitBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupFeedbackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        labelSegmented = UISegmentedControl(items: labelArr)
        labelSegmented.selectedSegmentIndex = 0
        self.addSubview(labelSegmented)
        labelSegmented.snp.makeConstraints{(make) in
            make.height.equalTo(50)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(CommonOne().topPadding + 44.0 + 40)
        }
        
        self.addSubview(feedbackView)
        feedbackView.layer.borderWidth = 1
        feedbackView.layer.borderColor = CGColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        feedbackView.layer.cornerRadius = 3
        feedbackView.layer.masksToBounds = true
        feedbackView.snp.makeConstraints{(make) in
            make.height.equalTo(200)
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(labelSegmented.snp.bottom).offset(25)
        }
       
    }
    
    fileprivate func setupFeedbackView(){
        contentTextfield = UITextView()
        feedbackView.addSubview(contentTextfield)
        contentTextfield.snp.makeConstraints{(make) in
            make.top.right.bottom.left.equalToSuperview()
        }
        contentTextfield.isHidden = true

        placeholder = UITextView()
        feedbackView.addSubview(placeholder)
        placeholder.snp.makeConstraints{(make) in
            make.top.right.left.equalToSuperview()
            make.height.equalTo(25)
        }
        placeholder.isEditable = false
        placeholder.isScrollEnabled = false
        placeholder.text = "请写下内容，我们将及时为您解决！"
        placeholder.textColor = LDColor(rgbValue: 0xbbbbbb, al: 1)
        
    }
    
}

