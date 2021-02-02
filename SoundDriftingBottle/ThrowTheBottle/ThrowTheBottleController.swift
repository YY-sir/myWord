//
//  ThrowTheBottleController.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/28.
//

import Foundation
import AVFoundation
import UIKit
class ThrowTheBottleController: UIViewController {
    let app = UIApplication.shared.delegate as! AppDelegate
    let RecorderOC = Recorder()
    
    var recordview: RecordView!
    //录音播放按钮状态：开始录音-0；结束录音-1；播放录音-2；暂停录音-3
    var buttonStatus = 0
    //上一次变声标签
    var lastTimeChangeLabel = -1
    
    //录音机
    var audioRecorder: AVAudioRecorder!
    var time1970: String!
    var path: String!
    var pathP: String!
    var pathOut: String!
    var pathOutC: String!
    var recordName: String!
    var url: NSURL!
    var timer1: Timer!
    var recordTime: Int = 0
    var recordTotalTime: Int!
    //播放器
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var timeObserve: Any?
    
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
        //页面初始化
        
        //数据初始化
    }
    
    fileprivate func setupViewBg(){
        let ui = UIView(frame: self.view.bounds)
        ui.layer.addSublayer(CommonOne().gradientLayer)
        self.view.addSubview(ui)
    }
    
//-------------------------------------------------------------------------
    //录音按钮操作
    @objc func recordAction(sender: UIButton){
        print("\(recordview.bottleLabel)---\(recordview.changeLabel)")
        //判断录音按钮状态
        switch buttonStatus {
        case 0:
            print("开始录音")
            buttonStatus = 1
            //开始录音
            startRecord()
            
        case 1:
            print("结束录音")
            buttonStatus = 2
            //结束录音
            endRecord()
            //修改视图
            changeView()

            
        case 2:
            print("播放录音")
            buttonStatus = 3
            playBottle(bottleLabel: recordview.changeLabel)
            
        case 3:
            print("暂停录音")
            buttonStatus = 2
            player.pause()
            
        default:
            buttonStatus = 0
            break
        }
    }
    
    //取消或扔瓶子操作
    @objc fileprivate func cancelOrCommitAction(sender: UIButton){
        //取消操作
        if sender == recordview.cancelB{
            print("取消")
            cancelView()
            cancelData()
        //确认操作
        }else if sender == recordview.commitB{
            print("扔瓶子")
        }
    }
    
    //开始录音
    fileprivate func startRecord(){
        //View调整
        recordview.recordB.isEnabled = false
        
        //数据调整
        
        recordTotalTime = recordview.bottleTime[recordview.bottleLabel]
        
        time1970 = Date().timeStamp
        print("\(time1970)")
        recordName = ("/" + time1970 + ".pcm")
        print("\(recordName)")
        path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(recordName)
        pathP = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "s.pcm"))
        pathOut = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "m.mp3"))
        print("\(path)")
        audioRecorder = try! AVAudioRecorder.init(url: NSURL(string: path)! as URL, settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVNumberOfChannelsKey: 1, AVSampleRateKey: 44100, AVLinearPCMBitDepthKey: 16, AVEncoderAudioQualityKey: kRenderQuality_High, AVEncoderBitRateKey: 12800, AVLinearPCMIsFloatKey: false, AVLinearPCMIsNonInterleaved: false, AVLinearPCMIsBigEndianKey: false])
        //生成计数器
        timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeDown), userInfo: nil, repeats: true)
        //添加代理
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    //倒计时
    @objc fileprivate func timeDown(){
        if(recordTime == recordTotalTime){
            buttonStatus = 2
            endRecord()
        }
        
        recordTime += 1
        //按钮3秒限制
        if(recordTime < 3){
            recordview.recordB.isEnabled = false
        }else{
            recordview.recordB.isEnabled = true
        }
        //录音时间显示
        let time = CommonOne().changeTime(time: recordTime)
        recordview.timeL.text = time + "/" + CommonOne().changeTime(time: recordTotalTime)
    }
    
    //结束录音
    fileprivate func endRecord(){
        //清除录音机
        audioRecorder.stop()
        audioRecorder = nil
        //清除计数器
        self.timer1.invalidate()
        //调整显示时间
        recordview.timeL.text = "0:00/" + CommonOne().changeTime(time: recordTime)
    }
    
    //录音结束View改变
    fileprivate func changeView(){
        UIView.animate(withDuration: 1, animations: {
            self.recordview.changeLabelViewCollection.alpha = 1
            //左移动
            self.recordview.bottleLabelViewCollection.snp.remakeConstraints {(make) in
                make.right.equalTo(self.recordview.snp.left)
                make.width.equalTo(320)
                make.height.equalTo(80)
                make.centerY.equalToSuperview()
            }
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
    //录音结束数据调整
    
    
    //取消后View改变
    fileprivate func cancelView(){
        self.recordview.bottleLabelViewCollection.alpha = 1
        UIView.animate(withDuration: 1, animations: {
            //右移动
            self.recordview.changeLabelViewCollection.snp.remakeConstraints {(make) in
                make.left.equalTo(self.recordview.snp.right)
                make.width.equalTo(320)
                make.height.equalTo(80)
                make.centerY.equalToSuperview()
            }
            self.recordview.bottleLabelViewCollection.snp.remakeConstraints {(make) in
                make.center.equalToSuperview()
                make.width.equalTo(320)
                make.height.equalTo(80)
            }
            //显示按钮
            self.recordview.cancelB.alpha = 0
            self.recordview.commitB.alpha = 0
            
            self.view.layoutIfNeeded()
        }){(finnish) in
            self.recordview.changeLabelViewCollection.alpha = 0
            
        }
    }
    //取消后数据调整
    fileprivate func cancelData(){
        //初始化判断值
        buttonStatus = 0

    }
    
//-------------------------------------------------------------------------
    //播放录音
    fileprivate func playBottle(bottleLabel: Int){
        if lastTimeChangeLabel == bottleLabel{
            player.play()
            return
        }
        lastTimeChangeLabel = bottleLabel
        //变声处理
        var pathC: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "sc.pcm"))
        pathC = RecorderOC.soundChangePath(in: pathP, pathOut: pathC, soundNumber: Int32(bottleLabel))
        
        pathOutC = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "mc.mp3"))
        pathOutC = RecorderOC.audio_PCMtoMP3_path(in: pathC, pathOut: pathOutC)

        print("Label:\(bottleLabel);path:\(URL(string: pathOutC))")
        playerItem = AVPlayerItem.init(url: NSURL(fileURLWithPath: pathOutC) as URL)
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
                self.player.play()
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
        buttonStatus = 2
        player.pause()
//        removeObserve()
    }
    //移除监听
    fileprivate func removeObserve() {
        self.player.currentItem?.removeObserver(self, forKeyPath: "status")
        self.player.removeTimeObserver(timeObserve!)
        timeObserve = nil
    }

    
    
    //暂停录音
}

//-------------------------------------------------------------------------
extension ThrowTheBottleController: AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("录音结束")
        //对原声进行降噪 并转为mp3
        pathP = RecorderOC.noiseSuppressPath(path, pathOut: pathP)
        pathOut = RecorderOC.audio_PCMtoMP3_path(in: pathP, pathOut: pathOut)
    }
}

//扩展Date
extension Date{
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    /// 获取当前 毫秒级 时间戳 - 13位
     var milliStamp : String {
         let timeInterval: TimeInterval = self.timeIntervalSince1970
         let millisecond = CLongLong(round(timeInterval*1000))
         return "\(millisecond)"
     }
}
