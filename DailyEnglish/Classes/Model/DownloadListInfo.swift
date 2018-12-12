//
//  DownloadListInfo.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/4.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class DownloadListInfo: NSObject {
    @objc var content:NSArray!
    @objc var pages:NSArray!
    @objc var thisPage:NSNumber!
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["content":DownloadInfo.self,"pages":NSString.self]
    }
}

class DownloadInfo: NSObject {
    
    @objc var classid:NSNumber!
    @objc var classname:NSString!
    @objc var ctime:NSNumber!
    @objc var id:NSNumber!
    @objc var lrc_content:NSString!
    @objc var mp3lrc:NSString!
    @objc var mp3url:NSString!
    @objc var onclick:NSNumber!
    @objc var pclassname:NSString!
    @objc var pic:NSString!
    @objc var small_text:NSString!
    @objc var title:NSString!
    @objc var username:NSString!
    
    var isSelect = false
}

