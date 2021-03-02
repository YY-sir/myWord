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
    var bottomView: BottomView = BottomView()
    
    ///背景音乐
    //音频url
    var url: String!
    var audioPlayer: AVAudioPlayer!
    var isPlay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        isPickup = true
        bgAudio()
        //背景音乐开关
        pickupview.audioB.addTarget(self, action: #selector(isPlayAudio), for: .touchUpInside)
        
        //进入后台关闭背景音乐
        NotificationCenter.default.addObserver(self, selector: #selector(intoBg), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gobackBg), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        //调整自动操作按钮
        bottomView.autoplayButton.isOn = app.isAutomatic
        
        if audioPlayer != nil && isPlay{
            audioPlayer.play()
        }
    }
    
    //将页面初始化
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isPickup = true
        pickupview.mainScrollView.contentOffset.y = -(CommonOne().topPadding)
        audioPlayer.pause()
    }
    
    deinit {
        audioPlayer = nil
        print("111")
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
            make.height.equalTo(50)
        }
    }

//------------------------------------------------------------------------
    fileprivate func bgAudio(){
        let bun = Bundle.main.path(forResource: "Settings", ofType: "bundle")
        url = bun! + "/soundOfWaves.wav"
        print("url:\(url)")
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
