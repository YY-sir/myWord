//
//  UISlider1.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/2/4.
//

import UIKit

class UISlider2: UISlider {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        var trect = rect
         trect.origin.x -= 10
         trect.size.width += 20
        trect.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
         return super.thumbRect(forBounds: bounds, trackRect: trect, value: value)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let newBounds = CGRect.init(origin: CGPoint(x: 5, y: bounds.size.height / 3), size: CGSize(width: bounds.size.width - 10, height: bounds.size.height / 7))
        return newBounds
        
//        return CGRect(x: 0, y: 0, width: bounds.width - 20, height: 5)
    }
    
}
