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
    let audioB = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        self.addSubview(audioB)
        audioB.backgroundColor = .clear
        audioB.setImage(UIImage.init(named: "playMusic"), for: .normal)
        audioB.snp.makeConstraints {(make) in
            make.width.height.equalTo(40)
            make.left.equalTo(20)
            make.top.equalToSuperview().offset(CommonOne().topPadding + 20)
        }
        
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
        
        self.bringSubviewToFront(audioB)
    }
        
}
