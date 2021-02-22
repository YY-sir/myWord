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
    var loadingview: LoadingView!
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
    //判断是否播放结束
    var isPlayEnd = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏
        setupNav()
        
        //设置渐变背景
        setupViewBg()
        setupView()
        setupLoadingView()
        
    
        //获取瓶子url
        getBottleURL()
        //准备音频
        playBottle()
        //添加按钮事件
        playbottleview.refreshB.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        playbottleview.playB.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        playbottleview.nextB.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        playbottleview.likeB.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        playbottleview.collectB.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)
        playbottleview.reportB.addTarget(self, action: #selector(playAction(sender:)), for: .touchUpInside)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //调整自动操作按钮
        bottomView.autoplayButton.isOn = app.isAutomatic
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pausePlayB()
    }
    
    deinit {
        print("关闭")
        removeObserve()
    }
    
//2----------------------------------------------------------------------------------------------------
    fileprivate func setupNav(){
        self.gk_navBackgroundColor = .clear
        self.gk_statusBarStyle = .lightContent
        self.gk_navTitleColor = .white
        self.gk_navLineHidden = true
    }
    
    
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
        
    }
    
    fileprivate func setupLoadingView(){
        //捞瓶子加载动画
        loadingview = LoadingView(frame: self.view.bounds)
        self.view.addSubview(loadingview)
    }
    
    fileprivate func setupViewBg(){
        let ui = UIView(frame: self.view.bounds)
        ui.layer.addSublayer(CommonOne().gradientLayer)
        self.view.addSubview(ui)
    }
    
    fileprivate func playBottle(){
        print("播放音频")
        playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        
        //监听音频加载状态
        playerItem.addObserver(self, forKeyPath: "status", options: [.new], context:nil)

        //播放时间处理
        playTime()

        //监听播放结束状态
        NotificationCenter.default.addObserver(self, selector: #selector(playEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)

    }
    
    @objc func playAction(sender: UIButton){
        print("\(sender)")
        switch sender {
        case playbottleview.refreshB:
            print("刷新")
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            playPlayB()
            
        case playbottleview.playB:
            //根据rate判断播放还是暂停状态
            if player.rate == 0.0{
                print("播放")
                playPlayB()
                
            }else{
                print("暂停")
                pausePlayB()
                
            }
            
        case playbottleview.nextB:
            print("下一首")
            nextAction()
            player.pause()

        case playbottleview.likeB:
            print("点赞")
            
        case playbottleview.collectB:
            print("收藏")
            
        case playbottleview.reportB:
            print("举报")
            
        default:
            break
        }
    }
    
//3---------------------------------------------------------------------------------------------
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
        timeObserve = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.01667, preferredTimescale: 600), queue: DispatchQueue.main, using: { (time) in
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds(self.playerItem.duration)
            //时间
            self.playbottleview.currentTimeL.text = CommonOne().changeTime(time: Int(current))
            //进度条
            self.playbottleview.slider.value = Float(current / total)
        })
    
    }
    
    //监听播放结束状态
    @objc func playEnd(){
        print("播放结束")
        isPlayEnd = true
        pausePlayB()
        //判断是否自动获取下一首
        if app.isAutomatic{
            print("下一首")
            nextAction()
            
        }
    }
    
    //移除监听
    fileprivate func removeObserve() {
        print("移除监听")
        if timeObserve == nil{
            return 
        }
        self.player.currentItem?.removeObserver(self, forKeyPath: "status")
//        self.player.currentItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
//        self.player.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
//        self.player.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        self.player.removeTimeObserver(timeObserve!)
        timeObserve = nil
    }
    
    //显示播放页
     func showPlayView(){
        //播放时间初始化
        playbottleview.currentTimeL.text = "0:00"
        playbottleview.totalTimeL.text = CommonOne().changeTime(time: Int(CMTimeGetSeconds(self.playerItem.duration)))
        
        //显示动画
        var delayTime = 1
        if app.isAutomatic{
            delayTime = 2
        }
        UIView.animate(withDuration: 1, delay: TimeInterval(delayTime), animations: {
            self.loadingview.alpha = 0
            self.playbottleview.alpha = 1
        }){(finnish) in
            //页面加载完后播放音频
            self.playPlayB()
        }
    }
    //显示加载页
    fileprivate func showLoadingView(){
        setupLoadingView()
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingview.alpha = 1
        })
    }

    //播放、暂停按钮的切换
    fileprivate func playPlayB(){
        print("播放音频")
        player.play()
        if isPlayEnd{
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            isPlayEnd  = false
        }
        
        self.playbottleview.playB.setImage(UIImage(named: "pause20"), for: .normal)
        self.playbottleview.playB.setImage(UIImage(named: "pause20"), for: .highlighted)
    }
    fileprivate func pausePlayB(){
        player.pause()
        self.playbottleview.playB.setImage(UIImage(named: "play20"), for: .normal)
        self.playbottleview.playB.setImage(UIImage(named: "play20"), for: .highlighted)
    }
 
//4---------------------------------------------------------------------------------------------
//    下一首操作
    fileprivate func nextAction(){
        showLoadingView()
        removeObserve()
        getBottleURL()
        //加载播放器
        playBottle()
        
    }
    //音频数据处理
    //异步处理，获得url以后才加载播放器
    fileprivate func getBottleURL(){
        //获取新音频的url
        print("获取url")
    }
    
}
