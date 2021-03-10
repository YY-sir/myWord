//
//  FeedbackController.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/3/5.
//

import Foundation
import UIKit
class FeedbackController: UIViewController {
    var feedbackType: FeedbackType = .function
    var feedbackview:FeedbackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupView()
        addAction()
    }
    
//--------------------------------------------------------------------------------------------------
    fileprivate func setupNav(){
        self.gk_navTitle = "意见反馈"
        self.gk_navBackgroundColor = .clear
        self.gk_statusBarStyle = .lightContent
        self.gk_navTitleColor = .black
        self.gk_navLineHidden = true
        self.gk_backStyle = .black
    }
    
    fileprivate func setupView(){
        self.view.backgroundColor = .white
        feedbackview = FeedbackView(frame: self.view.bounds)
        self.view.addSubview(feedbackview)
    }
    
    fileprivate func addAction(){
        feedbackview.labelSegmented.addTarget(self, action: #selector(labelSegmentedAction(sender:)), for: .valueChanged)
        feedbackview.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hideBoard)))
        feedbackview.placeholder.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(placeholderDidTapped)))
        feedbackview.feedbackView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(placeholderDidTapped)))
        feedbackview.contentTextfield.delegate = self
    }
    
    
//--------------------------------------------------------------------------------------------------
//MARK: - UIControlEvents
    //反馈类型切换——分段控制器切换函数
    @objc func labelSegmentedAction(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            print("1")
            feedbackType = .function
        case 1:
            print("2")
            feedbackType = .performance
        case 2:
            print("3")
            feedbackType = .complaint
        default:
            print("4")
        }
    }
    
    //收起键盘
    @objc func hideBoard(){
        self.view.endEditing(true)
    }
    
    //输入框获得焦点
    @objc func placeholderDidTapped(_ sender: UITapGestureRecognizer)
    {
        if (sender.state == .ended) {
            feedbackview.placeholder.isHidden = true
            feedbackview.contentTextfield.isHidden = false
            if (!feedbackview.contentTextfield.isFirstResponder) {
                feedbackview.contentTextfield.becomeFirstResponder()
            }
        }
    }
}

//--------------------------------------------------------------------------------------------------
//MARK: - Delegate 和 DataSource
extension FeedbackController: UITextViewDelegate{

    func textViewDidEndEditing(_ textView: UITextView) {
        //输入内容为空和不为空时，textView显示隐藏处理
        feedbackview.placeholder.isHidden = feedbackview.contentTextfield.hasText
        feedbackview.contentTextfield.isHidden = !feedbackview.contentTextfield.hasText
    }
    
}
