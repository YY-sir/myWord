//
//  PickingUpBottlesController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/1/26.
//

import Foundation
import UIKit

class PickingUpBottlesController: UIViewController {
    var isPickup = true
    var pickupview : PickingUpBottlesView!
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.white
        pickupview = PickingUpBottlesView(frame: self.view.bounds)
        self.view.addSubview(pickupview)
        pickupview.mainScrollView.delegate = self
        isPickup = true

    }
    
    //将页面初始化
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isPickup = true
        pickupview.mainScrollView.contentOffset.y = -(CommonOne().topPadding)
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
