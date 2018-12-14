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
    var mainTabbar:MainTabBar!
    
    var personal:PersonalCenter!
    
    var nickName:NSString!
    var iconImage:UIImage!
    
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
    
    var collectDatas:NSMutableArray! //收藏数据
    var sentenceDatas:NSMutableArray! //例句数据
    var wordDatas:NSMutableArray! //单词数据
    var downloadDatas:NSMutableArray! //下载数据
    var subscriptionDatas:NSMutableArray!//订阅
    var signDatas:NSMutableArray!//签到
    var searchDatas:NSMutableArray!//搜索
   
    var audio:AVAudioPlayer!
    
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
    
    func checkBookDownLoad() -> Bool {
        
        return false
    }
    
    
    var palyAudioId:NSNumber!
    var palyAudioTitle:String!
    
    var palyAudioMp3Url:String!
    var palyAudioMp3lrcUrl:String!
    
    var playAudio:PlayAudio!
    //记录当前正在播放的额audio信息
    func recordPlayAudio(audio:AVAudioPlayer,palyAudioId:NSNumber,palyAudioTitle:String,palyAudioMp3Url:String,palyAudioMp3lrcUrl:String){
        self.audio = audio
        self.palyAudioId = palyAudioId
        self.palyAudioTitle = palyAudioTitle
        self.palyAudioMp3Url = palyAudioMp3Url
        self.palyAudioMp3lrcUrl = palyAudioMp3lrcUrl
        
        playAudio = PlayAudio(frame: CGRect(x: 0, y: screenSize.height - self.mainTabbar.tabBar.frame.size.height - 30, width: screenSize.width, height: 30))
        
        self.mainTabbar.view.addSubview(playAudio)
    }
    
    //搜索
    
    func loadSearchDatas(){
        if(UserDefaults.standard.array(forKey: search_Datas) != nil){
            self.searchDatas = NSMutableArray(array: (UserDefaults.standard.array(forKey: search_Datas)!))
            
        }else{
            self.searchDatas = NSMutableArray()
        }
        
    }
    
    func removeSearch(index:Int){
        self.searchDatas.removeObject(at: index)
        self.saveSearchDatas()
    }
    
    func removeAllSearch(){
        
        self.searchDatas.removeAllObjects()
        self.saveSearchDatas()
    }
    
    func saveSearchDatas(){
        UserDefaults.standard.set(self.searchDatas, forKey: search_Datas)
    }
    
    func findSearch(data:String) ->Bool{
        
        for item in self.searchDatas {
            if((item as! String) == data){
                return true
            }
        }
        
        return false
    }
    
    func addSearchData(data:String){
        
        if(!findSearch(data: data)){
            self.searchDatas!.add(data)
            
            self.saveSearchDatas()
        }
        
    }
    
    //签到
    func loadSignInDatas(){
        let str = UserDefaults.standard.string(forKey: signIn_Datas)
        
        self.signDatas = EvaluationData.mj_objectArray(withKeyValuesArray: str)
        
        if(self.signDatas == nil){
            self.signDatas = NSMutableArray()
        }
    }
    
    func addSignIn(data:EvaluationData){
        
        let tempData = findSignIn(data: data)
        
        if(tempData == nil){
            self.signDatas.add(data)
        }else{
            tempData?.resetData(data: data)
        }
        
        self.saveSignInDatas()
    }
    
    func findSignIn(data:EvaluationData) -> EvaluationData?{
        
        for item in self.signDatas {
            if(data.date.isEqual(to: (item as! EvaluationData).date as String)){
                return (item as! EvaluationData)
            }
        }
        return nil
    }
    
    func findSignIn(dateStr:String) -> EvaluationData?{
        
        for item in self.signDatas {
            if((item as! EvaluationData).date.isEqual(to: dateStr)){
                return (item as! EvaluationData)
            }
        }
        return nil
    }
    
    func saveSignInDatas(){
        let tempArr = NSMutableArray()
        for item in self.signDatas {
            tempArr.add((item as! EvaluationData).mj_JSONString())
        }
        
        UserDefaults.standard.set(tempArr.mj_JSONString(), forKey: signIn_Datas)
    }
    
    //订阅
    func addSubscription(data:HomeNewsContentInfo){
        
        if(findSubscriptionData(data: data)){
            return
        }
        
        self.subscriptionDatas.add(data)
        
        self.saveSubscriptionDatas()
    }
    
    func saveSubscriptionDatas(){
        let tempArr = NSMutableArray()
        for item in self.subscriptionDatas {
            tempArr.add((item as! HomeNewsContentInfo).mj_JSONString())
        }
        
        UserDefaults.standard.set(tempArr.mj_JSONString(), forKey: subscription_datas)
    }
    
    func loadSubscriptionDatas(){
        
        let str = UserDefaults.standard.string(forKey: subscription_datas)
        
        self.subscriptionDatas = HomeNewsContentInfo.mj_objectArray(withKeyValuesArray: str)
        
        if(self.subscriptionDatas == nil){
            self.subscriptionDatas = NSMutableArray()
        }
    }
    
    func findSubscriptionData(data:HomeNewsContentInfo) -> Bool{
        
        for item in self.subscriptionDatas {
            if(data.name.isEqual(to: (item as! HomeNewsContentInfo).name as String)){
                return true
            }
        }
        return false
    }
    
    func removeSubscription(data:HomeNewsContentInfo){
        
        for item in self.subscriptionDatas {
            if(data.name.isEqual(to: (item as! HomeNewsContentInfo).name as String)){
                self.subscriptionDatas.remove(item)
                break
            }
        }
        self.saveSubscriptionDatas()
    }
    
    //下载
    func addDownload(data:DownloadData){
        
        if(findDownloadData(data: data)){
            return
        }
        
        self.downloadDatas.add(data)
        
        self.saveDownloadDatas()
    }
    
    func saveDownloadDatas(){
        let tempArr = NSMutableArray()
        for item in self.downloadDatas {
            tempArr.add((item as! DownloadData).mj_JSONString())
        }
        
        UserDefaults.standard.set(tempArr.mj_JSONString(), forKey: download_datas)
    }
    
    func loadDownloadDatas(){
        
        let str = UserDefaults.standard.string(forKey: download_datas)
        
        self.downloadDatas = DownloadData.mj_objectArray(withKeyValuesArray: str)
        
        if(self.downloadDatas == nil){
            self.downloadDatas = NSMutableArray()
        }
    }
    
    func findDownloadData(data:DownloadData) -> Bool{
        
        for item in self.downloadDatas {
            if(data.id == (item as! DownloadData).id){
                return true
            }
        }
        return false
    }
    
    func removeDownload(index:Int){
        self.downloadDatas.removeObject(at: index)
        
        self.saveDownloadDatas()
    }
    
    //收藏
    func addCollect(data:CollectData){
        
        self.collectDatas.add(data)
        
        self.saveCollectDatas()
    }
    
    func saveCollectDatas(){
        let tempArr = NSMutableArray()
        for item in self.collectDatas {
            tempArr.add((item as! CollectData).mj_JSONString())
        }
        
        UserDefaults.standard.set(tempArr.mj_JSONString(), forKey: collect_datas)
    }
    
    func loadCollectDatas(){
        
        let str = UserDefaults.standard.string(forKey: collect_datas)
        
        self.collectDatas = CollectData.mj_objectArray(withKeyValuesArray: str)
        
        if(self.collectDatas == nil){
            self.collectDatas = NSMutableArray()
        }
    }
    
    func removeCollect(data:CollectData){
        
        for item in self.collectDatas {
            if(data.id == (item as! CollectData).id){
                self.collectDatas.remove(item)
                break
            }
        }
        self.saveCollectDatas()
    }
    
    func removeCollect(index:Int){
        self.collectDatas.removeObject(at: index)
        
        self.saveCollectDatas()
    }
    
    func findCollectData(data:CollectData) -> Bool{
        
        for item in self.collectDatas {
            if(data.id == (item as! CollectData).id){
                return true
            }
        }
        return false
    }
    
    //例句
    func addSentence(data:SentenceData){
        
        if(!self.findSentenceData(data: data)){
            self.sentenceDatas.add(data)
            
            self.saveSentenceDatas()
        }
        
    }
    
    func saveSentenceDatas(){
        let tempArr = NSMutableArray()
        for item in self.sentenceDatas {
            tempArr.add((item as! SentenceData).mj_JSONString())
        }
        
        UserDefaults.standard.set(tempArr.mj_JSONString(), forKey: sentence_datas)
    }
    
    func loadSentenceDatas(){
        
        let str = UserDefaults.standard.string(forKey: sentence_datas)
        
        self.sentenceDatas = SentenceData.mj_objectArray(withKeyValuesArray: str)
        
        if(self.sentenceDatas == nil){
            self.sentenceDatas = NSMutableArray()
        }
    }
    
    func removeSentence(data:SentenceData){
        
        for item in self.sentenceDatas {
            if(data.enstr.isEqual(to: (item as! SentenceData).enstr as String)){
                self.sentenceDatas.remove(item)
                break
            }
        }
        self.saveSentenceDatas()
    }
    
    func removeSentence(index:Int){
        self.sentenceDatas.removeObject(at: index)
        
        self.saveSentenceDatas()
    }
    
    func findSentenceData(data:SentenceData) -> Bool{
        
        for item in self.sentenceDatas {
            if(data.chstr.isEqual(to: (item as! SentenceData).chstr as String)){
                return true
            }
        }
        return false
    }
    
    //单词
    func addWord(data:WordData){
        
        if(!self.findWordData(data: data)){
            self.wordDatas.add(data)
            
            self.saveWordDatas()
        }
        
    }
    
    func saveWordDatas(){
        let tempArr = NSMutableArray()
        for item in self.wordDatas {
            tempArr.add((item as! WordData).mj_JSONString())
        }
        
        UserDefaults.standard.set(tempArr.mj_JSONString(), forKey: word_datas)
    }
    
    func loadWordDatas(){
        
        let str = UserDefaults.standard.string(forKey: word_datas)
        
        self.wordDatas = WordData.mj_objectArray(withKeyValuesArray: str)
        
        if(self.wordDatas == nil){
            self.wordDatas = NSMutableArray()
        }
    }
    
    func removeWord(data:WordData){
        
        for item in self.wordDatas {
            if(data.word.isEqual(to: (item as! WordData).word as String)){
                self.wordDatas.remove(item)
                break
            }
        }
        self.saveWordDatas()
    }
    
    func removeWord(index:Int){
        self.wordDatas.removeObject(at: index)
        
        self.saveWordDatas()
    }
    
    func findWordData(data:WordData) -> Bool{
        
        for item in self.wordDatas {
            if(data.word.isEqual(to: (item as! WordData).word as String)){
                return true
            }
        }
        return false
    }
    
    func loadLocalData(){
        self.loadUserData()
        self.loadSettingData()
        self.loadCollectDatas()
        self.loadSentenceDatas()
        self.loadWordDatas()
        self.loadDownloadDatas()
        self.loadSubscriptionDatas()
        self.loadSignInDatas()
        self.loadSearchDatas()
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
