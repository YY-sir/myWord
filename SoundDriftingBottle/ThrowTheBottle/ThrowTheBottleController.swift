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
    var isRecord = true
    var isThrow = false
    
    var audioRecorder: AVAudioRecorder!
    var time1970: String!
    var path: String!
    var pathP: String!
    var pathOut: String!
    var pathOutMp3: String!
    var pathOutChange: String!
    var recordName: String!
    var url: NSURL!
    
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
            //开始录音
            startRecord()
        }else if !isRecord && isThrow{
            //结束录音
            endRecord()
            //修改视图
            changeView()
            //修改时间为音频的时间
            recordview.timeL.text = CommonOne().changeTime(time: 555)
            
        }else if !isRecord && !isThrow{
            
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
//        recordview.recordB.isEnabled = false
        //数据调整
        time1970 = Date().timeStamp
        print("\(time1970)")
        recordName = ("/" + time1970 + ".pcm")
        print("\(recordName)")
        path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(recordName)
        pathP = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "c.pcm"))
        pathOut = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "m.mp3"))
        app.recordMp3 = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "mc.mp3"))
        app.recordPcmC = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending(("/" + time1970 + "pc.pcm"))
        print("\(path)")
        audioRecorder = try! AVAudioRecorder.init(url: NSURL(string: path)! as URL, settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVNumberOfChannelsKey: 1, AVSampleRateKey: 44100, AVLinearPCMBitDepthKey: 16, AVEncoderAudioQualityKey: kRenderQuality_High, AVEncoderBitRateKey: 12800, AVLinearPCMIsFloatKey: false, AVLinearPCMIsNonInterleaved: false, AVLinearPCMIsBigEndianKey: false])
        
        //添加代理
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    //结束录音
    fileprivate func endRecord(){
        audioRecorder.stop()
        audioRecorder = nil

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
        isRecord = true
        isThrow = false
        

    }
}

extension ThrowTheBottleController: AVAudioRecorderDelegate{
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("录音结束")
        //对原声进行降噪 并转为mp3
        app.recordPcm = RecorderOC.noiseSuppressPath(path, pathOut: pathP)
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
