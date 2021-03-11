//
//  SetupController.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/2/20.
//

import Foundation
import UIKit

class SetupController: UIViewController {
//    var contenttableview: SetupView!
    var contentTableView: UITableView!
    let cellText = [["修改个人信息", "意见反馈", "清除缓存"] ,["关于音瓶" ,"隐私协议"] , ["退出"]]
    var isTableViewEditing = false
    
    
    //cell点击事件
    var clearTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNav()
        setupContenttableview()
        

    }

//-----------------------------------------------------------------------------------------------
    fileprivate func setupNav(){
        self.gk_navBackgroundColor = .clear
        self.gk_statusBarStyle = .lightContent
        self.gk_navTitleColor = .black
        self.gk_navLineHidden = true
        self.gk_backStyle = .black
        self.gk_navTitle = "设置"
                
    
        self.gk_navRightBarButtonItem = .gk_item(title: "打开",color:UIColor.black, target: self, action: #selector(onclickchange))
        
    }
    
    @objc func onclickchange(){
        var text: String = ""
        if isTableViewEditing{
            
            if contentTableView != nil{
                isTableViewEditing = !isTableViewEditing
                contentTableView.setEditing(!contentTableView.isEditing, animated: true)
                text = "移动"
            }
        }else {
            
            if contentTableView != nil{
                isTableViewEditing = !isTableViewEditing
                contentTableView.setEditing(!contentTableView.isEditing, animated: true)
                text = "取消"
                UIUtil.showHint("长按右侧拖动阀，可自由拖动个选项哦~")
            }
        }
        self.gk_navRightBarButtonItem = .gk_item(title: text,color:UIColor.black, target: self, action: #selector(onclickchange))
        
    }
    
    fileprivate func setupContenttableview(){
        contentTableView = UITableView(frame: CGRect(x: 0, y: CGFloat(CommonOne().topPadding + 44), width: self.view.bounds.width, height: self.view.bounds.height -  CGFloat(CommonOne().topPadding + 44)), style: .grouped)
        contentTableView.backgroundColor = LDColor(rgbValue: 0xf5f5f5, al: 1)
        contentTableView.separatorColor = LDColor(rgbValue: 0xf5f5f5, al: 1)
        contentTableView.separatorStyle = .singleLine
        contentTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentTableView.rowHeight = 65
        contentTableView.tableHeaderView = .init(frame: CGRect(x: 0, y: 0, width: 300, height: 25))
        contentTableView.tableHeaderView?.backgroundColor = .clear
        contentTableView.sectionFooterHeight = 20
        
        

        self.view.addSubview(contentTableView)
        contentTableView.delegate = self
        contentTableView.dataSource = self
    }

}

//-----------------------------------------------------------------------------------------------
extension SetupController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 3
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "cellid"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil{
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellid)
        }
        cell?.textLabel?.text = self.cellText[indexPath.section][indexPath.row]
//        cell?.detailTextLabel?.text = "未实现"
        if indexPath.section == 0{
            cell?.accessoryType = .disclosureIndicator
        }

        cell?.selectionStyle = .none
        return cell!
    }

    //MARK: 选择编辑模式，不删除也不添加就设置为none
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    //MARK: 设置cell是否可移动
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //MARK: 移动结束后调用此方法
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

//        let data = dataSource[sourceIndexPath.row]
//        dataSource.remove(at: sourceIndexPath.row)
//        dataSource.insert(data, at: destinationIndexPath.row)
    }
    
    //MARK: 点击事件处理——页面跳转处理
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("cell:\(indexPath)---\(tableView.cellForRow(at: indexPath)?.textLabel?.text)")
        let text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        switch text {
        case "修改个人信息":
            print("修改个人信息")
            let personInfo = PersonalInfoController()
            self.navigationController?.pushViewController(personInfo, animated: true)
            
        case "意见反馈":
            print("意见反馈")
            let feedback = FeedbackController()
            self.navigationController?.pushViewController(feedback, animated: true)
            
        case "清除缓存":
            print("清除缓存")
            UIUtil.showLoading()
            clearTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(clearAction), userInfo: nil, repeats: false)

        case "关于音瓶":
            print("关于音瓶")
            let versionInfo = VersionInfoController()
            self.navigationController?.pushViewController(versionInfo, animated: true)
            
        case "隐私协议":
            print("隐私协议")
            let privacyAgreement = PrivacyAgreementController()
            self.navigationController?.pushViewController(privacyAgreement, animated: true)
            
        case "退出":
            print("退出")
            let backAlert = UIAlertController.init(title: "确定退出", message: nil, preferredStyle: .alert)
            let alertTrue = UIAlertAction(title: "确定", style: .default, handler: {_ in
                let register = RegisterAndLoginController()
                self.dismiss(animated: false, completion: {
                    print("关闭页面成功")
                })
                self.navigationController?.pushViewController(register, animated: true)
            })
            let alertCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            backAlert.addAction(alertTrue)
            backAlert.addAction(alertCancel)
            self.navigationController?.present(backAlert, animated: true, completion: nil)
            
        default:
            print("都不是")
        }
        
        return indexPath
    }
    
    @objc func clearAction(){
        clearTimer?.invalidate()
        clearTimer = nil
        UIUtil.showHint("清除成功")
    }

}


