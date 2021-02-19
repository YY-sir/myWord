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
        //设置顶部导航栏
        setupNav()
        
        self.view.backgroundColor = UIColor.white
        self.title = "YY（用户名）"
        
        let bun = Bundle.main.path(forResource: "Settings", ofType: "bundle")
        let url = bun! + "/loading.gif"
        print("url:\(url)")
        let img = UIImageView()
        self.view.addSubview(img)
        img.backgroundColor = .yellow
        
        img.image = UIImage.gifImageWithURL(gifUrl: url)
        img.snp.makeConstraints {(make) in
            make.width.height.equalTo(100)
            make.center.equalToSuperview()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = false
    }
    
//--------------------------------------------------------------------------------------------------------
    fileprivate func setupNav(){
        self.gk_navBackgroundColor = .clear
        self.gk_statusBarStyle = .lightContent
        self.gk_navTitleColor = .black
        self.gk_navLineHidden = true
        self.gk_backStyle = .black
    }
    
}
