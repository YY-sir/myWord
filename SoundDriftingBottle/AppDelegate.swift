//
//  AppDelegate.swift
//  SoundDriftingBottle
//
//  Created by Mac on 2021/1/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //判断是否自己捞瓶子
    var isAutomatic: Bool = false
    //用户头像Url
    var userFaceImageUrl: String = ""
    //用户昵称
    var userName: String = ""
    //用户性别
    var userSex: String = "无"
    //用户生日
    var userBirthday: String = "无"
    //用户个性签名
    var userPersonalText: String = ""
    
    
    
    var window: UIWindow?
    var backgroundTask: UIBackgroundTaskIdentifier!=nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GKConfigure.setupCustom { (configure) in
            configure.titleColor = .black
            configure.titleFont = UIFont.systemFont(ofSize: 18.0)
            configure.gk_navItemLeftSpace = 4.0
            configure.gk_navItemRightSpace = 4.0
            configure.backStyle = .white
        }
        GKConfigure.awake()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootVC: ViewController())
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        
//        //如果已存在后台任务，先将其设为完成
//          if self.backgroundTask != nil {
//              application.endBackgroundTask(self.backgroundTask)
//            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
//          }
//           
//              //注册后台任务
//        self.backgroundTask = application.beginBackgroundTask(expirationHandler: {
//              () -> Void in
//              //如果没有调用endBackgroundTask，时间耗尽时应用程序将被终止
//              application.endBackgroundTask(self.backgroundTask)
//            self.backgroundTask = UIBackgroundTaskIdentifier.invalid
//        })
//        
//    }


}

