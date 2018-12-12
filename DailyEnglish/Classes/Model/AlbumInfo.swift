//
//  AlbumInfo.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/3.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class AlbumInfo: NSObject {
    
    @objc var child:NSArray!
    @objc var classid:NSNumber!
    @objc var classname:NSString!
    @objc var classname_en:NSString!
    @objc var pic:NSString!
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["child":AlbumChildInfo.self]
    }
}

class AlbumChildInfo: NSObject {
    
    @objc var classid:NSNumber!
    @objc var classname:NSString!
    @objc var classname_en:NSString!
    @objc var pic:NSString!
}
