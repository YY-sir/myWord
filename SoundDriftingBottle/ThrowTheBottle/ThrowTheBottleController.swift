//
//  ThrowTheBottleController.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/28.
//

import Foundation
import UIKit
class ThrowTheBottleController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置背景颜色
        setupViewBg()
    }
    
    fileprivate func setupViewBg(){
        let ui = UIView(frame: self.view.bounds)
        ui.layer.addSublayer(CommonOne().gradientLayer)
        self.view.addSubview(ui)
    }

}
