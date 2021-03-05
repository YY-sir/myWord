//
//  VersionInfoController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/5.
//

import Foundation
import UIKit
class VersionInfoController: UIViewController {
//    var versionInfoview: SetupView!
    
    var cellText = ["功能介绍", "检查更新"]
    var contentTableView:UITableView!
    let headerView: UIView = UIView()
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let versionLabel = UILabel()
    let authorLabel = UILabel()
    
    override func viewDidLoad() {
        print("关于音瓶")
        self.view.backgroundColor = .white
        setupNav()
        setupHeaderView()
        setupView()
    }
    
//    MARK:----------------------------------------------------------------------------------------------------
    fileprivate func setupNav(){
        self.gk_navBackgroundColor = .clear
        self.gk_statusBarStyle = .lightContent
        self.gk_navLineHidden = true
        self.gk_backStyle = .black
        self.gk_navTitle = "关于音瓶"
    }
        
    fileprivate func setupHeaderView(){
        headerView.addSubview(imageView)
        imageView.snp.makeConstraints{(make) in
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
        }
        imageView.image = UIImage.init(named: "appIcon")
        
        headerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{(make) in
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(5)
        }
        nameLabel.text = "音瓶"
        
        headerView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints{(make) in
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        versionLabel.text = "Version 0.0.1"
    }
    
    fileprivate func setupView(){
        contentTableView = UITableView(frame: CGRect(x: 0, y: CommonOne().topPadding + 44, width: self.view.frame.width, height: self.view.frame.height - CommonOne().topPadding - 44), style: .grouped)
        contentTableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        contentTableView.rowHeight = 70
        contentTableView.sectionHeaderHeight = 200
        contentTableView.bounces = false
        
        self.view.addSubview(contentTableView)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        authorLabel.text = "Y Y"
        contentTableView.addSubview(authorLabel)
        let bottomNum = UIScreen.main.bounds.height - CommonOne().topPadding - 44.0 - 50
        authorLabel.snp.makeConstraints{(make) in
            make.height.equalTo(20)
            make.bottom.equalTo(bottomNum)
            make.centerX.equalToSuperview()
        }
    }
    
}

//    MARK:----------------------------------------------------------------------------------------------------
extension VersionInfoController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "setupCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil{
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = cellText[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
//    MARK:cell点击事件处理
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath.row {
        case 0:
            print("功能介绍")
            let functionintroductioncontroller = FunctionIntroductionController()
            self.navigationController?.pushViewController(functionintroductioncontroller, animated: true)
        case 1:
            print("版本更新")
            UIUtil.showHint("当前是最新版本")
        default:
            print("未实现")
        }
        return indexPath
    }
    
}
