//
//  MineListTableViewCell.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/30.
//

import Foundation

class MineListTableViewCell: UITableViewCell {
    let logoImgView = UIImageView()
    let nameLabel = UILabel()
    let actionView = UIView()
    let collectB = UIButton()
    let deleteB = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupActionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        self.addSubview(logoImgView)
        logoImgView.snp.makeConstraints{(make) in
            make.height.width.equalTo(50)
            make.left.equalTo(10)
            make.top.equalToSuperview()
        }
        logoImgView.contentMode = .scaleAspectFit
        
        self.addSubview(actionView)
        actionView.backgroundColor = .yellow
        actionView.snp.makeConstraints{(make) in
            make.height.top.equalToSuperview()
            make.width.equalTo(100)
            make.right.equalTo(-10)
        }
        
        self.addSubview(nameLabel)
        nameLabel.backgroundColor = .red
        nameLabel.snp.makeConstraints{(make) in
            make.height.top.equalToSuperview()
            make.left.equalTo(self.logoImgView.snp.right)
            make.right.equalTo(self.actionView.snp.left)
        }
    }
    
    fileprivate func setupActionView(){
        self.actionView.addSubview(collectB)
        collectB.backgroundColor = .blue
        collectB.snp.makeConstraints{(make) in
            make.height.width.equalTo(50)
            make.left.top.equalToSuperview()
        }
        
        self.actionView.addSubview(deleteB)
        deleteB.backgroundColor = .brown
        deleteB.snp.makeConstraints{(make) in
            make.height.width.equalTo(50)
            make.top.right.equalToSuperview()
        }
    }
    
}
