//
//  PickingUpBottlesController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/1/26.
//

import Foundation
import UIKit

class PickingUpBottlesController: UIViewController {
    //appdelegate
    let app = UIApplication.shared.delegate as!AppDelegate
    
    var isPickup = true
    var pickupview : PickingUpBottlesView!
    var bottomView: BottomView = BottomView()
    
    override func viewDidLoad() {
        setupView()
        isPickup = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //将页面初始化
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isPickup = true
        pickupview.mainScrollView.contentOffset.y = -(CommonOne().topPadding)
        //获取自动操作的值
//        app.isAutomatic = pickupview.bottomView.autoplayButton
        
    }
    
    fileprivate func setupView(){
        self.title = "首页"
        self.view.backgroundColor = UIColor.white
        
        pickupview = PickingUpBottlesView(frame: self.view.bounds)
        self.view.addSubview(pickupview)
        pickupview.mainScrollView.delegate = self
        
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = CommonOne().LDColor(rgbValue: 0x000000, al: 0.5)
        bottomView.snp.makeConstraints {(make) in
            make.width.left.equalToSuperview()
            make.bottom.equalTo(-CommonOne().bottomPadding)
            make.height.equalTo(50)
        }
        
    }
}

extension PickingUpBottlesController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= 300 &&  isPickup){
            isPickup = false
            let playbottle = PlayBottleController()
            self.navigationController?.pushViewController(playbottle, animated: true)
        }
    }
}
