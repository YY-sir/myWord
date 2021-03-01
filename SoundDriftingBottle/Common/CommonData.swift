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

//Mine
let kStatusBar_Height: CGFloat = GKConfigure.gk_statusBarFrame().size.height
let kNavBar_Height: CGFloat = kStatusBar_Height + 44.0

let ADAPTATIONRATIO = kScreenW / 750.0

//音频波形图
let columnNumber = 50
let columnWidth = (kScreenW / 50) / 2
let noVoice = -46.0     // 该值代表低于-46.0的声音都认为无声音
let maxVolume = 55.0    // 该值代表最高声音为55.0

