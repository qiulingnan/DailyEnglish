//
//  RandomUtil.swift
//  ManPlaying
//
//  Created by 邱岭男 on 16/3/25.
//  Copyright © 2016年 邱岭男. All rights reserved.
//

import UIKit

class RandomUtil: NSObject {
    
    class func getRandom( max:Int,min:Int = 0) ->Int{
        
        return Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
    }
}
