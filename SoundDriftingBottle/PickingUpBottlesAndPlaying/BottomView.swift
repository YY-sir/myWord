//
//  BottomView.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/28.
//

import Foundation
import UIKit

class BottomView: UIView {
    //appdelegate
    let app = UIApplication.shared.delegate as!AppDelegate
    
    //“我的”按钮
    let mineButton = UIButton(type: .system)
    //进入录音按钮
    let recordButton = UIButton(type: .system)
    //自己操作按钮
    let autoplayButton: UISwitch = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化视图
    fileprivate func setupView(){
        self.tintColor = .white
        self.addSubview(mineButton)
        mineButton.setImage(UIImage(named: "play20"), for: .normal)
        mineButton.snp.makeConstraints {(make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
            make.left.equalTo(10)
        }
        
        self.addSubview(recordButton)
        recordButton.setImage(UIImage(named: "gotoRecord"), for: .normal)
        recordButton.snp.makeConstraints {(make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }

        self.addSubview(autoplayButton)
        autoplayButton.onTintColor = CommonOne().LDColor(rgbValue: 0x68C8D6, al: 1)
        autoplayButton.snp.makeConstraints {(make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
    }
    
    //添加按钮事件
    fileprivate func addButtonAction(){
        mineButton.addTarget(self, action: #selector(gotoNextPage), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(gotoNextPage), for: .touchUpInside)
        autoplayButton.addTarget(self, action: #selector(changeAutoSwitch), for: .valueChanged)
    }
    
    @objc func gotoNextPage(sender: UIButton){
        if sender == mineButton{
            let mine = MineController()
            self.firstViewController()?.navigationController?.pushViewController(mine, animated: true)
        }else if sender == recordButton{
            let record = ThrowTheBottleController()
            self.firstViewController()?.navigationController?.pushViewController(record, animated: true)
        }else{
            return
        }
    }
    
    //自动操作按钮值改变触发
    @objc func changeAutoSwitch(){
        app.isAutomatic = autoplayButton.isOn
        print("\(app.isAutomatic)")
        
        var tipText: String
        if app.isAutomatic{
            tipText = "打开自动捞瓶子"
        }else{
            tipText = "关闭自动捞瓶子"
        }
        //添加弹窗提示
        UIUtil.showHint(tipText, isBlockUser: true)

    }
    
}

////扩展UIView，找到最上层UIViewController
//extension UIView {
//    //返回该view所在VC
//    func firstViewController() -> UIViewController? {
//        for view in sequence(first: self.superview, next: { $0?.superview }) {
//            if let responder = view?.next {
//                if responder.isKind(of: UIViewController.self){
//                    return responder as? UIViewController
//                }
//            }
//        }
//        return nil
//    }
//}
