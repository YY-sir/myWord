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
    let currentTimeL = UILabel()
    let totalTimeL = UILabel()
    let slider = UISlider1()
    
    let playView = UIView()
    let refreshB = UIButton()
    let playB = UIButton()
    let nextB = UIButton()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupOtherView()
        uiAction()
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
        
        setupPlayView()

    }

//---------------------------------------------------------------------------
    fileprivate func setupOtherView(){
        otherView.addSubview(likeView)
        likeView.backgroundColor = UIColor.red
        likeView.snp.makeConstraints {(make) in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.centerX.top.equalToSuperview()
        }
        
        otherView.addSubview(slider)
        slider.thumbTintColor = .clear
//        slider.backgroundColor = .white
        slider.snp.makeConstraints {(make) in
            make.centerX.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        setupLikeView()
    }
    
    fileprivate func setupLikeView(){
        likeView.addSubview(currentTimeL)
        currentTimeL.snp.makeConstraints {(make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        likeView.addSubview(totalTimeL)
        totalTimeL.snp.makeConstraints {(make) in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    
    
//---------------------------------------------------------------------------
    fileprivate func setupPlayView(){
        playView.addSubview(playB)
        playB.setImage(UIImage(named: "pause20"), for: .normal)
        playB.snp.makeConstraints {(make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        playView.addSubview(refreshB)
        refreshB.setImage(UIImage(named: "shuaxin"), for: .normal)
        refreshB.setImage(UIImage(named: "shuaxin_light"), for: .highlighted)
        refreshB.snp.makeConstraints {(make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(playB.snp.left).offset(-20)
            make.width.height.equalTo(50)
        }
        
        playView.addSubview(nextB)
        nextB.setImage(UIImage(named: "right2"), for: .normal)
        nextB.setImage(UIImage(named: "right2_light"), for: .highlighted)
        nextB.snp.makeConstraints {(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(playB.snp.right).offset(20)
            make.width.height.equalTo(50)
        }
    }
    
//
    fileprivate func uiAction(){
        //slider的滑块操作
        slider.addTarget(self, action: #selector(sliderShow), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderHide), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc func sliderShow(){
        slider.thumbTintColor = .white
    }
    @objc func sliderHide(){
        slider.thumbTintColor = .clear
    }
    
    
}