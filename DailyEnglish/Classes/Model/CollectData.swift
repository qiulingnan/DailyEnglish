//
//  CollectData.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/20.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class CollectData: NSObject {
    @objc var id:NSNumber!
    @objc var title:NSString!
    @objc var mp3Url:NSString!
    @objc var lrcUrl:NSString!
    @objc var time:NSString!
    
    func initDatas(id:NSNumber,title:NSString,mp3Url:NSString,lrcUrl:NSString,time:NSString){
        self.id = id
        self.title = title
        self.mp3Url = mp3Url
        self.lrcUrl = lrcUrl
        self.time = time
    }
}
