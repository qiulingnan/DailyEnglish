//
//  WordData.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/21.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class WordData: NSObject {

    @objc var audio:NSString!
    @objc var phonetic:NSString!
    @objc var word:NSString!
    @objc var mean:NSString!
    @objc var time:NSString!
    
    func initDatas(audio:NSString,phonetic:NSString,word:NSString,mean:NSString,time:NSString){
        self.audio = audio
        self.phonetic = phonetic
        self.word = word
        self.mean = mean
        self.time = time
    }
}
