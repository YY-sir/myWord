//
//  MCVolumeView.swift
//  MCChatHUD
//
//  Created by duwei on 2018/1/30.
//  Copyright © 2018年 Dywane. All rights reserved.
//

import UIKit
/// HUD类型
///
/// - bar: 条状
/// - stroke: 线状
enum HUDType: Int {
    case bar = 0
    case line
}

class MCVolumeView: UIView {
    //MARK: Private Properties
    /// 声音表数组
    private var soundMeters: [Float]!
    

    
    private var type: HUDType = .bar
    
    //MARK: Init
    convenience init(frame: CGRect, type: HUDType) {
        self.init(frame: frame)
        self.type = type
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentMode = .redraw   //内容模式为重绘，因为需要多次重复绘制音量表
        NotificationCenter.default.addObserver(self, selector: #selector(updateView(notice:)), name: NSNotification.Name.init("updateMeters"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if soundMeters != nil && soundMeters.count > 0 {
            let context = UIGraphicsGetCurrentContext()
            context?.setLineCap(.round)
            context?.setLineJoin(.round)
            context?.setStrokeColor(UIColor.white.cgColor)
            
            let noVoice = -40.0     // 该值代表低于-46.0的声音都认为无声音
            let maxVolume = 45.0    // 该值代表最高声音为55.0
            let columnW = columnWidth
            
            switch type {
            case .bar:
                context?.setLineWidth(columnW)
                for (index,item) in soundMeters.enumerated() {
                    let barHeight = (Double(columnH) - (Double(item) + 42) / (45 + 40) * Double(columnH) - 100 * Double(scaleMaxV)) * 1.2
                    context?.move(to: CGPoint(x: (CGFloat(index * 2) * columnW + columnW), y: CGFloat(columnH / 2)))
                    context?.addLine(to: CGPoint(x: (CGFloat(index * 2) * columnW + columnW), y: CGFloat(1 * barHeight)))
                }
            case .line:
                context?.setLineWidth(1.5)
                for (index, item) in soundMeters.enumerated() {
                    let position = (Double(columnH) - (Double(item) + 40) / (45 + 40) * Double(columnH) - 100 * Double(scaleMinV)) * 1.2
                    //计算对应线段高度
                    print("position1\(position)")
                    context?.addLine(to: CGPoint(x: Double(CGFloat(index * 2) * columnW + columnW), y: position))
                    print("position2\(position)")
                    context?.move(to: CGPoint(x: Double(CGFloat(index * 2) * columnW + columnW), y: position))
                }
            }
            context?.strokePath()
        }
    }
    
    @objc private func updateView(notice: Notification) {
        soundMeters = notice.object as! [Float]
        setNeedsDisplay()
    }

}
