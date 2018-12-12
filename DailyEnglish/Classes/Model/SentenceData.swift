//
//  SentenceData.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/21.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class SentenceData: NSObject {
    @objc var id:NSNumber!
    @objc var title:NSString!
    @objc var mp3Url:NSString!
    @objc var lrcUrl:NSString!
    @objc var time:NSString!
    @objc var enstr:NSString!
    @objc var chstr:NSString!
    
    func initDatas(id:NSNumber,title:NSString,mp3Url:NSString,lrcUrl:NSString,time:NSString,enstr:NSString,chstr:NSString){
        self.id = id
        self.title = title
        self.mp3Url = mp3Url
        self.lrcUrl = lrcUrl
        self.time = time
        self.enstr = enstr
        self.chstr = chstr
    }
}
