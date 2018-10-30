//
//  ADInfo.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/10/30.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class ADInfo: NSObject {
    
    @objc var content:NSString!
    @objc var des:NSString!
    @objc var imgSrc:NSString!
    @objc var is_show:NSNumber!
    @objc var showTime:NSNumber!
    @objc var title:NSString!
    @objc var toUrl:NSString!
    
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["des":"description"]
    }
    
}
