//
//  PlayBottleController.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/1/27.
//

import Foundation
import AVFoundation
import UIKit

class PlayBottleController: UIViewController {
    //appdelegate
    let app: AppDelegate = UIApplication.shared.delegate! as! AppDelegate
    
    //加载页面
    let loadingview = LoadingView()
    //播放页面
    var playbottleview: PlayBottleView!
    let bottomView = BottomView()
    
    //音频url
    var url: URL = URL(string: "https://zt-mpc.obs.cn-north-4.myhuaweicloud.com/audio%2FVoiceCard%252FRaw%252Fa_10463194_raw_1601481742792_OPPO_PCAM10_69.m4a")!
    //播放器
    var player: AVPlayer!
    //获取播放信息
    var playerItem: AVPlayerItem!
    //计数器
    var timeObserve: Any?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("isAutomatic:\(app.isAutomatic)")
        
        //设置渐变背景
        setupViewBg()
        setupView()
        

        
        //获取瓶子id
        
        
        //准备音频
        playBottle()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        player.pause()
    }
    
//----------------------------------------------------------------------------------------------------
    fileprivate func setupView(){
        //初始化播放页面
        playbottleview = PlayBottleView(frame: self.view.bounds)
        self.view.addSubview(playbottleview)
        playbottleview.alpha = 0
        
        //底部导航视图
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = CommonOne().LDColor(rgbValue: 0x000000, al: 0.5)
        bottomView.snp.makeConstraints {(make) in
            make.width.left.equalToSuperview()
            make.bottom.equalTo(-CommonOne().bottomPadding)
            make.height.equalTo(50)
        }

        
        //捞瓶子加载动画
        self.view.addSubview(loadingview)
        loadingview.snp.makeConstraints {(make) in
            make.width.height.equalTo(150)
            make.center.equalToSuperview()
        }

    }
    
    fileprivate func setupViewBg(){
        let ui = UIView(frame: self.view.bounds)
        ui.layer.addSublayer(CommonOne().gradientLayer)
        self.view.addSubview(ui)
        
        
    }
    
    fileprivate func playBottle(){
        
        playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        
        //监听音频加载状态
        playerItem.addObserver(self, forKeyPath: "status", options: [.new], context:nil)

        //播放时间处理
        playTime()

        //监听播放结束状态
        NotificationCenter.default.addObserver(self, selector: #selector(playEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status"{
            print("1")
            switch playerItem.status {
            case AVPlayerItem.Status.readyToPlay:
                print("准备好了")
                //显示播放页
                showPlayView()
            case AVPlayerItem.Status.failed:
                print("失败")
            case AVPlayerItem.Status.unknown:
                print("未知")
            default:
                break
            }
        }
        

    }

    //播放时间处理
    fileprivate func playTime(){
        timeObserve = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 1000), queue: DispatchQueue.main, using: { (time) in
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds(self.playerItem.duration)
            print("\(current)---\(total)")
        })
    
    }
    
    //监听播放结束状态
    @objc func playEnd(){
        print("播放结束")
        player.pause()
        removeObserve()
    }
    
    //移除监听
    fileprivate func removeObserve() {
        self.player.currentItem?.removeObserver(self, forKeyPath: "status")
//        self.player.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
//        self.player.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
//        self.player.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        self.player.removeTimeObserver(timeObserve!)
        timeObserve = nil
    }
    
    //显示播放页
    fileprivate func showPlayView(){
        UIView.animate(withDuration: 1, delay: 1, animations: {
            self.loadingview.alpha = 0
            self.playbottleview.alpha = 1
        }){(finnish) in
            if finnish{
                //页面加载完后播放音频
                self.player.play()
            }
        }
    }

    
}
