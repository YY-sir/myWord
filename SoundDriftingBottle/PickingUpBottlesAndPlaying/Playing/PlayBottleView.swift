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
    let bottomView: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
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
        
        
    }
}
