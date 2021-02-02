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
    
    var bottleLabelViewCollection: UICollectionView!
    var changeLabelViewCollection: UICollectionView!
    
    var isRecord = true
    var bottleLabel: Int!
    var changeLabel: Int!
    let bottleLabelText = ["普通瓶", "心情瓶", "音乐瓶", "故事瓶", "愿望瓶"]
    let bottleImage = ["bottle1_nomal", "bottle2_moon", "bottle3_music", "bottle4_story", "bottle5_wish"]
    let bottleTime = [10, 20, 30, 40, 50]
    
    let changeLabelText = ["原声", "大叔", "少女", "惊悚", "网红女", "魔兽", "搞怪", "萝莉", "空灵"]
    let changeImage = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    
    let recordView = UIView()
    let recordB = UIButton()
    let timeL = UILabel()
    let cancelB = UIButton()
    let commitB = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        //设置录音一块视图
        setupRecordView()
        //初始化所选标签
        initLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        setupBottleLabelView()
        self.addSubview(bottleLabelViewCollection)
        bottleLabelViewCollection.backgroundColor = .white
        bottleLabelViewCollection.snp.makeConstraints {(make) in
            make.center.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(80)
        }
        
        setupChangeLabelView()
        self.addSubview(changeLabelViewCollection)
        changeLabelViewCollection.backgroundColor = .white
        changeLabelViewCollection.snp.makeConstraints {(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.snp.right)
            make.width.equalTo(320)
            make.height.equalTo(80)
        }

        
        self.addSubview(recordView)
        recordView.backgroundColor = .systemPink
        recordView.snp.makeConstraints {(make) in
            make.top.equalTo(bottleLabelViewCollection.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(320)
        }
    }
    
    //上面选择BottleCollectionView
    func setupBottleLabelView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 3
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
        layout.minimumLineSpacing = 3
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
        recordB.backgroundColor = .cyan
        recordB.snp.makeConstraints {(make) in
            make.centerX.top.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        recordView.addSubview(timeL)
        timeL.text = CommonOne().changeTime(time: bottleTime[0])
        timeL.snp.makeConstraints {(make) in
            make.centerX.bottom.equalToSuperview()
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
            cell.backgroundColor = CommonOne().LDColor(rgbValue: 0x000000, al: 0.25)
            cell.bottleL.text = bottleLabelText[indexPath.row]
            cell.bottleI.image = UIImage(named: bottleImage[indexPath.row])
        }else if collectionView == changeLabelViewCollection{
            cell.backgroundColor = CommonOne().LDColor(rgbValue: 0x000000, al: 0.25)
            cell.bottleL.text = changeLabelText[indexPath.row]
            cell.bottleI.image = UIImage(named: changeImage[indexPath.row])
        }
        
        return cell
        
    }
    
    //cell选择后
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelector:\(indexPath)")
        if let cell = collectionView.cellForItem(at: indexPath){
            cell.backgroundColor = .red
            
            //标签的选择
            if collectionView == bottleLabelViewCollection {
                bottleLabel = indexPath.row
                timeL.text = CommonOne().changeTime(time: bottleTime[indexPath.row])
            }else if collectionView == changeLabelViewCollection{
                changeLabel = indexPath.row

            }
        }
        
    }
    
    //cell取消选择后
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didDeselect:\(indexPath)")
        if let cell = collectionView.cellForItem(at: indexPath){
            cell.backgroundColor = CommonOne().LDColor(rgbValue: 0x000000, al: 0.25)
        }
    }
    
    
}

//重写UICollectionViewCell类
private class RecordViewCell: UICollectionViewCell {
    static let reused: String = "RecordViewCellIdentify"
    let bottleL = UILabel()
    let bottleI = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bottleI)
        bottleI.snp.makeConstraints {(make) in
            make.width.centerX.top.equalToSuperview()
            make.height.equalTo(50)
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
