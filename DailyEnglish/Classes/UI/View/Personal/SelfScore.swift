//
//  SelfScore.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/11.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class SelfScore: UIView {
    
    @IBOutlet weak var icon: QLNCustonImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var daysCount: UILabel!
    @IBOutlet weak var scoreCount: UILabel!
    @IBOutlet weak var score: UILabel!
    
    func initDatas(dict:NSDictionary,year:Int,month:Int,day:Int,sc:String){
        self.daysCount.text = (dict.object(forKey: "num") as! NSNumber).stringValue
        
        self.scoreCount.text = "0"
        
        let temp = dict.object(forKey: "score")
        if !(temp is NSNull){
            self.scoreCount.text = (temp as! String)
        }
        
        
        if(day >= 10){
            
            self.time.text = "\(year)年\(month)月\(day)日"
        }else{
            self.time.text = "\(year)年\(month)月0\(day)日"
        }
        
        self.score.text = sc
        
        if(AppService.shared().iconImage != nil){
            icon.image = AppService.shared().iconImage
        }
        if(AppService.shared().nickName != nil){
            self.name.text = AppService.shared().nickName! as String
        }else{
            self.name.text = AppService.shared().userName! as String
        }
        
    }
    
    @IBAction func onShare(_ sender: Any) {
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Share")
        let share = vc.view as! Share
        share.shareType = .AudioDetails
        share.shareTitle = "我今天的成绩单"
        share._des = "我在每日英语app连续签到了\(String(describing: self.daysCount.text!))天，获得总分\(String(describing: self.scoreCount.text!))"
        share.initDatas()
        self.addSubview(share)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.removeFromSuperview()
    }
}
