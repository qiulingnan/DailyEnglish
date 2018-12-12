//
//  Evaluation.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/10.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class EvaluationWord :NSObject {
    
    @objc var content:NSString!
    @objc var total_score:NSString!
}

class Evaluation: NSObject {
    
    @objc var content:NSString!
    @objc var total_score:NSString!
    @objc var word_count:NSString!
    @objc var word:NSArray!
    
    override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return ["word":EvaluationWord.self]
    }
}

class EvaluationData :NSObject {
    
    @objc var total_score:NSString!
    @objc var date:NSString!
    @objc var isSignIn:NSNumber!
    
    func initData(total_score:NSString,date:NSString){
        self.total_score = total_score
        self.date = date
        isSignIn = 0
    }
    
    func resetData(data:EvaluationData){
        self.total_score = data.total_score
        self.date = data.date
        self.isSignIn = data.isSignIn
    }
    
}
