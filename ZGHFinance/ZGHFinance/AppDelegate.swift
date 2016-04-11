//
//  AppDelegate.swift
//  ZGHFinance
//
//  Created by zhangyr on 16/3/8.
//  Copyright © 2016年 cjxnfs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window      : UIWindow?
    var navi        : BaseNavigationController!
    var tabBarStack : NSArray!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        self.configSystem()
        self.configRootController()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            if let uData = Commond.getUserDefaults("userData") as? UCUserData where !UtilCheck.isLogin() {
                UCLoginViewController.autoLoginWithUserData(uData, succ: { 
                    print("自动登录成功")
                    }, failure: { 
                        print("自动登录失败")
                })
            }
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: PRIVATES
    private func configSystem()
    {
        UtilCookie.loadCookie()
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
    }
    
    private func configRootController() -> Void
    {
        let home         = HomeViewController()
        let navi_home    = BaseNavigationController(rootViewController: home)
//        let isNotFirst   = NSUserDefaults.standardUserDefaults().boolForKey("isFirst")
//        if !isNotFirst
//        {
//            let welView  = WelcomeView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), delegate : home)
//            navi_home.view.addSubview(welView)
//        }
        let finance      = FinancingViewController()
        let navi_fina    = BaseNavigationController(rootViewController: finance)
        let userCenter   = UserCenterViewController()
        let navi_user    = BaseNavigationController(rootViewController: userCenter)
        tabBarStack = [navi_home,navi_fina,navi_user]
        
        self.window?.rootViewController = tabBarStack[0] as? UIViewController
    }

}

