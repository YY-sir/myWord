//
//  ViewController.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.pushViewController(RegisterAndLoginController(), animated: true)
    }
    

}

