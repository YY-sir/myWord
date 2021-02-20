//
//  GKWYHeaderView.swift
//  GKPageScrollViewSwift
//
//  Created by gaokun on 2019/2/22.
//  Copyright © 2019 gaokun. All rights reserved.
//

import UIKit

public let kWYHeaderHeight = (kScreenW * 500.0 / 750.0 - kNavBar_Height)

class MineHeaderView: UIView {
    lazy var nameLabel: UILabel! = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        nameLabel.textColor = UIColor.white
        nameLabel.text = "余余与余余"
        return nameLabel
    }()
    
    
    lazy var personalSignature: UILabel! = {
        let personalSignature = UILabel()
        personalSignature.font = UIFont.systemFont(ofSize: 13.0)
        personalSignature.textColor = UIColor.white
        personalSignature.text = "知道今天可以见到你，所以从睁开眼睛就开始感到幸福"
        return personalSignature
    }()
    
    lazy var countLabel: UILabel! = {
        let countLabel = UILabel()
        countLabel.font = UIFont.systemFont(ofSize: 13.0)
        countLabel.textColor = UIColor.white
        countLabel.text = "被收藏了60182次"
        return countLabel
    }()
    
    lazy var personalBtn: UIButton! = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        btn.setTitle("扩展", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = ADAPTATIONRATIO * 25.0
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 0.5
        return btn
    }()
    
    lazy var setupBtn: UIButton! = {
        let btn = UIButton()
        btn.backgroundColor = CommonOne().LDColor(rgbValue: 0x20B2BB, al: 1.0)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        btn.setTitle("设置", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = ADAPTATIONRATIO * 22.0
        btn.layer.masksToBounds = true
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.addSubview(nameLabel)
        self.addSubview(personalSignature)
        self.addSubview(countLabel)
        self.addSubview(personalBtn)
        self.addSubview(setupBtn)
        
        
        setupBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-ADAPTATIONRATIO * 26.0)
            make.right.equalTo(-ADAPTATIONRATIO * 20.0)
            make.width.equalTo(ADAPTATIONRATIO * 150.0)
            make.height.equalTo(ADAPTATIONRATIO * 50.0)
        }
        
        personalBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.setupBtn.snp.bottom)
            make.right.equalTo(self.setupBtn.snp.left).offset(-ADAPTATIONRATIO * 20.0)
            make.width.equalTo(ADAPTATIONRATIO * 150.0)
            make.height.equalTo(ADAPTATIONRATIO * 50.0)
        }

        
        countLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(setupBtn)
            make.left.equalTo(ADAPTATIONRATIO * 15.0)
        }
        
        personalSignature.snp.makeConstraints { (make) in
            make.left.equalTo(self.countLabel)
            make.bottom.equalTo(self.countLabel.snp.top).offset(-ADAPTATIONRATIO * 15.0)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.countLabel)
            make.bottom.equalTo(self.personalSignature.snp.top).offset(-18.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
