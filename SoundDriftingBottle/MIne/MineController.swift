//
//  MineController.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/27.
//

import Foundation
import UIKit
class MineController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "YY（用户名）"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
}
