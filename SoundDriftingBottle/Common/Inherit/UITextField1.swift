//
//  UITextField1.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/26.
//

import Foundation
import UIKit
class UITextField1: UITextField {
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.minX + 7, y: bounds.minY, width: bounds.width, height: bounds.height)
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.minX + 7, y: bounds.minY, width: bounds.width, height: bounds.height)
    }
}

extension UITextField1: UITextFieldDelegate {
    
}
