//
//  BottomView.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/28.
//

import Foundation
import UIKit
class BottomView: UIView {
    let mineButton = UIButton(type: .system)
    let recordButton = UIButton(type: .system)
    let autoplayButton = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        self.tintColor = .white
        self.addSubview(mineButton)
        mineButton.setImage(UIImage(named: "play20"), for: .normal)
        mineButton.snp.makeConstraints {(make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
            make.left.equalTo(10)
        }
        
        self.addSubview(recordButton)
        recordButton.setImage(UIImage(named: "gotoRecord"), for: .normal)
        recordButton.snp.makeConstraints {(make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }

        self.addSubview(autoplayButton)
        autoplayButton.onTintColor = CommonOne().LDColor(rgbValue: 0x68C8D6, al: 1)
        autoplayButton.snp.makeConstraints {(make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
    }
    
    
}
