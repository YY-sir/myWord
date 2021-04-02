//
//  PickingUpBottlesView.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/1/27.
//

import Foundation
import UIKit
var cellS: Float!

class PickingUpBottlesView: UIView {
    var scrollContentH: Float!
    var overH: Float!
    
    let mainScrollView: UIScrollView = UIScrollView()
    let mainScrollViewBg: UIImageView = UIImageView()
    
    let audioB = UIButton()
    
    let labelView: UIView = UIView()
    var bottleLabelViewCollection: UICollectionView!
    let bottleLabelText = ["普通瓶", "心情瓶", "音乐瓶", "故事瓶", "愿望瓶"]
    let bottleImage = ["bottle1_nomal", "bottle2_moon", "bottle3_music", "bottle4_story", "bottle5_wish"]
    var chooseCellList = [0]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
        setupView()
        setupBottleLabelView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initData(){
        overH = Float(700.0 * kScreenH / 896)
        scrollContentH = Float(kScreenH + 70 * kScreenH / 896 + 60)
        
        cellS = Float((kScreenW - 4 * 3) / 5)
    }
    
    fileprivate func setupView(){
        self.addSubview(audioB)
        audioB.backgroundColor = .clear
        audioB.setImage(UIImage.init(named: "playMusic"), for: .normal)
        audioB.snp.makeConstraints {(make) in
            make.width.height.equalTo(40)
            make.left.equalTo(20)
            make.top.equalToSuperview().offset(CommonOne().topPadding + 20)
        }
        
        self.backgroundColor = UIColor.yellow
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(mainScrollView)
        mainScrollView.backgroundColor = UIColor.white
        mainScrollView.snp.makeConstraints {(make) in
            make.size.equalToSuperview()
        }
        
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: CGFloat(scrollContentH))
        mainScrollView.addSubview(mainScrollViewBg)
        mainScrollViewBg.image = UIImage(named: "image2")
        mainScrollViewBg.snp.makeConstraints {(make) in
            make.top.equalToSuperview().offset(-CommonOne().topPadding - 300.0 * kScreenH / 896)
            make.width.equalToSuperview()
            make.height.equalTo(scrollContentH + overH)
        }
        
        mainScrollView.addSubview(labelView)
        labelView.alpha = 0.8
        labelView.snp.makeConstraints {(make) in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(200)
        }
        
        self.bringSubviewToFront(audioB)
    }
    
    fileprivate func setupBottleLabelView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.itemSize = CGSize(width: Int(cellS), height: Int(cellS / 80 * 80))
        layout.scrollDirection = .horizontal
        
        bottleLabelViewCollection = UICollectionView(frame: CGRect(x: 50, y: 200, width: 300, height: 85), collectionViewLayout: layout)
        bottleLabelViewCollection.delegate = self
        bottleLabelViewCollection.dataSource = self
        bottleLabelViewCollection.register(PickingUpBottleCell.self, forCellWithReuseIdentifier: PickingUpBottleCell.reused)
        bottleLabelViewCollection.showsHorizontalScrollIndicator = false
        bottleLabelViewCollection.showsVerticalScrollIndicator = false
        
        bottleLabelViewCollection.backgroundColor = .clear
        self.labelView.addSubview(bottleLabelViewCollection)
        bottleLabelViewCollection.snp.makeConstraints {(make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
            make.top.equalTo(80)
        }
    }
        
}

extension PickingUpBottlesView: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickingUpBottleCell.reused, for: indexPath) as!PickingUpBottleCell
        
        //对cell进行ui设计
        cell.bottleL.text = bottleLabelText[indexPath.row]
        cell.bottleI.image = UIImage(named: bottleImage[indexPath.row])
        
        cell.layer.cornerRadius = 7
        cell.layer.masksToBounds = true
        
        cell.backgroundColor = LDColor(rgbValue: 0x213324, al: 0)
        cell.bottleL.textColor = .black
        for item in self.chooseCellList{
            if item == indexPath.row{
                cell.backgroundColor = LDColor(rgbValue: 0x111111, al: 0.25)
                cell.bottleL.textColor = .white
                break
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //1.对cell的list数组进行初始化
        for (index, item) in self.chooseCellList.enumerated(){
            if item == indexPath.row{
                self.chooseCellList.remove(at: index)
                self.bottleLabelViewCollection.reloadData()
                return
            }
        }
        self.chooseCellList.append(indexPath.row)
        //2.重新载入collection
        self.bottleLabelViewCollection.reloadData()
    }
    
}

private class PickingUpBottleCell: UICollectionViewCell {
    static let reused: String = "PickingUpBottleCellIdentify"
    let bottleL = UILabel()
    let bottleI = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bottleI)
        bottleI.snp.makeConstraints {(make) in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(cellS / 80 * 55)
        }
        self.addSubview(bottleL)
        bottleL.font = UIFont.systemFont(ofSize: (CGFloat)(cellS / 80 * 16))
        bottleL.snp.makeConstraints {(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(bottleI.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
