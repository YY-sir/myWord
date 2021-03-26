//
//  UIView.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/3/26.
//


import UIKit

extension UIView {
    
    /**
     把View的背景设置为毛玻璃效果
     */
    @objc func hc_setBackgroupViewBlur(_ alpha: CGFloat = 1.0) {
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .dark)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = alpha
        self.insertSubview(blurView, at: 0)
        
        blurView.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
    }

    @objc func hc_setBackgroupViewBlur(alpha: CGFloat = 1.0, style:UIBlurEffect.Style) {
        self.hc_removeBackgroupViewBlur()
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: style)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.tintColor = .clear
        blurView.alpha = alpha
        blurView.isUserInteractionEnabled = false
        self.insertSubview(blurView, at: 0)
        
        blurView.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
    }
    
    @objc func hc_removeBackgroupViewBlur() {
        if let subView = subviews.first as? UIVisualEffectView {
            subView.removeFromSuperview()
        }
    }
    
    @objc func hc_setGradualChangeViewBlur(alpha: CGFloat = 1.0, style:UIBlurEffect.Style){
        self.hc_removeBackgroupViewBlur()
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: style)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.tintColor = .clear
        blurView.alpha = alpha
        blurView.isUserInteractionEnabled = false
        self.insertSubview(blurView, at: 0)
        blurView.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        blurView.layer.insertSublayer(gradient, at: 0)
    }
}
