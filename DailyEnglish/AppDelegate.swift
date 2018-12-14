//
//  AppDelegate.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/10/29.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        ImageUtil.createFolderInDocuments(path: "SignAudio")
        //开启网络监听
        HttpService.shared().startNetMonitor()
        
        AppService.shared().loadLocalData()
        
        // 注册后台播放
        AudioSet.setAudiu()
        
        //注册讯飞
        IFlySetting.setLogFile(.LVL_LOW)
        IFlySetting.showLogcat(false)
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cachePath = (paths as NSArray).object(at: 0)
        IFlySetting.setLogFilePath((cachePath as! String))
        
        let initString = "appid=5c0cb175"
        IFlySpeechUtility.createUtility(initString)
        
        WXApi.registerApp("wx2fc8b1646b763805")
        _ = TencentOAuth.init(appId: "101050713", andDelegate: nil)
        
        WeiboSDK.registerApp(weiboAppKey)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        if (url.scheme == "wx2fc8b1646b763805") {
            return WXApi.handleOpen(url, delegate: self)
        }
        
        if (url.scheme == "tencent101050713") {
            
            QQApiInterface.handleOpen(url, delegate: nil)
            
            if(TencentOAuth.canHandleOpen(url)){
                return TencentOAuth.handleOpen(url)
            }
            
        }
        
        if (url.scheme == "wb1158443048") {
            return WeiboSDK.handleOpen(url, delegate: self)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if(url.host == "safepay"){
            AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: { (dict : [AnyHashable : Any]?) in
                AlipayService.sharedService().call(dict: dict! as NSDictionary)
            })
        }
        
        if(url.host == "platformapi"){
            
            AlipaySDK.defaultService()?.processAuthResult(url, standbyCallback: { (dict : [AnyHashable : Any]?) in
                AlipayService.sharedService().call(dict: dict! as NSDictionary)
            })
        }
        
        if (url.scheme == "wb1158443048") {
            return WeiboSDK.handleOpen(url, delegate: self)
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if (url.scheme == "wx2fc8b1646b763805") {
            return WXApi.handleOpen(url, delegate: self)
        }
        
        if (url.scheme == "wb1158443048") {
            return WeiboSDK.handleOpen(url, delegate: self)
        }
        
        return true
    }


}

extension AppDelegate: WeiboSDKDelegate {
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
       
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        
    }
    
}

extension AppDelegate: WXApiDelegate {
    
    func onResp(_ resp: BaseResp!) {
        
        if(resp is PayResp){
            let response = resp as! PayResp
            if(response.errCode == 0){
                AlipayService.sharedService().call(dict: [:])
            }
        }
    }
    
}

