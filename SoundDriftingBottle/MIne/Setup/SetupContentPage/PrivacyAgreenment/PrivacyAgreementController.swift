//
//  PrivacyAgreementController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/5.
//

import Foundation
import UIKit
class PrivacyAgreementController: UIViewController {
    override func viewDidLoad() {
        print("隐私协议")
        self.view.backgroundColor = .white
        setupNav()
        
    }
    
    fileprivate func setupNav(){
        self.gk_navTitle = "隐私协议"
        self.gk_navTitleColor = .black
        self.gk_navBackgroundColor = .white
        self.gk_statusBarStyle = .lightContent
        self.gk_navLineHidden = false
        self.gk_backStyle = .black
    }
}
