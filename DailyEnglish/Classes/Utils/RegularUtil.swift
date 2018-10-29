//
//  RegularUtil.swift
//  ExcellentLetter
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 gns. All rights reserved.
//

import UIKit

class RegularUtil: NSObject {
   
    class func isTelNumber(num:NSString)->Bool{
        
        if num.length != 11{
//            AppService.sharedAppService().showTip("手机号码不正确")
            return false
        }
        
        let mobile = "^1[3578]\\d{9}$"
        let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        
        if ((regextestmobile.evaluate(with: num) == true) ||
            (regextestcm.evaluate(with: num)  == true)    ||
            (regextestct.evaluate(with: num) == true)     ||
            (regextestcu.evaluate(with: num) == true)){
            
                return true
        }else{
//            AppService.sharedAppService().showTip("手机号码不正确")
            return false
        }
    }
    
    class func checkPassWord(num:NSString)->Bool {
        
//        if num.length >= 6 && num.length <= 16 {
//            return true
//        }
//        AppService.sharedAppService().showTip("密码格式错误")
        return true
        
    }
    
}
