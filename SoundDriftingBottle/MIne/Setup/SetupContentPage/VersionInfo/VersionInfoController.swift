//
//  VersionInfoController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/5.
//

import Foundation
import UIKit
class VersionInfoController: UIViewController {
    override func viewDidLoad() {
        print("版本信息")
        self.view.backgroundColor = .white
        setupNav()
    }
    
    
//----------------------------------------------------------------------------------------------------
    fileprivate func setupNav(){
        self.gk_navBackgroundColor = .clear
        self.gk_statusBarStyle = .lightContent
        self.gk_navLineHidden = true
        self.gk_backStyle = .black

        
    }
}
