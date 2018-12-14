//
//  OrderInfo.swift
//  ManPlaying
//
//  Created by 邱岭男 on 16/5/15.
//  Copyright © 2016年 邱岭男. All rights reserved.
//

import UIKit

class PayInfo: NSObject {
    
    //支付宝字段
    @objc var alipay:NSString!
    //微信字段
    @objc var appid:NSString!
    @objc var nonce_str:NSString!
    @objc var package:NSString = "Sign=WXPay"
    @objc var partnerid:NSString!
    @objc var prepay_id:NSString!
    @objc var timestamp:NSNumber!
    @objc var sign:NSString!
}
