//
//  FunctionIntroductionView.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/5.
//

import Foundation
import UIKit
class FunctionIntroductionView: UIView {
    let contentScrollview = UIScrollView()
    let contentTextfiled = UITextField()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupScrollview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        self.addSubview(contentScrollview)
        contentScrollview.snp.makeConstraints{(make) in
            make.height.width.equalToSuperview()
        }
        contentScrollview.contentSize = CGSize(width: contentScrollview.frame.width, height: 1500)
    }
    
    fileprivate func setupScrollview(){
        contentScrollview.addSubview(label)
        label.snp.makeConstraints{(make) in
            make.top.left.equalTo(10)
            make.width.equalToSuperview().offset(-20)
        }
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.text = "1.播放音频\n" + "2.进度条显示和控制播放进度\n" + "3.自动获取下一个音频\n" + "4.录音\n" + "5.耳返\n" + "6.柱形和线形波形图\n" + "7.音频降噪\n" + "8.音频变声\n" + "9.密码md5加密\n" + "10.音频OBS存储\n"

        //动态获得label的高度，再调整scrollview contentSize的高度
        let labelMaxSize = CGSize(width: self.frame.width - 20, height: 1500)
        let realSize = label.sizeThatFits(labelMaxSize)
        contentScrollview.contentSize = CGSize(width: contentScrollview.frame.width, height: realSize.height + 50)
        contentScrollview.isScrollEnabled = true
        
    }
}
