//
//  PersonalInfoController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/5.
//

import Foundation

class PersonalInfoController: UIViewController {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    let labelArr = ["头像", "昵称", "性别", "生日", "个性签名" ,"完成"]
    
    var personalinfoview: PersonalInfoView!
    
//--------------------------------------------------------------------------------------------------
//MARK: - 钩子函数
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupNav()
        setupView()
        addAction()
    }
    
//--------------------------------------------------------------------------------------------------
//MARK: - setup
    fileprivate func  initData(){

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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.cellForRow(at: indexPath)?.textLabel?.text {
        case "头像":
            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
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
            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
        case "性别":
            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
        case "生日":
            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
        case "个性签名":
            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
        default:
            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
        }
        
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
        let filePath = "\(rootPath)/faceImage.jpg"
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
        print("faceImageURL:\(filePath)")
        app.faceImageUrl = filePath
        self.personalinfoview.faceImage.image = UIImage.init(contentsOfFile: app.faceImageUrl)

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
