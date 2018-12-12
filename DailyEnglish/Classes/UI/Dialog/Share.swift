//
//  Share.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/19.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class Share: UIView {

    @IBOutlet weak var bottomView: UIView!
    
    func initDatas(){
        bottomView.frame.origin.y = screenSize.height
        UIView.animate(withDuration: 0.5) {
            self.bottomView.frame.origin.y = screenSize.height - 190
        }
        
    }
    
    func removed(){
        bottomView.frame.origin.y = screenSize.height - 190
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.frame.origin.y = screenSize.height
        }) { (complete:Bool) in
             self.removeFromSuperview()
        }
       
    }
    
    @IBAction func onWechat(_ sender: Any) {
        
    }
    
    @IBAction func onWechatFriend(_ sender: Any) {
        
    }
    
    @IBAction func onQQ(_ sender: Any) {
    }
    
    @IBAction func onSina(_ sender: Any) {
        
    }
    
    @IBAction func onQQZone(_ sender: Any) {
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.removed()
    }
}
