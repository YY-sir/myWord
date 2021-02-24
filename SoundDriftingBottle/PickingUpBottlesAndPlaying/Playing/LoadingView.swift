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
        
        
        self.backgroundColor = LDColor(rgbValue: 0x000000, al: 0.17)
        self.addSubview(loadingImage)
        loadingImage.snp.makeConstraints {(make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(35)
        }
        
        var imgArray: [UIImage]! = []
        for index in 1 ..< 9{
            let str: String?
            str = String(format: "loading2-%d", index)
            let image = UIImage(named: str!)
            imgArray.append(image!)
        }
        loadingImage.animationImages = imgArray
        loadingImage.animationDuration = 8 * 0.12
        loadingImage.animationRepeatCount = .max
        loadingImage.startAnimating()
    }
}
