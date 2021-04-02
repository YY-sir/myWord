//
//  PickingUpBottlesController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/1/26.
//

import Foundation
import AVFoundation
import UIKit

class PickingUpBottlesController: UIViewController {
    //appdelegate
    let app = UIApplication.shared.delegate as!AppDelegate
    
    var isPickup = true
    var pickupview : PickingUpBottlesView!
    var bottomView: BottomView = BottomView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 50 * scaleMaxV))
    
    ///背景音乐
    //音频url
    var url: String!
    var audioPlayer: AVAudioPlayer!
    var isPlay = true
    
    //滑动提示
    var tipv: WipeUpTipView?
    //滑动提示计时器
    var wipeUpTipTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        isPickup = true
        bgAudio()
        //背景音乐开关
        pickupview.audioB.addTarget(self, action: #selector(isPlayAudio), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        //调整自动操作按钮
        bottomView.autoplayButton.isOn = app.isAutomatic
        
        if audioPlayer != nil && isPlay{
            audioPlayer.play()
        }
        
        //进入后台关闭背景音乐
        NotificationCenter.default.addObserver(self, selector: #selector(intoBg), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gobackBg), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    //将页面初始化
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isPickup = true
        pickupview.mainScrollView.contentOffset.y = -(CommonOne().topPadding)
        audioPlayer.pause()
        
        //移除提示计时器
        self.wipeUpTipTimer?.invalidate()
        self.wipeUpTipTimer = nil
        
        //移除信号监听
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        audioPlayer = nil
    }
    
//-----------------------------------------------------------------------------------------
    fileprivate func setupView(){
        self.title = "首页"
        self.view.backgroundColor = UIColor.white
        

        
        pickupview = PickingUpBottlesView(frame: self.view.bounds)
        self.view.addSubview(pickupview)
        pickupview.mainScrollView.delegate = self
        
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = LDColor(rgbValue: 0x000000, al: 0.5)
        bottomView.snp.makeConstraints {(make) in
            make.width.left.equalToSuperview()
            make.bottom.equalTo(-CommonOne().bottomPadding)
            make.height.equalTo(50 * scaleMaxV)
        }
        
        tipv = WipeUpTipView(frame: self.view.bounds)
        self.view.addSubview(tipv!)
        wipeUpTipTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(removeWipeUpTip), userInfo: nil, repeats: false)
    }

//------------------------------------------------------------------------
    fileprivate func bgAudio(){
        let bun = Bundle.main.path(forResource: "Settings", ofType: "bundle")
        url = bun! + "/soundOfWaves.wav"
        audioPlayer = try? AVAudioPlayer.init(contentsOf: URL(string: url)!)
        audioPlayer.numberOfLoops = .max
        audioPlayer.volume = 0.8
        audioPlayer.play()
    }
    // 开关背景音乐
    @objc func isPlayAudio(){
        print("\(audioPlayer.isPlaying)")
        let imageName: String
        if (audioPlayer != nil) && (!audioPlayer.isPlaying){
            audioPlayer.play()
            isPlay = true
            imageName = "playMusic"
        }else{
            audioPlayer.pause()
            isPlay = false
            imageName = "stopMusic"
        }
        pickupview.audioB.setImage(UIImage.init(named: imageName), for: .normal)
    }
    
    //
    @objc func intoBg(){
        print("进入后台")
        self.audioPlayer.pause()
    }
    
    @objc func gobackBg(){
        print("返回前台")
        if isPlay{
            self.audioPlayer.play()
        }
    }
    
    //去除提示
    @objc fileprivate func removeWipeUpTip(){
        UIView.animate(withDuration: 0.7, animations: {
            self.tipv?.alpha = 0
        })
    }
}

extension PickingUpBottlesController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(scrollView.contentOffset.y)")
        let changeH = kScreenH / 896 * (310 + 100) - 100
        if (scrollView.contentOffset.y >= changeH && isPickup){
            isPickup = false
            let playbottle = PlayBottleController()
            self.navigationController?.pushViewController(playbottle, animated: true)
        }
    }
}
