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
    var index = 0
    var type : String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupActionView()
        buttonAction()
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
            make.width.equalTo((mineListHeight - 10) * 2 + 10)
            make.right.equalTo(-10)
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{(make) in
            make.height.top.equalToSuperview()
            make.left.equalTo(self.logoImgView.snp.right).offset(10)
            make.right.equalTo(self.actionView.snp.left).offset(-10)
        }
    }
    
    fileprivate func setupActionView(){
        self.actionView.addSubview(collectB)
        collectB.snp.makeConstraints{(make) in
            make.height.width.equalTo(mineListHeight - 10)
            make.left.centerY.equalToSuperview()
        }
        
        self.actionView.addSubview(deleteB)
        deleteB.snp.makeConstraints{(make) in
            make.height.width.equalTo(mineListHeight - 10)
            make.centerY.right.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    //收藏和删除添加通知
    fileprivate func buttonAction(){
        self.collectB.addTarget(self, action: #selector(collectBAction), for: .touchUpInside)
        self.deleteB.addTarget(self, action: #selector(deleteBAction), for: .touchUpInside)
    }
    
    @objc func collectBAction(){
        var imageName = ""
        if collectB.isSelected{
            collectB.isSelected = false
            imageName = "mine_like"
        }else{
            collectB.isSelected = true
            imageName = "mine_like_fill"
        }
        collectB.setImage(UIImage.init(named: imageName), for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MineCollectAction"), object: self.type, userInfo: ["index": index])
    }
    
    @objc func deleteBAction(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MineDeleteAction"), object: self.type, userInfo: ["index": index])
    }
    
}
