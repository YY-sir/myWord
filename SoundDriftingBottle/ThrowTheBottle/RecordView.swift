//
//  RecordView.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/29.
//

import Foundation
import UIKit
class RecordView: UIView {
    let app = UIApplication.shared.delegate as! AppDelegate
    let RecorderOC = Recorder()
    
    //设置音效动效视图
    let volumeview = MCVolumeView()
    
    //collection的cell的显示数据
    var bottleCellList: [CommonTwo] = []
    var changeCellList: [CommonTwo] = []
    
    var bottleLabelViewCollection: UICollectionView!
    var changeLabelViewCollection: UICollectionView!
    
    var isRecord = true
    var bottleLabel: Int!
    dynamic var changeLabel: NSNumber!
    let bottleLabelText = ["普通瓶", "心情瓶", "音乐瓶", "故事瓶", "愿望瓶"]
    let bottleImage = ["bottle1_nomal", "bottle2_moon", "bottle3_music", "bottle4_story", "bottle5_wish"]
    let bottleTime = [10, 20, 30, 40, 50]
    var bottleIsable = true
    
    let changeLabelText = ["原声", "萝莉", "少女", "大叔", "魔兽", "搞怪", "网红女", "惊悚", "空灵"]
    let changeImage = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    
    let recordView = UIView()
    let recordB = UIButton()
    let timeL = UILabel()
    let cancelB = UIButton()
    let commitB = UIButton()
    
//    耳返
    let earReturnB = UIButton()
    
//    音频波形图
    let volumeviewChooseB = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始化cell显示数据
        initCellData()
        //
        setupView()
        //设置录音一块视图
        setupRecordView()
        //初始化所选标签
        initLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initCellData(){
        for index in 0..<5 {
            let bottleCell = CommonTwo()
            bottleCell.id = index
            if index == 0 {
                bottleCell.bgColor = LDColor(rgbValue: 0xffffff, al: 0.35)
                bottleCell.labelColor = .white
            }else{
                bottleCell.bgColor = LDColor(rgbValue: 0x213324, al: 0)
                bottleCell.labelColor = .black
            }
            bottleCellList.append(bottleCell)
        }
        
        for index in 0..<9 {
            let bottleCell = CommonTwo()
            bottleCell.id = index
            if index == 0 {
                bottleCell.bgColor = LDColor(rgbValue: 0xffffff, al: 0.35)
                bottleCell.labelColor = .white
            }else{
                bottleCell.bgColor = LDColor(rgbValue: 0x213324, al: 0)
                bottleCell.labelColor = .black
            }
            changeCellList.append(bottleCell)
        }
    }
    
    fileprivate func setupView(){        
        
        setupBottleLabelView()
        self.addSubview(bottleLabelViewCollection)
        bottleLabelViewCollection.backgroundColor = .clear
        bottleLabelViewCollection.snp.makeConstraints {(make) in
            make.center.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(80)
        }
        
        setupChangeLabelView()
        self.addSubview(changeLabelViewCollection)
        changeLabelViewCollection.backgroundColor = .clear
        changeLabelViewCollection.snp.makeConstraints {(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.snp.right)
            make.width.equalTo(320)
            make.height.equalTo(80)
        }

        
        self.addSubview(recordView)
        recordView.snp.makeConstraints {(make) in
            make.top.equalTo(bottleLabelViewCollection.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
        }
        
        self.addSubview(earReturnB)
        earReturnB.backgroundColor = .white
        earReturnB.setTitle("耳返", for: .normal)
        earReturnB.setTitleColor(.black, for: .normal)
        earReturnB.layer.cornerRadius = 5
        earReturnB.clipsToBounds = true
        earReturnB.snp.makeConstraints {(make) in
            make.width.height.equalTo(50)
            make.bottom.equalTo(-50)
            make.right.equalTo(-20)
        }
        
        self.addSubview(volumeviewChooseB)
        volumeviewChooseB.backgroundColor = .white
        volumeviewChooseB.setTitle("波形", for: .normal)
        volumeviewChooseB.setTitleColor(.black, for: .normal)
        volumeviewChooseB.layer.cornerRadius = 5
        volumeviewChooseB.clipsToBounds = true
        volumeviewChooseB.snp.makeConstraints {(make) in
            make.width.height.equalTo(50)
            make.bottom.equalTo(-50)
            make.right.equalTo(earReturnB.snp.left).offset(-20)
        }
    }
    
    //上面选择BottleCollectionView
    func setupBottleLabelView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
//        layout.minimumLineSpacing = 3
        layout.scrollDirection = .horizontal
        bottleLabelViewCollection = UICollectionView(frame: CGRect(x: 50, y: 200, width: 300, height: 50), collectionViewLayout: layout)
        bottleLabelViewCollection.delegate = self
        bottleLabelViewCollection.dataSource = self
        bottleLabelViewCollection.register(RecordViewCell.self, forCellWithReuseIdentifier: RecordViewCell.reused)
        bottleLabelViewCollection.showsHorizontalScrollIndicator = false
        bottleLabelViewCollection.showsVerticalScrollIndicator = false
    }

    //下面选择ChangeBollectionView
    func setupChangeLabelView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
//        layout.minimumLineSpacing = 3
        layout.scrollDirection = .horizontal
        changeLabelViewCollection = UICollectionView(frame: CGRect(x: 50, y: 200, width: 300, height: 50), collectionViewLayout: layout)
        changeLabelViewCollection.delegate = self
        changeLabelViewCollection.dataSource = self
        changeLabelViewCollection.register(RecordViewCell.self, forCellWithReuseIdentifier: RecordViewCell.reused)
        changeLabelViewCollection.showsHorizontalScrollIndicator = false
        changeLabelViewCollection.showsVerticalScrollIndicator = false
    }

    //下面录音页面
    fileprivate func setupRecordView(){
        recordView.addSubview(recordB)
        recordB.setImage(UIImage.init(named: "record0"), for: .normal)
        recordB.snp.makeConstraints {(make) in
            make.centerX.top.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        recordView.addSubview(timeL)
        timeL.text = "0:00/" + SoundDriftingBottle.changeTime(time: bottleTime[0])
        timeL.snp.makeConstraints {(make) in
            make.centerX.bottom.equalToSuperview()
            make.top.equalTo(recordB.snp.bottom).offset(10)
        }
        
        recordView.addSubview(cancelB)
        cancelB.alpha = 0
        
        cancelB.setTitle("取消", for: .normal)
        cancelB.snp.makeConstraints {(make) in
            make.left.equalToSuperview()
            make.centerY.equalTo(recordB)
        }
        
        recordView.addSubview(commitB)
        commitB.alpha = 0
        
        commitB.setTitle("扔瓶子", for: .normal)
        commitB.snp.makeConstraints {(make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(recordB)
        }
        
    }
    
    //初始化所选标签
    func initLabel(){
        bottleLabel = 0
        changeLabel = 0
    }
    
    //时间操作
    func changeTime(){
        timeL.text = "5555"
    }

}

//-----------------------------------------------------------------------------------------------------
//collection的代理和数据
extension RecordView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //返回cell的数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bottleLabelViewCollection{
            return 5
        }else if collectionView == changeLabelViewCollection{
            return 9
        }
        return 0
    }
    
    //对cell进行初始化
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordViewCell.reused, for: indexPath) as!RecordViewCell
        
        //把原先复用的cell的ui清除
//        for subView in cell.subviews{
//            subView.removeFromSuperview()
//        }
        
        //对cell进行ui设计
        if collectionView == bottleLabelViewCollection{
            cell.backgroundColor = bottleCellList[indexPath.row].bgColor
            cell.bottleL.textColor = bottleCellList[indexPath.row].labelColor
            cell.bottleL.text = bottleLabelText[indexPath.row]
            cell.bottleI.image = UIImage(named: bottleImage[indexPath.row])
        }else if collectionView == changeLabelViewCollection{
            cell.backgroundColor = changeCellList[indexPath.row].bgColor
            cell.bottleL.textColor = changeCellList[indexPath.row].labelColor
            cell.bottleL.text = changeLabelText[indexPath.row]
            cell.bottleI.image = UIImage(named: changeImage[indexPath.row])
            
        }
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    //cell选择后
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelector:\(indexPath)")
        //1.对cell的list数组进行初始化
        changeCell(indexPath: indexPath.row, collection: collectionView)
        
        //标签的选择
        if collectionView == bottleLabelViewCollection{
            if bottleIsable{
                bottleLabel = indexPath.row
                timeL.text = "0:00/" + SoundDriftingBottle.changeTime(time: bottleTime[indexPath.row])
                //2.重新载入collection
                self.bottleLabelViewCollection.reloadData()
            }else{
                UIUtil.showHint("录音中不可修改哦~")
            }
        }else if collectionView == changeLabelViewCollection{
            //changeLabel改变就发通知停止播放
            changeLabel = NSNumber(value: indexPath.row)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeLabelNotification"), object: self, userInfo: nil)
            
            self.changeLabelViewCollection.reloadData()
        }
        print("changeLabel:\(changeLabel)")
    }
    
    //cell选中后的view
    fileprivate func changeCell(indexPath: Int, collection: UICollectionView){
        if collection == bottleLabelViewCollection{
            for index in 0..<5{
                if index == indexPath{
                    bottleCellList[index].bgColor = LDColor(rgbValue: 0xffffff, al: 0.35)
                    bottleCellList[index].labelColor = .white
                    continue
                }
                bottleCellList[index].bgColor = LDColor(rgbValue: 0x213324, al: 0)
                bottleCellList[index].labelColor = .black
            }
        }else if collection == changeLabelViewCollection{
            for index in 0..<9{
                if index == indexPath{
                    changeCellList[index].bgColor = LDColor(rgbValue: 0xffffff, al: 0.35)
                    changeCellList[index].labelColor = .white
                    continue
                }
                changeCellList[index].bgColor = LDColor(rgbValue: 0x213324, al: 0)
                changeCellList[index].labelColor = .black
            }
        }
        
    }
}

//-----------------------------------------------------------------------------------------------------
//重写UICollectionViewCell类
private class RecordViewCell: UICollectionViewCell {
    static let reused: String = "RecordViewCellIdentify"
    let bottleL = UILabel()
    let bottleI = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bottleI)
        bottleI.snp.makeConstraints {(make) in
            make.centerX.top.equalToSuperview()
            make.height.width.equalTo(55)
        }
        self.addSubview(bottleL)
        bottleL.snp.makeConstraints {(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(bottleI.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
