//
//  SetupView.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/2/24.
//

import Foundation
import UIKit

class SetupView: UIView {
    var contentTableView: UITableView!
    let cellText = [["修改个人信息", "意见反馈", "清除缓存"] ,["版本信息" ,"隐私协议"] , ["退出"]]

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentTableView = UITableView(frame: self.bounds, style: .grouped)
        contentTableView.backgroundColor = LDColor(rgbValue: 0xf5f5f5, al: 1)
        contentTableView.separatorColor = LDColor(rgbValue: 0xf5f5f5, al: 1)
        contentTableView.separatorStyle = .singleLine
        contentTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentTableView.rowHeight = 65
        contentTableView.tableHeaderView = .init(frame: CGRect(x: 0, y: 0, width: 300, height: 25))
        contentTableView.tableHeaderView?.backgroundColor = .clear
        contentTableView.sectionFooterHeight = 20
        contentTableView.setEditing(!contentTableView.isEditing, animated: true)

        self.addSubview(contentTableView)
        contentTableView.delegate = self
        contentTableView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SetupView: UITableViewDelegate, UITableViewDataSource{
    //MARK: UITableViewDataSource
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
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)as?MineCell
        if cell == nil{
            cell = MineCell(style: .value1, reuseIdentifier: cellid)
        }
        cell?.textLabel?.text = self.cellText[indexPath.section][indexPath.row]
//        cell?.detailTextLabel?.text = "未实现"
//        cell?.accessoryType = .detailButton
//        if indexPath.section == 0{
//            cell?.accessoryType = .disclosureIndicator
//        }

        cell?.selectionStyle = .none
        return cell!
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("\(indexPath.section)---\(indexPath.row)")
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

//        let data = dataSource

    }



}

private class MineCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



