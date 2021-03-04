//
//  UIBarButtonItem+GKExtension.swift
//  GKNavigationBarSwift
//
//  Created by QuintGao on 2020/3/25.
//  Copyright © 2020 QuintGao. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    public class func gk_item(title: String?,color: UIColor, target: Any, action: Selector) -> UIBarButtonItem {
        return self.gk_item(title: title, color: color, image: nil, target: target, action: action)
    }
    
    public class func gk_item(image: UIImage?,color: UIColor, target: Any, action: Selector) -> UIBarButtonItem {
        return self.gk_item(title: nil, color: color, image: image, target: target, action: action)
    }
    
    //
    public class func gk_item(title: String?,color: UIColor, image: UIImage?, target: Any, action: Selector) -> UIBarButtonItem {
        return self.gk_item(title: title, color: color, image: image, highLightImage: nil, target: target, action: action)
    }
    
    public class func gk_item(image: UIImage?,color: UIColor, highLightImage: UIImage, target: Any, action: Selector) -> UIBarButtonItem{
        return self.gk_item(title: nil, color: color, image: image, highLightImage: highLightImage, target: target, action: action)
    }
    
    //
    public class func gk_item(title: String?,color: UIColor, image: UIImage?, highLightImage: UIImage?, target: Any, action: Selector) -> UIBarButtonItem {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.setImage(image, for: .normal)
        button.setImage(highLightImage, for: .highlighted)
        button.sizeToFit()
        button.addTarget(target, action: action, for: .touchUpInside)
        if button.bounds.size.width < 44.0 {
            button.bounds = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        }
        return UIBarButtonItem(customView: button)
    }
}
