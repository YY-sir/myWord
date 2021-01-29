//
//  ThrowTheBottleController.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/28.
//

import Foundation
import UIKit
class ThrowTheBottleController: UIViewController {
    var recordview: RecordView!
    var isRecord = true
    var isThrow = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "录音"
        //设置背景颜色
        setupViewBg()
        recordview = RecordView(frame: self.view.bounds)
        self.view.addSubview(recordview)
        //按钮添加事件
        recordview.recordB.addTarget(self, action: #selector(recordAction(sender:)), for: .touchUpInside)
        recordview.cancelB.addTarget(self, action: #selector(cancelOrCommitAction(sender:)), for: .touchUpInside)
        recordview.commitB.addTarget(self, action: #selector(cancelOrCommitAction(sender:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //设置导航栏
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //设置导航栏
        self.navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func setupViewBg(){
        let ui = UIView(frame: self.view.bounds)
        ui.layer.addSublayer(CommonOne().gradientLayer)
        self.view.addSubview(ui)
    }
    
    //录音按钮操作
    @objc func recordAction(sender: UIButton){
        print("111111")
        print("\(recordview.bottleLabel)---\(recordview.changeLabel)")
        
        //判断录音按钮状态
        if isRecord && !isThrow{
            isRecord = false
            isThrow = true
        }else if !isRecord && isThrow{
            //录音结束
            //修改视图
            changeView()
            //修改时间为音频的时间
            recordview.timeL.text = "555"
            
        }else if !isRecord && !isThrow{
            
        }
    }
    
    //取消或扔瓶子操作
    @objc fileprivate func cancelOrCommitAction(sender: UIButton){
        //取消操作
        if sender == recordview.cancelB{
            print("取消")
        //确认操作
        }else if sender == recordview.commitB{
            print("扔瓶子")
        }
    }
    
    fileprivate func changeView(){
        UIView.animate(withDuration: 1, animations: {
            //左移动
            self.recordview.bottleLabelViewCollection.snp.remakeConstraints {(make) in
                make.right.equalTo(self.recordview.snp.left)
                make.width.equalTo(320)
                make.height.equalTo(80)
                make.centerY.equalToSuperview()
            }
            //右移动
            self.recordview.changeLabelViewCollection.snp.remakeConstraints {(make) in
                make.center.equalToSuperview()
                make.width.equalTo(320)
                make.height.equalTo(80)
            }
            //显示按钮
            self.recordview.cancelB.alpha = 1
            self.recordview.commitB.alpha = 1
            
            self.view.layoutIfNeeded()
        }){(finnish) in
            self.recordview.bottleLabelViewCollection.alpha = 0
            
        }
    }
    


    
}
