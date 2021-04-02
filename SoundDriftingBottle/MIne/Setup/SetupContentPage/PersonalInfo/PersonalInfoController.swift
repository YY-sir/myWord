//
//  PersonalInfoController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/5.
//

import Foundation

class PersonalInfoController: UIViewController {
    //用于判断：注册页面跳转为：0 ； 设置页面跳转为；1
    var pageTo: Int!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    let labelArr = ["头像", "昵称", "性别", "生日", "个性签名" ,"完成"]
    
    var userFaceImg = ""
    var userSex = "无"
    var userBirthday = "无"
    
    var personalinfoview: PersonalInfoView!
    
    lazy var datePickerView: DatePickerView? = {
        let datePicker: DatePickerView = DatePickerView.init()
        datePicker.dateFormat = "yyyy年MM月dd日"
        self.view.addSubview(datePicker)
        return datePicker
    }()
    
//--------------------------------------------------------------------------------------------------
//MARK: - 钩子函数
    override func viewDidLoad() {
        super.viewDidLoad()
        print("页面：\(pageTo)")
        initData()
        setupNav()
        setupView()
        addAction()
    }
    
//--------------------------------------------------------------------------------------------------
//MARK: - setup
    fileprivate func  initData(){
        self.userFaceImg = app.userFaceImageUrl
        self.userSex = app.userSex
        self.userBirthday = app.userBirthday
    }
    
    fileprivate func setupNav(){
        self.gk_navTitle = "个人信息"
        self.gk_navBackgroundColor = .clear
        self.gk_statusBarStyle = .lightContent
        self.gk_navTitleColor = .black
        self.gk_navLineHidden = true
        self.gk_backStyle = .black
    }
    
    fileprivate func setupView(){
        self.view.backgroundColor = .white
        personalinfoview = PersonalInfoView(frame: mainCGRect())
        self.view.addSubview(personalinfoview)
    }
    
    fileprivate func addAction(){
        //添加手势和代理
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideBoard))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
        
        personalinfoview.contentTableView.delegate = self
        personalinfoview.nameTextField.delegate = self
        personalinfoview.personalTextField.delegate = self
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------
//MARK: - UIControllerEvent
    //收起键盘
    @objc func hideBoard(){
        self.view.endEditing(true)
    }
    
}

//---------------------------------------------------------------------------------------------------------------------------------------
//MARK: - Delegate 和 DataSource


extension PersonalInfoController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch labelArr[indexPath.row] {
        case "头像":
            return 100.0
        case "昵称":
            return 50.0
        case "性别":
            return 50.0
        case "生日":
            return 50.0
        case "个性签名":
            return 50.0
        default:
            return 60.0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)
        switch tableView.cellForRow(at: indexPath)?.textLabel?.text {
        case "头像":
            self.hideBoard()
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
            print("读取相册完毕")
            
        case "昵称":
            self.personalinfoview.nameTextField.becomeFirstResponder()
            
        case "性别":
            self.hideBoard()
            
            let alert = UIAlertController(title: "", message: "性别", preferredStyle: .actionSheet)
            let manchoose = UIAlertAction(title: "男", style: .default, handler: {_ in
                currentCell?.detailTextLabel?.text = "男"
                self.userSex = "男"
            })
            let wamanchoose = UIAlertAction(title: "女", style: .default, handler: {_ in
                currentCell?.detailTextLabel?.text = "女"
                self.userSex = "女"
            })
            let cancelchoose = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alert.addAction(manchoose)
            alert.addAction(wamanchoose)
            alert.addAction(cancelchoose)
            self.navigationController?.present(alert, animated: true, completion: nil)
            
        case "生日":
            self.hideBoard()
            datePickerView?.showDatePickView()
            datePickerView?.selectDatePicker((currentCell?.detailTextLabel?.text)!)
            self.datePickerView?.dateSelectedBlock = {[weak self] (dateString) in
                currentCell?.detailTextLabel!.text = dateString
                self?.userBirthday = dateString
            }
            
        case "个性签名":
            self.personalinfoview.personalTextField.becomeFirstResponder()
            
        case "完成":
            self.succesAction()
        default:
            self.hideBoard()
            
        }
        
    }
    
    //完成操作
    fileprivate func succesAction(){
        if trim(str: self.personalinfoview.nameTextField.text!) == ""{
            UIUtil.showHint("请输入昵称")
            self.personalinfoview.nameTextField.attributedPlaceholder = NSAttributedString.init(string:"请输入昵称", attributes: [NSAttributedString.Key.foregroundColor:LDColor(rgbValue: 0xff00000, al: 0.4)])
            return
        }
        
        //保存选项
        self.saveOptions()
        
        if self.pageTo == 0{
            self.navigationController?.popViewController(animated: true)
        }else{
            UIUtil.showHint("注册成功")
            let pickUpBottleVC = PickingUpBottlesController()
            self.navigationController?.pushViewController(pickUpBottleVC, animated: true)
        }
        print("succesAction")
    }
    
    //保存用户信息
    fileprivate func saveOptions(){
        app.userFaceImageUrl = self.userFaceImg
        app.userName = self.personalinfoview.nameTextField.text ?? ""
        app.userSex = self.userSex
        app.userBirthday = self.userBirthday
        app.userPersonalText = self.personalinfoview.personalTextField.text ?? ""
    }
}

extension PersonalInfoController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //获取选择的原图
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
         
        //将选择的图片保存到Document目录下
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)[0] as String
        var filePath = ""
        if app.userFaceImageUrl == "\(rootPath)/faceImage1.jpg"{
            filePath = "\(rootPath)/faceImage0.jpg"
        }else{
            filePath = "\(rootPath)/faceImage1.jpg"
        }
         
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
        print("userFaceImageUrl:\(filePath)")
        self.userFaceImg = filePath
        self.personalinfoview.faceImage.image = UIImage.init(contentsOfFile: self.userFaceImg)

        //图片控制器退出
        picker.dismiss(animated: true, completion:nil)
    }
}

extension PersonalInfoController: UIGestureRecognizerDelegate{
    //添加手势代理，如果点击cell则不触发
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("输入的点击的view的类名：\(touch.view?.classForCoder)")
        if touch.view?.superview?.classForCoder == UITableViewCell().classForCoder{
            return false
        }
        return true
    }
}

extension PersonalInfoController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideBoard()
        return true
    }
}
