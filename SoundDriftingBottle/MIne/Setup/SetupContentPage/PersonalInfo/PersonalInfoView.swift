//
//  PersonInfoView.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/11.
//

import Foundation

class PersonalInfoView: UIView {
    let app = UIApplication.shared.delegate as! AppDelegate
    
    let labelArr = ["头像", "昵称", "性别", "生日", "个性签名" ,"完成"]
    
    var contentTableView: UITableView!
    let faceImage = UIImageView()
    let nameTextField = UITextField()
    let personalTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupTableView(){
        contentTableView = UITableView(frame: self.bounds, style: .grouped)
        contentTableView.sectionHeaderHeight = 0.1
        contentTableView.separatorColor = LDColor(rgbValue: 0xdddddd, al: 1)
        contentTableView.delaysContentTouches = false
        contentTableView.backgroundColor = .white
        
        self.addSubview(contentTableView)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        
        
    }
}

extension PersonalInfoView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "PersonalInfoCellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil{
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        }
        
        cell?.selectionStyle = .none
        cell?.textLabel?.text = labelArr[indexPath.row]
        
        switch labelArr[indexPath.row] {
        case "头像":
            cell?.accessoryType = .disclosureIndicator
            cell?.contentView.addSubview(faceImage)
//            faceImage.image = UIImage.init(contentsOfFile: app.faceImageUrl)
            faceImage.image = UIImage.init(named: "profileImage")
            faceImage.layer.cornerRadius = 5
            faceImage.layer.masksToBounds = true
            faceImage.snp.makeConstraints{(make) in
                make.height.width.equalTo(80.0)
                make.right.equalTo(-5)
                make.centerY.equalToSuperview()
            }
        case "昵称":
            nameTextField.textAlignment = .right
            nameTextField.placeholder = "请输入昵称"
            cell?.contentView.addSubview(nameTextField)
            nameTextField.snp.makeConstraints{(make) in
                make.height.equalToSuperview()
                make.width.equalTo(100)
                make.right.equalTo(-15)
            }
        case "个性签名":
            personalTextField.textAlignment = .right
            personalTextField.placeholder = "你还没有签名~"
            cell?.contentView.addSubview(personalTextField)
            personalTextField.snp.makeConstraints{(make) in
                make.height.equalToSuperview()
                make.right.equalTo(-15)
                make.left.equalTo(cell?.textLabel?.snp.right as! ConstraintRelatableTarget).offset(5)
            }
        case "完成":
            print("完成")
        default:
            cell?.accessoryType = .disclosureIndicator
            cell?.detailTextLabel?.text = "无"
        }
        
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch labelArr[indexPath.row] {
//        case "头像":
//            return 100.0
//        case "昵称":
//            return 50.0
//        case "性别":
//            return 50.0
//        case "生日":
//            return 50.0
//        case "个性签名":
//            return 50.0
//        default:
//            return 60.0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
//        switch tableView.cellForRow(at: indexPath)?.textLabel?.text {
//        case "头像":
//            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
//        case "昵称":
//            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
//        case "性别":
//            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
//        case "生日":
//            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
//        case "个性签名":
//            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
//        default:
//            print("\(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text))")
//        }
//        
//    }
    
    
    
}
