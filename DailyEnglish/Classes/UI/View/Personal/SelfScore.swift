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
        
        self.scoreCount.text = (dict.object(forKey: "score") as! String)
        
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
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.removeFromSuperview()
    }
}
