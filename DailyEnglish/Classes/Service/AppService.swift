//
//  AppService.swift
//  ExcellentLetter2
//
//  Created by apple on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

import UIKit
import Toast

class AppService: NSObject{
    
    static let appService:AppService = AppService()
    
    var navigate:UINavigationController!
   
//    let verssion = "1.2.9"
    
//    let verssionStr:NSString = "129"
    
    
    class func shared() ->AppService {
        return appService
        
    }
    
    override init() {
        
    }
    
    func showTip(tip:String, position:String = CSToastPositionBottom,duration:TimeInterval = 2.0){
        
        if navigate != nil {
            navigate.view.makeToast(tip, duration: duration, position: position)
        }
        
    }
    
//    func checkLogin()-> Bool{
//
//        if(!isLogin){
//
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            let login:UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Login")
//            navigate.pushViewController(login, animated: true)
//
//            return false
//        }
//        return true
//    }
    
    
//    func clearImageCach(){
//        SDImageCache.sharedImageCache().clearDisk()
//    }
    
}
