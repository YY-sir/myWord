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
    var photoUrlArr: [String]!
    var photoGap: Float!
    var photoSize: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupNav()
        setupView()
        addAction()
    }
    
//--------------------------------------------------------------------------------------------------
    fileprivate func  initData(){
        photoUrlArr = [String]()
        photoSize = 90.0
        photoGap = (Float(UIScreen.main.bounds.width) - 60.0 - 20.0 - 3 * photoSize)  / 2 + photoSize
    }
    
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
        feedbackview.pushPhotoBtn.addTarget(self, action: #selector(pushPhotoBtnAction), for: .touchUpInside)
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
    
    //获取图片
    @objc func pushPhotoBtnAction(){
        if self.photoUrlArr.count >= 3{
            UIUtil.showHint("最多只能上传三张照片哦~")
            return
        }
        
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = .photoLibrary
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
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

extension FeedbackController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //获取选择的原图
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
         
        //将选择的图片保存到Document目录下
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage\(self.photoUrlArr.count).jpg"
        let imageData = pickedImage.jpegData(compressionQuality: 1.0)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
         
        //上传图片
        if (fileManager.fileExists(atPath: filePath)){
            //取得NSURL
            let imageURL = URL(fileURLWithPath: filePath)
             
            //使用Alamofire上传
//            Alamofire.upload(imageURL, to: "http://www.hangge.com/upload.php")
//                .responseString { response in
//                    print("Success: \(response.result.isSuccess)")
//                    print("Response String: \(response.result.value ?? "")")
//            }
        }
        
        //将照片地址加入数组
        print("imageURL:\(filePath)")
        self.photoUrlArr.append(filePath)
        //显示上传的照片
        showPushPhotos()
        
    
        //图片控制器退出
        picker.dismiss(animated: true, completion:nil)
    }
    
    //显示新上传的照片
    fileprivate func showPushPhotos(){
        let itemImage = UIImageView()
        itemImage.image = UIImage.init(named: self.photoUrlArr[(self.photoUrlArr.count - 1)])
        self.feedbackview.photoShowView.addSubview(itemImage)
        itemImage.snp.makeConstraints{(make) in
            make.width.height.equalTo(photoSize)
            make.top.equalToSuperview()
            make.left.equalTo((Float)(self.photoUrlArr.count - 1) * photoGap)
        }
        
        let deleteBtn = UIButton()
        deleteBtn.setBackgroundImage(UIImage.init(named: "shanchu3"), for: .normal)
        self.feedbackview.photoShowView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints{(make) in
            make.width.height.equalTo(20)
            make.top.equalTo(-5)
            make.left.equalTo((Float)(self.photoUrlArr.count - 1) * photoGap + 90 - 15)
        }
        deleteBtn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }
    
    //
    @objc func deleteAction(sender: UIButton){
        print("删除对应照片")
    }
    
}
