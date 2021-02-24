//
//  CommonOne.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/26.
//

import Foundation
import UIKit

extension UIColor {
    public class func rgbaColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    public class func rgbColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor.rgbaColor(r: r, g: g, b: b, a: 1.0)
    }
    
    public class func grayColor(g: CGFloat) -> UIColor {
        return UIColor.rgbColor(r: g, g: g, b: g)
    }
}

public func changeColor(image: UIImage, color: UIColor) -> UIImage {
    UIGraphicsBeginImageContext(image.size)
    color.setFill()
    let bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    UIRectFill(bounds)
    image.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resultImage!
}

//16进制颜色的使用
public func LDColor(rgbValue:UInt, al:Float) -> UIColor {
    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0xFF) / 255.0, alpha: CGFloat(al))

}

//将整数转为时间格式字符串
public func changeTime(time: Int) -> (String){
    let dateformmter = DateFormatter()
    dateformmter.dateStyle = .medium
    dateformmter.timeStyle = .short
    dateformmter.dateFormat = "m:ss"
    let confromTimesp = Date.init(timeIntervalSince1970: TimeInterval(time))
    let changeTime = dateformmter.string(from: confromTimesp)
    return changeTime
}
//拼接时间字符串
public func addTimeL(currentT: Int, totalT: Int) -> String{
    var timeL: String!
    timeL = changeTime(time: currentT) + "/" + changeTime(time: totalT)
    return timeL
}

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
    
    //渐变颜色layer
    fileprivate func setupBgColor(){
        gradientLayer.colors = [UIColor(displayP3Red: 0.235, green: 0.827, blue: 0.678, alpha: 1).cgColor,UIColor(displayP3Red: 0.298, green: 0.752, blue: 0.789, alpha: 1).cgColor]
        gradientLayer.locations = [0.3, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        gradientLayer.frame = window.bounds
    }
    
}
