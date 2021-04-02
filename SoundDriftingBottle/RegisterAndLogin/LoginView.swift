//
//  Login.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/26.
//

import Foundation
import UIKit
class LoginView: UIView {
    let boxView : UIView = UIView()
    
    let topView: UIView = UIView()
    let topSelectView: UIView = UIView()
    let section1: UIButton = UIButton()
    let section2: UIButton = UIButton()
    
    let number: UILabel = UILabel()
    let password: UILabel = UILabel()
    let numberT : UITextField = UITextField1()
    let passwordT : UITextField = UITextField1()
    let confirmL : UILabel = UILabel()
    let confirmT : UITextField = UITextField1()
    let verificationL : UILabel = UILabel()
    let verificationT : UITextField = UITextField1()
    let verificationB : UIButton = UIButton()
    let numberView: UIView = UIView()
    let passwordView: UIView = UIView()
    let confirmView: UIView = UIView()
    let verificationView: UIView = UIView()
    let loginButton : UIButton = UIButton()
    let registerButton : UIButton = UIButton()
    let forgetPasswordButton : UIButton = UIButton()
    
    let bottomView : UIView = UIView()
    var timer : Timer!
    var isAnimattion = false
    var isKeyboard = false
    
    var boxViewH: CGFloat!
    var boxViewBottom: CGFloat!
    
    var boxViewWidth = ScreenWidth - 100 * ScreenWidth / 375
    var paddingNum = 15 * ScreenWidth / 375
    var scaleNum = kScreenH / 812
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBoxView()
        setupTopView()
        setupContentView()
        setupButtonAction()
        setupKeyboardAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupBoxView(){
        self.addSubview(boxView)
        boxViewH = 240
        boxViewBottom = (self.frame.height - boxViewH) / 2
        boxView.backgroundColor = LDColor(rgbValue: 0xdddddd, al: 1)
        boxView.layer.cornerRadius = 5
        boxView.clipsToBounds = true
        boxView.snp.makeConstraints {(make) in
            make.width.equalTo(boxViewWidth)
            make.height.equalTo(boxViewH)
            make.center.equalToSuperview()
        }
        
        boxView.addSubview(topView)
        topView.snp.makeConstraints {(make) in
            make.height.equalTo(50)
            make.left.top.right.equalToSuperview()
        }
        
        boxView.addSubview(bottomView)
        bottomView.backgroundColor = LDColor(rgbValue: 0xcccccc, al: 1)
        bottomView.alpha = 1
        bottomView.snp.makeConstraints {(make) in
            make.right.left.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
        boxView.addSubview(loginButton)
        loginButton.setTitle("登陆", for: .normal)
        loginButton.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 20.0, weight: UIFont.Weight(rawValue: 400))
        loginButton.backgroundColor = LDColor(rgbValue: 0x6495ED, al: 1)
        boxView.bringSubviewToFront(loginButton)
        loginButton.snp.makeConstraints {(make) in
            make.bottom.right.left.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    fileprivate func setupTopView(){
        
        topView.addSubview(topSelectView)
        topSelectView.backgroundColor = LDColor(rgbValue: 0x6495ED, al: 1)
        topSelectView.snp.makeConstraints {(make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(boxViewWidth / 2)
        }
        
        topView.addSubview(section1)
        section1.setTitle("登陆", for: .normal)
        self.section1.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 20.0, weight: UIFont.Weight(rawValue: 400))
        section1.setTitleColor(LDColor(rgbValue: 0x6495ED, al: 1), for: .normal)
        section1.snp.makeConstraints {(make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(boxViewWidth / 2)
        }
        
        topView.addSubview(section2)
        section2.setTitle("注册", for: .normal)
        self.section2.setTitleColor(UIColor.white, for: .normal)
        self.section2.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: UIFont.Weight(rawValue: 200))
        section2.setTitleColor(UIColor.white, for: .normal)
        section2.snp.makeConstraints {(make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(boxViewWidth / 2)
        }
    }
    
    fileprivate func setupContentView(){
        //账号
        boxView.addSubview(numberView)
        numberView.snp.makeConstraints {(make) in
            make.height.equalTo(40)
            make.top.equalTo(75)
            make.left.equalTo(paddingNum)
            make.right.equalTo(-paddingNum)
        }
        
        numberView.addSubview(number)
        number.text = "账号: "
        number.snp.makeConstraints {(make) in
            make.width.equalTo(50)
            make.left.height.equalToSuperview()
        }
        
        numberView.addSubview(numberT)
        numberT.backgroundColor = UIColor.white
        numberT.layer.cornerRadius = 3
        numberT.clipsToBounds = true
        numberT.placeholder = "请输入账号"
        numberT.clearButtonMode = .always
        numberT.returnKeyType = .next
        numberT.delegate = self
        numberT.snp.makeConstraints {(make) in
            make.left.equalTo(number.snp.right)
            make.right.height.equalToSuperview()
        }
        
        //密码
        boxView.addSubview(passwordView)
        passwordView.snp.makeConstraints {(make) in
            make.left.equalTo(paddingNum)
            make.right.equalTo(-paddingNum)
            make.height.equalTo(40)
            make.top.equalTo(135)
        }
        
        passwordView.addSubview(password)
        password.text = "密码: "
        password.snp.makeConstraints {(make) in
            make.width.equalTo(50)
            make.left.height.equalToSuperview()
        }
        
        passwordView.addSubview(passwordT)
        passwordT.backgroundColor = UIColor.white
        passwordT.layer.cornerRadius = 3
        passwordT.clipsToBounds = true
        passwordT.placeholder = "请输入密码"
        passwordT.clearButtonMode = .always
        passwordT.isSecureTextEntry = true
        passwordT.returnKeyType = .done
        passwordT.delegate = self
        passwordT.snp.makeConstraints {(make) in
            make.left.equalTo(password.snp.right)
            make.right.height.equalToSuperview()
        }
        
        //确认密码
        boxView.addSubview(confirmView)
        confirmView.alpha = 0
        confirmView.snp.makeConstraints {(make) in
            make.left.equalTo(paddingNum)
            make.right.equalTo(-paddingNum)
            make.height.equalTo(0)
            make.top.equalTo(195)
        }
        
        confirmView.addSubview(confirmL)
        confirmL.text = "确认密码: "
        confirmL.snp.makeConstraints {(make) in
            make.left.height.equalToSuperview()
            make.width.equalTo(78.5)
        }

        confirmView.addSubview(confirmT)
        confirmT.backgroundColor = UIColor.white
        confirmT.layer.cornerRadius = 3
        confirmT.clipsToBounds = true
        confirmT.placeholder = "请输入密码"
        confirmT.clearButtonMode = .always
        confirmT.isSecureTextEntry = true
        confirmT.returnKeyType = .next
        confirmT.delegate = self
        confirmT.snp.makeConstraints {(make) in
            make.left.equalTo(confirmL.snp.right)
            make.right.height.equalToSuperview()
        }
        
        //验证码
        boxView.addSubview(verificationView)
        verificationView.alpha = 0
        verificationView.snp.makeConstraints {(make) in
            make.left.equalTo(paddingNum)
            make.right.equalTo(-paddingNum)
            make.height.equalTo(0)
            make.top.equalTo(255)
        }
        
        verificationView.addSubview(verificationL)
        verificationL.text = "验证码: "
        verificationL.snp.makeConstraints {(make) in
            make.left.height.equalToSuperview()
            make.width.equalTo(61)
        }
        
        verificationView.addSubview(verificationB)
        verificationB.setTitle("获取", for: .normal)
//        verificationB.setBackgroundImage(UIImage(named: "buttonBackGround"), for: .normal)
        verificationB.backgroundColor = LDColor(rgbValue: 0x6495ED, al: 1)
        verificationB.layer.cornerRadius = 3
        verificationB.clipsToBounds = true
        verificationB.snp.makeConstraints {(make) in
            make.right.height.equalToSuperview()
            make.width.equalTo(70)
        }

        verificationView.addSubview(verificationT)
        verificationT.backgroundColor = UIColor.white
        verificationT.layer.cornerRadius = 3
        verificationT.clipsToBounds = true
        verificationT.keyboardType = .numberPad
        verificationT.delegate = self
        verificationT.snp.makeConstraints {(make) in
            make.left.equalTo(verificationL.snp.right)
            make.right.equalTo(verificationB.snp.left).offset(-10)
            make.height.equalToSuperview()
        }

    }
    
    
    fileprivate func setupButtonAction(){
        section1.addTarget(self, action: #selector(topButtonAction(sender:)), for: .touchDown)
        section2.addTarget(self, action: #selector(topButtonAction(sender:)), for: .touchDown)
    }
    
    @objc func topButtonAction(sender: UIButton){
        self.isAnimattion = false
        switch sender {
        case section1:
            print("登陆")
            self.passwordT.returnKeyType = .done
            
            boxViewH = 240
            boxViewBottom = self.isKeyboard ? boxViewBottom : (self.frame.height - boxViewH) / 2
            UIView.animate(withDuration: 0.6, animations: {
                self.boxView.snp.remakeConstraints {(make) in
                    make.width.equalTo(self.boxViewWidth)
                    make.height.equalTo(self.boxViewH)
                    make.center.equalToSuperview()
                }
                self.section2.setTitleColor(UIColor.white, for: .normal)
                self.section2.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: UIFont.Weight(rawValue: 200))
                self.section1.setTitleColor(LDColor(rgbValue: 0x6495ED, al: 1), for: .normal)
                self.section1.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 20.0, weight: UIFont.Weight(rawValue: 400))
                self.loginButton.setTitle("登陆", for: .normal)
                self.topSelectView.snp.remakeConstraints {(make) in
                    make.top.right.bottom.equalToSuperview()
                    make.width.equalTo(self.boxViewWidth / 2)
                }
                
                self.confirmView.alpha = 0
                self.confirmView.snp.remakeConstraints {(make) in
                    make.left.equalTo(self.paddingNum)
                    make.right.equalTo(-self.paddingNum)
                    make.height.equalTo(0)
                    make.top.equalTo(195)
                }
                
                self.verificationView.alpha = 0
                self.verificationView.snp.remakeConstraints {(make) in
                    make.left.equalTo(self.paddingNum)
                    make.right.equalTo(-self.paddingNum)
                    make.height.equalTo(0)
                    make.top.equalTo(255)
                }
                
                self.layoutIfNeeded()
            }){(finnish) in
                self.isAnimattion = true
            }
            
        case section2:
            print("注册")
            self.passwordT.returnKeyType = .next
            
            boxViewH = 360
            boxViewBottom = self.isKeyboard ? boxViewBottom : (self.frame.height - boxViewH) / 2
            UIView.animate(withDuration: 0.6, animations: {
                self.boxView.snp.remakeConstraints {(make) in
                    make.width.equalTo(self.boxViewWidth)
                    make.height.equalTo(self.boxViewH)
                    make.center.equalToSuperview()
                }
                
                self.section2.setTitleColor(LDColor(rgbValue: 0x6495ED, al: 1), for: .normal)
                self.section2.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 20.0, weight: UIFont.Weight(rawValue: 400))
                self.section1.setTitleColor(UIColor.white, for: .normal)
                self.section1.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: UIFont.Weight(rawValue: 200))
                self.loginButton.setTitle("注册", for: .normal)
                self.topSelectView.snp.remakeConstraints {(make) in
                    make.top.left.bottom.equalToSuperview()
                    make.width.equalTo(self.boxViewWidth / 2)
                }
                
                self.confirmView.alpha = 1
                self.confirmView.snp.remakeConstraints {(make) in
                    make.height.equalTo(40)
                    make.top.equalTo(195)
                    make.left.equalTo(self.paddingNum)
                    make.right.equalTo(-self.paddingNum)
                }
                
                self.verificationView.alpha = 1
                self.verificationView.snp.remakeConstraints {(make) in
                    make.height.equalTo(40)
                    make.top.equalTo(255)
                    make.left.equalTo(self.paddingNum)
                    make.right.equalTo(-self.paddingNum)
                }

                self.layoutIfNeeded()
            }){(finnish) in
                self.isAnimattion = true
            }
            
        default:
            print("33")
        }
    }
    
    fileprivate func setupKeyboardAction(){
        //添加手势点击空白处收起键盘
        let gestrue = UITapGestureRecognizer(target: self, action: #selector(self.hideBoard))
        self.addGestureRecognizer(gestrue)
        //键盘弹起 和 收起通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notifition:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notifition:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func hideBoard(){
        self.endEditing(true)
    }
    
    @objc func keyboardWillShow(notifition : Notification){
        if let userInfo = notifition.userInfo as? Dictionary<String, Any>{
            if let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                self.isKeyboard = true
                let keyboardSize = keyboardFrameValue.cgRectValue
                let currentBottom = (ScreenHeight - boxViewH) / 2
                if(currentBottom > keyboardSize.height){
                    self.boxViewBottom = currentBottom
                }else{
                    self.boxViewBottom = keyboardSize.height
                }
                 
                self.boxView.snp.remakeConstraints {(make) in
                    make.bottom.equalTo(-boxViewBottom)
                    make.width.equalTo(self.boxViewWidth)
                    make.height.equalTo(self.boxViewH)
                    make.centerX.equalToSuperview()
                }
                
                UIView.animate(withDuration: 0.4, delay: 0, options:[ UIView.AnimationOptions.overrideInheritedDuration,UIView.AnimationOptions.overrideInheritedCurve], animations: {
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }

    }
    
    @objc func keyboardWillHide(notifition : Notification){
        if let userInfo = notifition.userInfo as? Dictionary<String, Any>{
            if let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                self.isKeyboard = false
                self.boxView.snp.remakeConstraints {(make) in
                    make.width.equalTo(self.boxViewWidth)
                    make.height.equalTo(self.boxViewH)
                    make.center.equalToSuperview()
                }

                UIView.animate(withDuration: 0.4,delay: 0 ,options:[UIView.AnimationOptions.overrideInheritedDuration,UIView.AnimationOptions.overrideInheritedCurve] , animations: {
                    self.layoutIfNeeded()
                })
            }
        }
    }
}

//扩展UIView，找到最上层UIViewController
extension  UIView {
    //返回该view所在VC
    func firstViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}

extension LoginView: UITextFieldDelegate {
    //调整键盘return按键
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if boxViewH == 240{
            if textField == self.numberT{
                self.passwordT.becomeFirstResponder()
            }else{
                self.passwordT.resignFirstResponder()
            }
        }else if boxViewH == 360{
            switch textField {
            case self.numberT:
                self.passwordT.becomeFirstResponder()
            case self.passwordT:
                self.confirmT.becomeFirstResponder()
            case self.confirmT:
                self.verificationT.becomeFirstResponder()
            case self.verificationT:
                self.verificationT.resignFirstResponder()
            default:
                return false
            }
        }
        return true
    }
}

