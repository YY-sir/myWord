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
        print("1111111")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("1111111")
        self.navigationController?.pushViewController(RegisterAndLoginController(), animated: false)
    }

}

