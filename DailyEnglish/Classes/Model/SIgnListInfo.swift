//
//  SIgnListInfo.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/10.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class SIgnListInfo: NSObject {
    @objc var appid:NSString!
    @objc var audio:NSString!
    @objc var checked:NSNumber!
    @objc var comment:NSNumber!
    @objc var created_at:NSString!
    @objc var duration:NSNumber!
    @objc var id:NSNumber!
    @objc var is_admire:NSNumber!
    @objc var is_show:NSNumber!
    @objc var score:NSNumber!
    @objc var sentence_id:NSNumber!
    @objc var uid:NSNumber!
    @objc var userinfo:UserInfo!
    
    var isStar = false
}

class UserInfo: NSObject {
    @objc var nick:NSString!
}
