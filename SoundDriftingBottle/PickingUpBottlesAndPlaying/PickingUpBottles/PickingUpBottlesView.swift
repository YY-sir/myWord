//
//  PickingUpBottlesView.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/1/27.
//

import Foundation
import UIKit
class PickingUpBottlesView: UIView {
    let mainScrollView: UIScrollView = UIScrollView()
    let labelView: UIView = UIView()
    let mainScrollViewBg: UIImageView = UIImageView()
    
    let bottomView: UIView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupBottomView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        self.backgroundColor = UIColor.yellow
        self.addSubview(mainScrollView)
        mainScrollView.backgroundColor = UIColor.white
        mainScrollView.snp.makeConstraints {(make) in
            make.size.equalToSuperview()
        }
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: 1000)
        mainScrollView.addSubview(mainScrollViewBg)
        mainScrollViewBg.image = UIImage(named: "image2")
        mainScrollViewBg.snp.makeConstraints {(make) in
            make.top.equalToSuperview().offset(-CommonOne().topPadding)
            make.bottom.equalToSuperview().offset(CommonOne().bottomPadding)
            make.width.equalToSuperview()
            make.height.equalTo(1200)
        }
        
        mainScrollView.addSubview(labelView)
        labelView.backgroundColor = UIColor.blue
        labelView.alpha = 0.5
        labelView.snp.makeConstraints {(make) in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(200)
        }
        
        self.addSubview(bottomView)
        
    }
    
    fileprivate func setupScrollView(){
        
    }
    
    fileprivate func setupBottomView(){
        self.addSubview(bottomView)
        bottomView.backgroundColor = CommonOne().LDColor(rgbValue: 0x000000, al: 0.5)
        bottomView.snp.makeConstraints {(make) in
            make.width.left.equalToSuperview()
            make.bottom.equalTo(-CommonOne().bottomPadding)
            make.height.equalTo(50)
        }
        
    }
    
}
