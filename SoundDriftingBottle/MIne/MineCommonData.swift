//
//  MineCommonData.swift
//  SoundDriftingBottle
//
//  Created by YY on 2021/2/20.
//

import UIKit

let isIPhoneX: Bool = GKConfigure.gk_isNotchedScreen()

let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height

let kStatusBar_Height: CGFloat = GKConfigure.gk_statusBarFrame().size.height
let kNavBar_Height: CGFloat = kStatusBar_Height + 44.0

let ADAPTATIONRATIO = kScreenW / 750.0
