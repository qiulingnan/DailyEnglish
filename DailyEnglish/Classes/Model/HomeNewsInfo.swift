//
//  HomeNewsInfo.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/7.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class HomeNewsInfo: NSObject {

    @objc var name:NSString!
    @objc var content:NSArray!
    
   override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["content":HomeNewsContentInfo.self]
    }
    
}

class HomeNewsContentInfo: NSObject {
    
    @objc var addtime:NSString!
    @objc var cid:NSNumber!
    @objc var intro:NSString!
    @objc var name:NSString!
    @objc var onclick:NSString!
    @objc var par:NSString!
    @objc var pic:NSString!
    
    
    @objc var subscriptionTime:NSString!
}
