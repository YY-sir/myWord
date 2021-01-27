//
//  CommonOne.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/26.
//

import Foundation
import Foundation
import UIKit
class CommonOne: NSObject {
    //safeArea上下外边距
    var window: UIWindow!
    var topPadding: CGFloat!
    var bottomPadding: CGFloat!

    //渐变颜色layer
    let gradientLayer = CAGradientLayer()
        
    override init() {
        super.init()
        window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        topPadding = window.safeAreaInsets.top
        bottomPadding = window.safeAreaInsets.bottom
        setupBgColor()
    }
    
    //16进制颜色的使用
    @objc func LDColor(rgbValue:UInt, al:Float) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0xFF) / 255.0, alpha: CGFloat(al))

    }
    
    //渐变颜色layer
    fileprivate func setupBgColor(){
        gradientLayer.colors = [UIColor(displayP3Red: 0.235, green: 0.827, blue: 0.678, alpha: 1).cgColor,UIColor(displayP3Red: 0.298, green: 0.752, blue: 0.789, alpha: 1).cgColor]
        gradientLayer.locations = [0.3, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        gradientLayer.frame = window.bounds
    }
    
}

