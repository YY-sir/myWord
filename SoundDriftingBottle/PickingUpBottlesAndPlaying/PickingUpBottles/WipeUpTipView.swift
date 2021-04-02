//
//  WipeUpTipView.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/4/2.
//

import Foundation

class WipeUpTipView: UIView {
    let contentView = UIView()
    let tipImgView = UIImageView()
    let tipLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        self.backgroundColor = LDColor(rgbValue: 0x555555, al: 0.25)
        
        self.addSubview(contentView)
        contentView.snp.makeConstraints{(make) in
            make.center.equalToSuperview()
        }
    }
    
    fileprivate func setupContentView(){
        self.contentView.addSubview(tipImgView)
        tipImgView.image = UIImage.init(named: "wipeUp")
        tipImgView.contentMode = .scaleAspectFit
        tipImgView.snp.makeConstraints{(make) in
            make.width.height.equalTo(100)
            make.top.left.right.equalToSuperview()
        }
        
        self.contentView.addSubview(tipLabel)
        tipLabel.text = "向上滑动"
        tipLabel.snp.makeConstraints{(make) in
            make.top.equalTo(tipImgView.snp.bottom)
            make.bottom.centerX.equalToSuperview()
        }
    }
    
}
