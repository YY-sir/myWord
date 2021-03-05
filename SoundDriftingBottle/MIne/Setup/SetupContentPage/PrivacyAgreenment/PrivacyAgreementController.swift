//
//  PrivacyAgreementController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/5.
//

import Foundation
import UIKit
class PrivacyAgreementController: UIViewController {
    var privacyagreementview: PrivacyAgreementView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("隐私协议")
        self.view.backgroundColor = .white
        setupNav()
        setupView()
        
    }
    
    fileprivate func setupNav(){
        self.gk_navTitle = "隐私协议"
        self.gk_navTitleColor = .black
        self.gk_navBackgroundColor = .white
        self.gk_statusBarStyle = .lightContent
        self.gk_navLineHidden = false
        self.gk_backStyle = .black
    }
    
    fileprivate func setupView(){
        privacyagreementview = PrivacyAgreementView(frame: self.view.bounds)
        self.view.addSubview(privacyagreementview)
        privacyagreementview.snp.makeConstraints{(make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(CommonOne().topPadding + 44.0)
        }
    }
}
