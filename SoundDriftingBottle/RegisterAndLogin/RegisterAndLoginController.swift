//
//  RegisterAndLoginController.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/27.
//

import Foundation
import UIKit
class RegisterAndLoginController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.white
        
        let loginview = LoginView(frame: self.view.bounds)
        self.view.addSubview(loginview)
        
        loginview.loginButton.addTarget(self, action: #selector(buttomButtonAction(sender:)), for: .touchDown)
    }
    @objc func buttomButtonAction(sender: UIButton){
        if(sender.title(for: .normal) == "登陆"){
            print("捞瓶子")
            let pickUpBottle = PickingUpBottlesController()
            self.navigationController?.pushViewController(pickUpBottle, animated: true)
        }else if(sender.title(for: .normal) == "注册"){
            print("个人信息填写")
            let mine = MineController()
            self.navigationController?.pushViewController(mine, animated: true)
        }else{
            print("3333")
        }
    }}
