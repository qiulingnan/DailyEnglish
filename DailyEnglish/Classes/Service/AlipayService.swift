//
//  AlipayService.swift
//  ManPlaying
//
//  Created by 邱岭男 on 16/5/21.
//  Copyright © 2016年 邱岭男. All rights reserved.
//

import UIKit

typealias PayCallBack = (_ dict:NSDictionary)->Void

class AlipayService: NSObject {
    
    static let alipayService:AlipayService = AlipayService()
    
    var callBack:PayCallBack!
    
    class func sharedService() ->AlipayService {
        return alipayService
        
    }
    
    override init() {
        
    }
    
    func call(dict:NSDictionary){
        if(callBack != nil){
            callBack(dict)
        }
        
    }
}
