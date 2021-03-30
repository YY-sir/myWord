//
//  MineListViewController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/30.
//

import UIKit
import MJRefresh
import WebKit

enum mineType:Int {
    case history
    case collect
    case like
}

class MineListViewController: UIViewController {
    init(listType: mineType) {
        super.init(nibName: nil, bundle: nil)
        self.listType = listType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var listType: mineType = .history
    private weak var currentScrollView: UIScrollView?
    
    public var count = 30
    
    public var shouldLoadData = false
    
    var scrollCallBack: ((UIScrollView) -> ())?
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "tableViewCell")
        return tableView
    }()
    
    lazy var loadingView: UIImageView = {
        var images = [UIImage]()
        for i in 0..<4 {
            let imgName = "cm2_list_icn_loading" + "\(i+1)"
            
            let img = changeColor(image: UIImage(named: imgName)!, color: UIColor.rgbColor(r: 200, g: 38, b: 39))
            images.append(img)
        }
        
        for i in (0..<4).reversed() {
            let imgName = "cm2_list_icn_loading" + "\(i+1)"
            
            let img = changeColor(image: UIImage(named: imgName)!, color: UIColor.rgbColor(r: 200, g: 38, b: 39))
            images.append(img)
        }
        
        let loadingView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20.0, height: 20.0))
        loadingView.animationImages = images
        loadingView.animationDuration = 0.75
        loadingView.isHidden = true
        
        return loadingView
    }()
    
    lazy var loadLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.gray
        label.text = "正在加载..."
        label.isHidden = true
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.currentScrollView = self.tableView
        
        self.currentScrollView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        
        self.currentScrollView?.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            DispatchQueue.main.asyncAfter(deadline: .now() + refreshDuration) {
                self.loadMoreData()
            }
        })
        
        if self.shouldLoadData {
            self.currentScrollView!.addSubview(self.loadingView)
            self.currentScrollView!.addSubview(self.loadLabel)
            
            self.loadingView.snp.makeConstraints { (make) in
                make.top.equalTo(self.currentScrollView!).offset(40.0)
                make.centerX.equalTo(self.currentScrollView!)
            }
            
            self.loadLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.loadingView.snp.bottom).offset(10.0)
                make.centerX.equalTo(self.loadingView)
            }
            
            self.count = 0
            self.currentScrollView?.mj_footer?.isHidden = self.count == 0
            self.reloadData()
            
            self.showLoading()
 
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.hideLoading()
                self.loadData()
            }
        }else {
            self.loadData()
        }
    }
    
    func loadData() {
        self.count = 30
        
        self.addCellToScrollView()
 
        self.reloadData()
    }
    
    func loadMoreData() {
        self.count += 20
        //结束刷新状态
        if self.count >= 250 {
            self.currentScrollView?.mj_footer?.endRefreshingWithNoMoreData()
        }else {
            self.currentScrollView?.mj_footer?.endRefreshing()
        }
        
        self.reloadData()
    }
    
    func addCellToScrollView() {
        
  
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func showLoading() {
        self.loadingView.isHidden = false
        self.loadLabel.isHidden = false
        self.loadingView.startAnimating()
    }
    
    func hideLoading() {
        self.loadingView.isHidden = true
        self.loadLabel.isHidden = true
        self.loadingView.stopAnimating()
    }
}

extension MineListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.mj_footer?.isHidden = self.count == 0
        return self.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = "第\(indexPath.row+1)行"
        return cell
    }
}

extension MineListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollCallBack!(scrollView)
    }
}

extension MineListViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载成功")
        self.hideLoading()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("加载失败")
        self.hideLoading()
    }
}

extension MineListViewController: GKPageListViewDelegate {
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return self.tableView
    }
    
    func listViewDidScroll(callBack: @escaping (UIScrollView) -> ()) {
        scrollCallBack = callBack
    }
}






////
////  GKWYListViewController.swift
////  GKPageScrollViewSwift
////
////  Created by gaokun on 2019/2/22.
////  Copyright © 2019 gaokun. All rights reserved.
////
//
//import UIKit
//import MJRefresh
//import WebKit
//
//enum mineType:Int {
//    case history
//    case collect
//    case like
//}
//
//class MineListViewController: UIViewController {
//
//    private weak var currentScrollView: UIScrollView?
//    var scrollCallBack: ((UIScrollView) -> ())?
//    var type: mineType!
//
//
//    init(type: mineType) {
//        super.init(nibName: nil, bundle: nil)
//        self.type = type
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public lazy var tableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.separatorStyle = .none
//        if #available(iOS 11.0, *) {
//            tableView.contentInsetAdjustmentBehavior = .never
//        }
//        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "MineListCell")
//        return tableView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.gk_navigationBar.isHidden = true
//
//        self.view.addSubview(self.tableView)
//
//        self.currentScrollView = self.tableView
//        self.currentScrollView?.snp.makeConstraints{(make) in
//            make.edges.equalToSuperview()
//        }
//
//        self.currentScrollView?.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
//            DispatchQueue.main.asyncAfter(deadline: .now() + kRefreshDuration) {
//                self.tableView.reloadData()
//            }
//        })
//
////        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "listCell")
////        self.tableView.showsVerticalScrollIndicator = false
//
//    }
//
//    @objc func refresh(refreshControl: UIRefreshControl){
//
//    }
//}
//
//extension MineListViewController : UITableViewDelegate, UITableViewDataSource{
////    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        switch type {
////        case .history:
////            return 10
////        case .collect:
////            return 50
////        case .like:
////            return 100
////        default:
////            return 0
////        }
////    }
////
////    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
////        cell.selectionStyle = .none
////        cell.textLabel?.text = "第" + "\(indexPath.row+1)" + "行"
////        return cell
////    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch type {
//        case .history:
//            return 10
//        case .collect:
//            return 50
//        case .like:
//            return 100
//        default:
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MineListCell", for: indexPath)
//        cell.textLabel?.text = "第\(indexPath.row+1)行"
//        return cell
//    }
//
//}
//
//extension MineListViewController{
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollCallBack?(scrollView)
//    }
//}
//
//extension MineListViewController: GKPageListViewDelegate {
//    func listView() -> UIView {
//        return self.view
//    }
//
//    func listScrollView() -> UIScrollView {
//        return self.tableView
//    }
//
//    func listViewDidScroll(callBack: @escaping (UIScrollView) -> ()) {
//        scrollCallBack = callBack
//    }
//}
//
//
