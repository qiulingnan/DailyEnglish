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
    
    var personal:PersonalCenter!
    
    var isLogin = false
    
    let netConfig = EasyLoadingConfig()
    
    let appid = "xiaoe"
    
    var userName:String!
    var passWorld:String!
    var uid:String!
    
    var isDefinnition = false//长按单词显示释义
    var isAutoplay = false//进入界面自动播放
    var isDividing = false//内容界面显示分割线
    var isLongBright = false//保持屏幕长亮
   
    class func shared() ->AppService {
        return appService
        
    }
    
    override init() {
        netConfig.tintColor = netColor
        netConfig.superReceiveEvent = false
        
    }
    
    func checkLogin() -> Bool{
        
        if(!isLogin){
            let sb = UIStoryboard(name:"Login", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "login")
            self.navigate.pushViewController(vc, animated: true)
        }
        
        return isLogin
    }
    
    func showTip(tip:String, position:String = CSToastPositionBottom,duration:TimeInterval = 2.0){
        
        if navigate != nil {
            navigate.view.makeToast(tip, duration: duration, position: position)
        }
        
    }
    
    func loadLocalData(){
        self.loadUserData()
        self.loadSettingData()
    }
    
    func loadSettingData(){
        self.isDefinnition = UserDefaults.standard.bool(forKey: definnition_str)
        self.isAutoplay = UserDefaults.standard.bool(forKey: autoplay_str)
        self.isDividing = UserDefaults.standard.bool(forKey: dividing_str)
        self.isLongBright = UserDefaults.standard.bool(forKey: longBright_str)
        
        //设置设备是否保持常亮
        UIApplication.shared.isIdleTimerDisabled = self.isLongBright
    }
    
    //保存用户的账号密码到本地
    func saveUserData(userName:String,passWorld:String){
        
        self.userName = userName
        self.passWorld = passWorld
        
        UserDefaults.standard.setValue(userName, forKey: user_name)
        UserDefaults.standard.setValue(passWorld, forKey: pass_world)
    }
    
    func loadUserData(){
        
        self.userName = UserDefaults.standard.string(forKey: user_name)
        self.passWorld = UserDefaults.standard.string(forKey: pass_world)
        
        autoLogin()
    }
    
    //自动登录
    func autoLogin(){
        
        if(self.userName != nil && self.userName != ""){
            let parameters = ["uname":self.userName!,"pwd":self.passWorld,"appid":self.appid] as [String : Any]
            
            HttpService.shared().post(urlLast: "user/login", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
                
                AppService.shared().isLogin = true
                
                let dict:NSDictionary = obj as! NSDictionary
                
                self.uid = dict.object(forKey: "uid")! as? String
                
                if(self.personal != nil){
                    self.personal.loadNikeName()
                }
                
            }) { (task:URLSessionDataTask?, error:NSError?) in
                
                AppService.shared().showTip(tip: "登陆失败")
            }
        }
    }
    
    //退出登录
    func exitLogin(){
        
        self.isLogin = false
        self.saveUserData(userName: "", passWorld: "")
        AppService.shared().showTip(tip: "退出登录成功")
    }
    
//    func clearImageCach(){
//        SDImageCache.sharedImageCache().clearDisk()
//    }
    
}
