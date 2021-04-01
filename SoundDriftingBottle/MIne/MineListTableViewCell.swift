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
        
        self.contentView.addSubview(logoImgView)
        logoImgView.snp.makeConstraints{(make) in
            make.height.width.equalTo(mineListHeight)
            make.left.equalTo(10)
            make.top.equalToSuperview()
        }
        logoImgView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(actionView)
        actionView.snp.makeConstraints{(make) in
            make.height.top.equalToSuperview()
            make.width.equalTo(mineListHeight * 2 + 10)
            make.right.equalTo(-10)
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{(make) in
            make.height.top.equalToSuperview()
            make.left.equalTo(self.logoImgView.snp.right)
            make.right.equalTo(self.actionView.snp.left)
        }
    }
    
    fileprivate func setupActionView(){
        self.actionView.addSubview(collectB)
        collectB.snp.makeConstraints{(make) in
            make.height.width.equalTo(mineListHeight)
            make.left.top.equalToSuperview()
        }
        
        self.actionView.addSubview(deleteB)
        deleteB.snp.makeConstraints{(make) in
            make.height.width.equalTo(mineListHeight)
            make.top.right.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
    
}
