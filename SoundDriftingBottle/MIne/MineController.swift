//
//  MineController.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/2/20.
//

import Foundation
import UIKit

let kCriticalPoint = -ADAPTATIONRATIO * 50.0

class MineController: GKDemoBaseViewController{
    
    let titleDataSource = JXSegmentedTitleDataSource()
    
    lazy var headerBgImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "profileImage")
        return imgView
    }()
    
    lazy var effectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.alpha = 0
        return effectView
    }()
    
    lazy var pageScrollView: GKPageScrollView = {
        let pageScrollView = GKPageScrollView(delegate: self)
        pageScrollView.mainTableView.backgroundColor = .clear
        pageScrollView.ceilPointHeight = 0
        return pageScrollView
    }()
    
    lazy var headerView: MineHeaderView = {
        let headerView = MineHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kWYHeaderHeight))
        return headerView
    }()
    
    let titles = ["历史", "收藏", "喜欢"]
    lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 40))
        segmentedView.delegate = self
        
        titleDataSource.titles = self.titles
        titleDataSource.titleNormalColor = .black
        titleDataSource.titleSelectedColor = .gray
        titleDataSource.titleNormalFont = UIFont.systemFont(ofSize: 16.0)
        titleDataSource.titleSelectedFont = UIFont.boldSystemFont(ofSize: 16.0)
        titleDataSource.reloadData(selectedIndex: 0)
        segmentedView.dataSource = titleDataSource
        
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = CommonOne().LDColor(rgbValue: 0x20B2BB, al: 1.0)
        lineView.indicatorWidth = 30.0
        lineView.lineStyle = .lengthenOffset
        segmentedView.indicators = [lineView]
        
        segmentedView.contentScrollView = self.scrollView
        
        // 添加分割线
        let btnLineView = UIView()
        btnLineView.frame = CGRect(x: 0, y: 40 - 0.5, width: kScreenW, height: 0.5)
        btnLineView.backgroundColor = .gray
        segmentedView.addSubview(btnLineView)
        
        segmentedView.reloadData()
        
        return segmentedView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollW = kScreenW
        let scrollH = kScreenH - kNavBar_Height - 40.0
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 40, width: scrollW, height: scrollH))
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.gk_openGestureHandle = true
        
        for (index, vc) in self.childVCs.enumerated() {
            self.addChild(vc)
            scrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: CGFloat(index) * scrollW, y: 0, width: scrollW, height: scrollH)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(self.childVCs.count) * scrollW, height: 0)
        
        return scrollView
    }()
    
    lazy var childVCs: [MineListViewController] = {
        var childVCs = [MineListViewController]()
        childVCs.append(MineListViewController())
        childVCs.append(MineListViewController())
        childVCs.append(MineListViewController())
        return childVCs
    }()
    
    lazy var pageView: UIView! = {
        let pageView = UIView()
        pageView.backgroundColor = UIColor.clear
        pageView.addSubview(self.segmentedView)
        pageView.addSubview(self.scrollView)
        return pageView
    }()
    
//----------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gk_navBackgroundColor = UIColor.clear
        self.gk_statusBarStyle = .darkContent
        self.gk_navTitleColor = UIColor.white
        self.gk_navLineHidden = true
        
        self.view.addSubview(self.headerBgImgView)
        self.view.addSubview(self.effectView)
        self.view.addSubview(self.pageScrollView)
        
        self.pageScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: kNavBar_Height, left: 0, bottom: 0, right: 0))
        }
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.equalTo(kScreenW)
            make.height.equalTo(kWYHeaderHeight)
        }
        
        self.headerBgImgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(kCriticalPoint)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.headerView.snp.top).offset(kWYHeaderHeight - kCriticalPoint)
            make.height.greaterThanOrEqualTo(kNavBar_Height)
        }
        
        self.effectView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(kCriticalPoint)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.headerView.snp.top).offset(kWYHeaderHeight - kCriticalPoint)
            make.height.greaterThanOrEqualTo(kNavBar_Height)
        }
        
        self.pageScrollView.reloadData()
        
        //
        self.headerView.setupBtn.addTarget(self, action: #selector(setupAction), for: .touchUpInside)
        
    }
    
    //------------------------------------------------------------------------------------------
    //设置页面
    @objc func setupAction(){
        let setupvc = SetupController()
        self.navigationController?.pushViewController(setupvc, animated: true)
    }
    
}


//------------------------------------------------------------------------------------------

extension MineController: GKPageScrollViewDelegate{
    func listView(in pageScrollView: GKPageScrollView) -> [GKPageListViewDelegate] {
        return self.childVCs
    }
    
    func headerView(in pageScrollView: GKPageScrollView) -> UIView {
        return self.headerView
    }
    
    func pageView(in pageScrollView: GKPageScrollView) -> UIView {
        return self.pageView
    }
    
    func mainTableViewDidScroll(_ scrollView: UIScrollView, isMainCanScroll: Bool) {
        let offsetY = scrollView.contentOffset.y
        print("---\(offsetY)---")
        
        if offsetY >= kWYHeaderHeight {
            self.headerBgImgView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.view)
                make.left.right.equalTo(self.view)
                make.height.equalTo(kNavBar_Height)
            }
            
            self.effectView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.view)
                make.left.right.equalTo(self.view)
                make.height.equalTo(kNavBar_Height)
            }
            self.effectView.alpha = 1.0
        }else {
            // 0到临界点 高度不变
            if offsetY <= 0 && offsetY >= kCriticalPoint {
                let criticalOffsetY = offsetY - kCriticalPoint
                
                self.headerBgImgView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.view).offset(-criticalOffsetY)
                    make.left.right.equalTo(self.view)
                    make.bottom.equalTo(self.headerView.snp.top).offset(kWYHeaderHeight + criticalOffsetY)
                }
                
                self.effectView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.view).offset(-criticalOffsetY)
                    make.left.right.equalTo(self.view)
                    make.bottom.equalTo(self.headerView.snp.top).offset(kWYHeaderHeight + criticalOffsetY)
                }
            }else { // 下拉放大
                self.headerBgImgView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.view)
                    make.left.right.equalTo(self.view)
                    make.bottom.equalTo(self.headerView.snp.top).offset(kWYHeaderHeight)
                }
                
                self.effectView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.view)
                    make.left.right.equalTo(self.view)
                    make.bottom.equalTo(self.headerView.snp.top).offset(kWYHeaderHeight)
                }
            }
            
            // 背景虚化
            // offsetY: 0 - kWYHeaderHeight 透明度alpha: 0-1
            var alpha: CGFloat = 0.0
            if offsetY <= 0 {
                alpha = 0.0
            }else if offsetY < kWYHeaderHeight {
                alpha = offsetY / kWYHeaderHeight
            }else {
                alpha = 1.0
            }
            self.effectView.alpha = alpha
            
            let show = isAlbumNameLabelShowingOn()
            
            if show {
                self.gk_navTitle = ""
            }else {
                self.gk_navTitle = self.headerView.nameLabel.text
            }
        }
    }
    
    func isAlbumNameLabelShowingOn() -> Bool {
        let view = self.headerView.nameLabel
        
        // 获取titleLabel在视图上的位置
        var showFrame = self.view.convert((view?.frame)!, from: view?.superview)
        showFrame.origin.y -= kNavBar_Height
        
        // 判断是否有重叠部分
        let intersects = self.view.bounds.intersects(showFrame)
        
        return !(view?.isHidden)! && (view?.alpha)! > CGFloat(0.01) && intersects
    }
    
}

extension MineController: JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        print("刷新数据")
    }
}

extension MineController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.pageScrollView.horizonScrollViewWillBeginScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageScrollView.horizonScrollViewDidEndedScroll()
    }
}
