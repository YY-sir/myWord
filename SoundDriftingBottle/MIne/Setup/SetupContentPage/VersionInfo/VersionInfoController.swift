//
//  VersionInfoController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/5.
//

import Foundation
import UIKit
class VersionInfoController: UIViewController {
    var versionInfoview: VersionInfoView!
    
    override func viewDidLoad() {
        print("关于音瓶")
        self.view.backgroundColor = .white
        setupNav()
        setuptest()
    }
    
//    MARK:----------------------------------------------------------------------------------------------------
    fileprivate func setupNav(){
        self.gk_navBackgroundColor = .clear
        self.gk_statusBarStyle = .lightContent
        self.gk_navLineHidden = true
        self.gk_backStyle = .black
        self.gk_navTitle = "关于音瓶"
    }
        
    fileprivate func setuptest(){
        versionInfoview = VersionInfoView(frame: self.view.bounds)
        self.view.addSubview(versionInfoview)
    }
    
}
