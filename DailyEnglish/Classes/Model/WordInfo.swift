//
//  WordInfo.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/16.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit


class WordInfo: NSObject {
    
    @objc var audio:NSArray!
    @objc var english:NSArray!
    @objc var example:NSArray!
    @objc var mean:NSArray!
    @objc var phonetic:NSString!
    @objc var word:NSString!
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["english":EnglishInfo.self,"example":ExampleInfo.self]
    }

}

class EnglishInfo: NSObject {
    @objc var explain:NSString!
    @objc var title:NSString!
}

class ExampleInfo: NSObject {
    @objc var audio:NSString!
    @objc var ch:NSString!
    @objc var en:NSString!
    @objc var id:NSNumber!
}
