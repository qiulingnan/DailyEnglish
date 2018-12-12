//
//  DownloadData.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/2.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class DownloadData: NSObject {
    @objc var id:NSNumber!
    @objc var mp3lrc:NSString!
    @objc var mp3url:NSString!
    @objc var title:NSString!
    
    func initDatas(id:NSNumber,mp3lrc:NSString,mp3url:NSString,title:NSString){
        self.id = id
        self.mp3lrc = mp3lrc
        self.mp3url = mp3url
        self.title = title
    }
}
