//
//  LoadingView.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/27.
//

import Foundation
import UIKit
class LoadingView: UIView {
    let loadingImage: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI(){
        self.backgroundColor = CommonOne().LDColor(rgbValue: 0x000000, al: 0.25)
        self.addSubview(loadingImage)
        loadingImage.backgroundColor = UIColor.red
        loadingImage.snp.makeConstraints {(make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        guard let path = Bundle.main.path(forResource: "loading", ofType: "gif") else { return }
        let url:NSURL? = NSURL.init(fileURLWithPath: path)
        print("--\(path)---")
        print("--\(url)---")
        
    }
}
