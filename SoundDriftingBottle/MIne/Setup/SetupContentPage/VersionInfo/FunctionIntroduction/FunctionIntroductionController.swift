//
//  FunctionIntroductionController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/5.
//


import Foundation
import UIKit
class FunctionIntroductionController: UIViewController {
    var functionintroductionview: FunctionIntroductionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("功能介绍")
        self.view.backgroundColor = .white
        setupNav()
        setupView()
        
    }
    
    fileprivate func setupNav(){
        self.gk_navTitle = "功能介绍"
        self.gk_navTitleColor = .black
        self.gk_navBackgroundColor = .white
        self.gk_statusBarStyle = .lightContent
        self.gk_navLineHidden = false
        self.gk_backStyle = .black
    }
    
    fileprivate func setupView(){
        functionintroductionview = FunctionIntroductionView(frame: self.view.bounds)
        self.view.addSubview(functionintroductionview)
        functionintroductionview.snp.makeConstraints{(make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(CommonOne().topPadding + 44.0)
        }
    }
}
