//
//  SetupController.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/2/20.
//

import Foundation

class SetupController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNav()
    }
    
    fileprivate func setupNav(){
        self.gk_navBackgroundColor = .clear
        self.gk_statusBarStyle = .lightContent
        self.gk_navTitleColor = .black
        self.gk_navLineHidden = true
        self.gk_backStyle = .black
    }

}
