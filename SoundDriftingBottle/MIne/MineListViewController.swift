//
//  GKWYListViewController.swift
//  GKPageScrollViewSwift
//
//  Created by gaokun on 2019/2/22.
//  Copyright © 2019 gaokun. All rights reserved.
//

import UIKit

enum mineType:Int {
    case history
    case collect
    case like
}

class MineListViewController: GKBaseTableViewController {

    var scrollCallBack: ((UIScrollView) -> ())?
    var type: mineType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.gk_navigationBar.isHidden = true
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "listCell")
        self.tableView.showsVerticalScrollIndicator = false
        
        let refreshC = UIRefreshControl.init()
        refreshC.attributedTitle = .init(string: "下拉刷新")
        refreshC.addTarget(self, action: #selector(refresh), for: .valueChanged)
//        self.tableView.addSubview(refreshC)
        self.tableView.refreshControl = refreshC
        self.tableView.refreshControl!.beginRefreshing()
        self.refresh(refreshControl: self.tableView.refreshControl!)
    }
    
    @objc func refresh(refreshControl: UIRefreshControl){
        if self.tableView.refreshControl?.isRefreshing != nil{
//            refreshControl.attributedTitle = .init(string: "加载中...")
//            refreshControl.attributedTitle = .init(string: "下拉刷新")
//            refreshControl.endRefreshing()
        }
    }
}

extension MineListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .history:
            return 10
        case .collect:
            return 50
        case .like:
            return 100
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "第" + "\(indexPath.row+1)" + "行"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollCallBack!(scrollView)
    }
}

extension MineListViewController: GKPageListViewDelegate {
    func listScrollView() -> UIScrollView {
        return self.tableView
    }
    
    func listViewDidScroll(callBack: @escaping (UIScrollView) -> ()) {
        scrollCallBack = callBack
    }
}

//------------------------------------------------------------------------------------------
private class mineCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

