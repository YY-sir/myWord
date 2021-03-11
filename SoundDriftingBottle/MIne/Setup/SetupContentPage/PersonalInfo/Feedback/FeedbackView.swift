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
    //用于判断：播放转为：0 ； 设置页面跳转为；1
    var pageTo: Int!
    
    var horizonGap: Float!
    var UIwidth: Float!
    
    var photoGap: Float!
    var photoSize: Float!
    
    let mainScrollView: UIScrollView = UIScrollView()
    
    var labelArr1 = ["功能问题", "性能问题"]
    var labelArr2 = ["功能问题", "性能问题", "用户投诉"]
    var labelSegmented: UISegmentedControl!
    
    var feedbackView = UIView()
    var contentTextfield: UITextView!
    var placeholder: UITextView!
    
    let photoView = UIView()
    let pushPhotoBtn = UIButton()
    let photoShowView = UIView()
    var photoImages = [UIImageView]()
    let photoImage1 = UIImageView()
    let photoImage2 = UIImageView()
    let photoImage3 = UIImageView()
    var deleteBtns = [UIButton]()
    let deleteBtn1 = UIButton()
    let deleteBtn2 = UIButton()
    let deleteBtn3 = UIButton()
    
    let submitBtn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
    }
    
    convenience init(frame: CGRect, page: Int){
        self.init(frame: frame)
        pageTo = page
        initData()
        setupView()
        setupFeedbackView()
        setupphotoView()
        setupPhotoShowView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initData(){
        horizonGap = 30.0
        UIwidth = Float(kScreenW - 60.0)
        photoSize = (Float(UIScreen.main.bounds.width) - 60.0 - 20.0 - 20.0) / 3
        photoGap = 10.0 + photoSize
    }
    
    fileprivate func setupView(){
        self.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints{(make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(CommonOne().topPadding + 44.0)
        }
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: 610)
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.delaysContentTouches = false
        
        print("222:\(pageTo)")
        if pageTo == 0{
            labelSegmented = UISegmentedControl(items: labelArr1)
        }else{
            labelSegmented = UISegmentedControl(items: labelArr2)
        }
        labelSegmented.selectedSegmentIndex = 0
        mainScrollView.addSubview(labelSegmented)
        labelSegmented.snp.makeConstraints{(make) in
            make.height.equalTo(50)
            make.width.equalTo(UIwidth)
            make.left.equalTo(horizonGap)
            make.top.equalTo(30)
        }
        
        mainScrollView.addSubview(feedbackView)
        feedbackView.layer.borderWidth = 1
        feedbackView.layer.borderColor = CGColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        feedbackView.layer.cornerRadius = 3
        feedbackView.layer.masksToBounds = true
        feedbackView.snp.makeConstraints{(make) in
            make.height.equalTo(200)
            make.width.equalTo(UIwidth)
            make.left.equalTo(horizonGap)
            make.top.equalTo(labelSegmented.snp.bottom).offset(25)
        }
        
        mainScrollView.addSubview(photoView)
        photoView.layer.borderWidth = 1
        photoView.layer.borderColor = CGColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        photoView.layer.cornerRadius = 3
        photoView.snp.makeConstraints{(make) in
//            make.height.equalTo(160)
            make.width.equalTo(UIwidth)
            make.left.equalTo(horizonGap)
            make.top.equalTo(feedbackView.snp.bottom).offset(25)
        }
        
        mainScrollView.addSubview(submitBtn)
        submitBtn.layer.cornerRadius = 4
        submitBtn.layer.masksToBounds = true
        submitBtn.setTitle("提交", for: .normal)
        submitBtn.setTitleColor(LDColor(rgbValue: 0x000000, al: 1), for: .normal)
        submitBtn.setBackgroundImage(imageWithColor(color: LDColor(rgbValue: 0x87CEFA, al: 1)), for: .normal)
        submitBtn.snp.makeConstraints{(make) in
            make.height.equalTo(50)
            make.width.equalTo(UIwidth)
            make.left.equalTo(horizonGap)
            make.top.equalTo(photoView.snp.bottom).offset(25)
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
    
    fileprivate func setupphotoView(){
        photoView.addSubview(pushPhotoBtn)
        pushPhotoBtn.backgroundColor = .white
        pushPhotoBtn.setTitle("上传照片", for: .normal)
        pushPhotoBtn.setTitleColor(.black, for: .normal)
        pushPhotoBtn.setTitleColor(.gray, for: .highlighted)
        pushPhotoBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 30)
        pushPhotoBtn.setImage(UIImage(named: "appIcon"), for: .normal)
        pushPhotoBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 90, bottom: 0, right: 0)
        pushPhotoBtn.snp.makeConstraints{(make) in
            make.left.top.equalTo(10)
            make.height.equalTo(30)
            make.width.equalTo(120)
        }
        
        photoView.addSubview(photoShowView)
        photoShowView.snp.makeConstraints{(make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(pushPhotoBtn.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
        
    }
    
    fileprivate func setupPhotoShowView(){
        self.photoImages.append(photoImage1)
        self.photoImages.append(photoImage2)
        self.photoImages.append(photoImage3)
        self.deleteBtns.append(deleteBtn1)
        self.deleteBtns.append(deleteBtn2)
        self.deleteBtns.append(deleteBtn3)
        
        for (index, _) in photoImages.enumerated(){
            photoShowView.addSubview(photoImages[index])
            photoImages[index].snp.makeConstraints{(make) in
                make.width.height.equalTo(photoSize)
                make.top.equalToSuperview()
                make.left.equalTo((Float)(index) * photoGap)
            }
            photoImages[index].isHidden = true
            
            photoShowView.addSubview(deleteBtns[index])
            deleteBtns[index].setBackgroundImage(UIImage.init(named: "shanchu3"), for: .normal)
            deleteBtns[index].snp.makeConstraints{(make) in
                make.width.height.equalTo(20)
                make.top.equalTo(-5)
                make.left.equalTo((Float)(index) * photoGap + self.photoSize - 15)
            }
            deleteBtns[index].isHidden = true
        }
    }
    
}
