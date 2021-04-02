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

let mineListHeight = 40

class MineListViewController: UIViewController {
    var currentCollectIndex: Int?
    var currentdeleteIndex: Int?
    var collectNotification: Notification?
    var deleteNotification: Notification?
    var notificationObject: String?
    
    init(listType: mineType) {
        super.init(nibName: nil, bundle: nil)
        self.listType = listType
        switch self.listType {
        case .history:
            self.notificationObject = "history"
        case .collect:
            self.notificationObject = "collect"
        case .like:
            self.notificationObject = "like"
        }
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
        tableView.register(MineListTableViewCell.self, forCellReuseIdentifier: "tableViewCell")
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
 
            DispatchQueue.main.asyncAfter(deadline: .now() + refreshDuration) {
                self.hideLoading()
                self.loadData()
            }
        }else {
            self.loadData()
        }
        
        self.addNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData() {
        self.count = 25
 
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
        let cell: MineListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! MineListTableViewCell
        cell.logoImgView.image = UIImage.init(named: "piaoliuping1")
        cell.nameLabel.text = "第" + String(indexPath.row) + "行"
        cell.collectB.setImage(UIImage.init(named: "mine_like"), for: .normal)
        cell.deleteB.setImage(UIImage.init(named: "mine_shanchu2"), for: .normal)
        cell.index = indexPath.row
        cell.type = self.notificationObject
        cell.selectionStyle = .none
        
        if self.listType == .collect{
            cell.collectB.removeFromSuperview()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playbottlecontroller = PlayBottleController()
        self.navigationController?.pushViewController(playbottlecontroller, animated: true)
    }
}

extension MineListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollCallBack!(scrollView)
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

//MARK: - 接收通知
extension MineListViewController{
    fileprivate func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(collectAction(notification:)), name: NSNotification.Name(rawValue: "MineCollectAction"), object: self.notificationObject)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAction(notification:)), name: NSNotification.Name(rawValue: "MineDeleteAction"), object: self.notificationObject)
    }
    
    //收藏操作
    @objc func collectAction(notification: Notification){
        print("接收通知：\(notification)")
    }
    //删除操作
    @objc func deleteAction(notification: Notification){
        print("接收通知：\(notification)")
        self.count -= 1
        print("count:\(count)")
        self.tableView.reloadData()
    }
}
