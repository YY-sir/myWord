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
    //耳返
    let AUROC = AudioUnitRecord()
    
    var recordview: RecordView!
    //录音播放按钮状态：开始录音-0；结束录音-1；播放录音-2；暂停录音-3
    var buttonStatus = 0
    //判断是否取消过
    var isCancel = false
    //上一次变声标签
    var lastTimeChangeLabel = -1
    
    //录音机
    var audioRecorder: AVAudioRecorder!
    var time1970: String!
    //音频存储地址
    var path: String!
    var pathP: String!
    var pathOut: String!
    var pathOutC: String!
    var recordName: String!
    var url: NSURL!
    var timer1: Timer!
    var recordTime: Float = 0
    var recordTotalTime: Float!
    //录音机配置
    private let recorderSetting =  [AVFormatIDKey: kAudioFormatLinearPCM,
                                    AVNumberOfChannelsKey: 1,
                                    AVSampleRateKey: 42000.0,
                                    AVLinearPCMBitDepthKey: 16,
                                    AVEncoderAudioQualityKey: kRenderQuality_High,
                                    AVEncoderBitRateKey: 12800,
                                    AVLinearPCMIsFloatKey: false,
                                    AVLinearPCMIsNonInterleaved: false,
                                    AVLinearPCMIsBigEndianKey: false] as [String : Any]
    ///波形更新计时器
    private var timer2: Timer?
    ///音频波形更新间隔
    private let updateFequency = 0.07
    /// 声音数据数组
    private var soundMeters: [Float]!
    /// 声音数据数组容量
    private let soundMeterCount = columnNumber
    /// 录音框
    private var volumeview: MCVolumeView!

    
    
    //播放器
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var timeObserve: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置导航栏
        setupNav()
        
        //设置背景颜色
        setupViewBg()
        
        //设置音效动效
        setupVolumeview()

        //设置选项和播放视图
        setupRecordview()
        
        //添加按钮事件
        recordview.recordB.addTarget(self, action: #selector(recordAction(sender:)), for: .touchUpInside)
        recordview.cancelB.addTarget(self, action: #selector(cancelOrCommitAction(sender:)), for: .touchUpInside)
        recordview.commitB.addTarget(self, action: #selector(cancelOrCommitAction(sender:)), for: .touchUpInside)
        recordview.earReturnB.addTarget(self, action: #selector(earReturnBAction(sender:)), for: .touchUpInside)
        //监听变声按钮的选择
        NotificationCenter.default.addObserver(self, selector: #selector(changeLabelNotificationAction), name: NSNotification.Name(rawValue: "changeLabelNotification"), object: nil)
        
        //初始化音量数组
        initSoundData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //如果在录音
        //结束录音
        endRecord()
        //按钮可用
        labelButtonEnabled()
        
        //如果在播放音频
        if player != nil{
            player.pause()
        }
        removeObserve()
        //移除计时器，以免造成内存泄漏
        removeTimer()
    }
    
    //页面结束清除通知（避免内存泄漏）
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLabelNotification"), object: nil)
    }
    
//2------------------------------------------------------------------------------------------------------
    fileprivate func setupNav(){
        self.gk_navBackgroundColor = .clear
        self.gk_statusBarStyle = .lightContent
        self.gk_navTitleColor = .white
        self.gk_navLineHidden = true
    }
    
    fileprivate func setupViewBg(){
        let ui = UIView(frame: self.view.bounds)
        ui.layer.addSublayer(CommonOne().gradientLayer)
        self.view.addSubview(ui)
    }
    
    fileprivate func setupVolumeview(){
        volumeview = MCVolumeView(frame: CGRect(x: self.view.center.x - 50, y: 200, width: 100, height: 80), type: .line)
        self.view.addSubview(volumeview)
        volumeview.snp.makeConstraints{(make) in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.top.equalTo(150)
        }
    }
    
    fileprivate func setupRecordview(){
        recordview = RecordView(frame: self.view.bounds)
        self.view.addSubview(recordview)
    }
    
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
            //按钮不可选
            labelButtonDisabled()
            
        case 1:
            print("结束录音")
            buttonStatus = 2
            //结束录音
            endRecord()
            //修改视图
            changeView()
            //按钮可用
            labelButtonEnabled()
            
            
        case 2:
            print("播放录音")
            buttonStatus = 3
            playBottle(changeLabel: recordview.changeLabel.intValue as! Int)
            
        case 3:
            print("暂停录音")
            buttonStatus = 2
            player.pause()
            recordview.recordB.setImage(UIImage.init(named: "record1"), for: .normal)
            
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
            playEnd()
            cancelData()
            cancelView()
            
        //确认操作
        }else if sender == recordview.commitB{
            print("扔瓶子")
            UIUtil.showLoading(withText: "正在扔向大海...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                UIUtil.dismissLoading()
            }
            
        }
    }
    
    //监听变声按钮的选择
    @objc func changeLabelNotificationAction(){
        print("接收通知")
        //暂停录音
        if buttonStatus == 3{
            buttonStatus = 2
            player.pause()
            recordview.recordB.setImage(UIImage.init(named: "record1"), for: .normal)
        }
    }
    
    @objc func earReturnBAction(sender: UIButton){
        var tipText: String
        if sender.isSelected{
            sender.isSelected = false
            sender.backgroundColor = .white
            tipText = "关闭耳返"
            
        }else{
            sender.isSelected = true
            sender.backgroundColor = .systemPink
            tipText = "打开耳返"
        }
        //添加弹窗提示
        UIUtil.showHint(tipText, isBlockUser: true)
        
    }
    
    
    fileprivate func initSoundData(){
        //初始化
        soundMeters = [Float]()
        for index in 0..<soundMeterCount{
            soundMeters.append(Float(Double(arc4random()%4) - 29.0))
        }
        NotificationCenter.default.post(name: NSNotification.Name.init("updateMeters"), object: soundMeters)
    }
//3------------------------------------------------------------------------------------------------------
    //开始录音
    fileprivate func startRecord(){
        UIUtil.showHint("录音不可低于3秒")
        
        //实时耳返
        if recordview.earReturnB.isSelected{
            //初始化耳返
            AUROC.initializeAudio()
            AUROC.earReturnStart()
            
        }
//        录音过程不可点击耳返按钮
        recordview.earReturnB.isEnabled = false
        recordview.earReturnB.setTitleColor(.gray, for: .normal)
        
        //View调整
        recordview.recordB.isEnabled = false
        
        //数据调整
        
        recordTotalTime = Float(recordview.bottleTime[recordview.bottleLabel])
        
        time1970 = Date().timeStamp
        print("\(time1970)")
        recordName = ("/" + time1970 + ".pcm")
        print("\(recordName)")
        path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(recordName)
        pathP = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "s.pcm"))
        pathOut = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "m.mp3"))
        print("\(path)")
        
        audioRecorder = try! AVAudioRecorder.init(url: NSURL(string: path)! as URL, settings:recorderSetting)
        //添加代理
        audioRecorder.delegate = self
        audioRecorder.prepareToRecord()
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        
        //生成计数器
        timer1 = Timer.scheduledTimer(timeInterval: updateFequency, target: self, selector: #selector(timeDown), userInfo: nil, repeats: true)
    }
    
    //倒计时
    @objc fileprivate func timeDown(){
        //更新音量大小
        audioRecorder.updateMeters()
        //打印音量大小
        print("averagePower:\(audioRecorder.averagePower(forChannel: 0))")
        print("peakPower:\(audioRecorder.peakPower(forChannel: 0))")
        self.addSoundMeter(item: audioRecorder.averagePower(forChannel: 0))
        
        
        if(recordTime >= recordTotalTime){
            buttonStatus = 2
            endRecord()
            changeView()
            labelButtonEnabled()
            return
        }
        
        recordTime += Float(updateFequency)
        //按钮3秒限制
        if(recordTime < 3){
            recordview.recordB.isEnabled = false
        }else{
            recordview.recordB.isEnabled = true
            
        }
        //录音时间显示
        recordview.timeL.text = addTimeL(currentT: recordTime, totalT: recordTotalTime)
        
    }
    //音量数组更新
    private func addSoundMeter(item: Float) {
        if soundMeters.count < soundMeterCount {
            soundMeters.append(item)
        } else {
            for (index, _) in soundMeters.enumerated() {
                if index < soundMeterCount - 1 {
                    soundMeters[index] = soundMeters[index + 1]
                }
            }
            // 插入新数据
            soundMeters[soundMeterCount - 1] = item
            NotificationCenter.default.post(name: NSNotification.Name.init("updateMeters"), object: soundMeters)
        }
    }
    
    //结束录音
    fileprivate func endRecord(){
        
//        录音结束关闭耳返
        if recordview.earReturnB.isSelected{
            AUROC.earReturnStop()
        }
//        录音结束打开耳返按钮
        recordview.earReturnB.isEnabled = true
        recordview.earReturnB.setTitleColor(.black, for: .normal)
        
        //清除录音机
        if (audioRecorder != nil){
            audioRecorder.stop()
            audioRecorder = nil
            //清除计数器
            self.timer1.invalidate()
        }
        //调整显示时间
        recordview.timeL.text = addTimeL(currentT: 0, totalT: recordTime)
        recordview.recordB.setImage(UIImage.init(named: "record1"), for: .normal)
        
        //初始化音量数组
        initSoundData()

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
    
    
    //瓶子按钮不可选
    fileprivate func labelButtonDisabled(){
        recordview.bottleIsable = false
    }
    //瓶子按钮可选
    fileprivate func labelButtonEnabled(){
        recordview.bottleIsable = true
    }
    
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
            
            //初始化时间显示
            self.recordview.timeL.text = addTimeL(currentT: 0, totalT: Float(self.recordview.bottleTime[self.recordview.bottleLabel]))
            
            //按钮初始化
            self.recordview.recordB.setImage(UIImage.init(named: "record0"), for: .normal)
            
            self.view.layoutIfNeeded()
        }){(finnish) in
            self.recordview.changeLabelViewCollection.alpha = 0
            
        }
    }
    //取消后数据调整
    fileprivate func cancelData(){
        isCancel = true
        //初始化判断值
        buttonStatus = 0
        //初始化录音时间
        recordTime = 0
        recordTotalTime = Float(recordview.bottleTime[recordview.bottleLabel])
        //移除播放器监听
        removeObserve()

    }
    
//4-------------------------------------------------------------------------
    //播放录音
    fileprivate func playBottle(changeLabel: Int){
        recordview.recordB.setImage(UIImage.init(named: "record2"), for: .normal)
        if lastTimeChangeLabel == changeLabel && !isCancel{
            player.play()
            return
        }
        isCancel = false
        removeObserve()
        lastTimeChangeLabel = changeLabel
        //变声处理
        var pathC: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "sc.pcm"))
        pathC = RecorderOC.soundChangePath(in: pathP, pathOut: pathC, soundNumber: Int32(changeLabel))
        
        pathOutC = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "mc.mp3"))
        pathOutC = RecorderOC.audio_PCMtoMP3_path(in: pathC, pathOut: pathOutC)

        print("Label:\(changeLabel);path:\(URL(string: pathOutC))")
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
        timeObserve = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 500), queue: DispatchQueue.main, using: { (time) in
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds(self.playerItem.duration)
//            self.recordTime = (Int)(CMTimeGetSeconds(self.playerItem.duration))
            //显示播放时间
            self.recordview.timeL.text = changeTime(time: Int(current)) + "/" + changeTime(time: Int(self.recordTime))
            print("\(current)---\(total)")
        })
    
    }
    //监听播放结束状态
    @objc func playEnd(){
        print("播放结束")
        buttonStatus = 2
        if (player != nil){
            recordview.recordB.setImage(UIImage.init(named: "record1"), for: .normal)
            player.pause()
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        }
    }
    //移除监听
    fileprivate func removeObserve() {
        if (timeObserve == nil){
            return
        }
        self.player.currentItem?.removeObserver(self, forKeyPath: "status")
        self.player.removeTimeObserver(timeObserve!)
        timeObserve = nil
    }
    //移除计时器
    fileprivate func removeTimer(){
        if (timer1 != nil){
            timer1.invalidate()
            timer1 = nil
        }
    }
    
    //暂停录音

    //
}

//5-------------------------------------------------------------------------
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
