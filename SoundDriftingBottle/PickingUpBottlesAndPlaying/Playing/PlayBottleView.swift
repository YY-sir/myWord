//
//  PlayBottleView.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/28.
//

import Foundation
import UIKit
class PlayBottleView: UIView {
    
    let otherView: UIView = UIView()
    let likeView: UIView = UIView()
    let playView = UIView()
    let bottomView: UIView = BottomView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupOtherView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        self.addSubview(otherView)
        otherView.backgroundColor = UIColor.black
        otherView.snp.makeConstraints {(make) in
            make.width.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalTo(500)
        }
        
        self.addSubview(playView)
        playView.backgroundColor = UIColor.white
        playView.snp.makeConstraints {(make) in
            make.width.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalTo(otherView.snp.bottom)
        }
        
        self.addSubview(bottomView)
        bottomView.backgroundColor = CommonOne().LDColor(rgbValue: 0x000000, al: 0.5)
        bottomView.snp.makeConstraints {(make) in
            make.width.left.equalToSuperview()
            make.bottom.equalTo(-CommonOne().bottomPadding)
            make.height.equalTo(50)
        }
    }
    
    fileprivate func setupOtherView(){
        otherView.addSubview(likeView)
        likeView.backgroundColor = UIColor.red
        likeView.snp.makeConstraints {(make) in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.top.equalToSuperview()
        }
        
        
    }
}
