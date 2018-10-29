//
//  StringUtil.swift
//  ExcellentLetter
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 gns. All rights reserved.
//

import UIKit

class StringUtil: NSObject {
    
    
    class func isNumber(str:NSString) ->Bool{
     
        for i in 0 ..< str.length {
            let s = String(str.character(at: i))
            
            if(( s >= "0" && s <= "9" ) || s == "."){
                continue
            }else{
                return false
            }
        }
        
        return true
    }
    
    
    
    /**
     数字转K
     
     - parameter number: <#number description#>
     
     - returns: <#return value description#>
     */
    class func numberToUnits(number:NSNumber) ->String {
        
        let n = number.floatValue
        
        var str:String = "\(number.intValue)"
        
        if(n > 10000){
            str = String(format: "%.2dK", n / 1000.0)
        }
        
        
        return str
    }
    
    /**
        将字符串转变成*
        - str: 需要变化的字符串
        - headNum: 头部不需要改变的个数
        - lastNum: 尾部不需要改变的个数
     */
    class func stringToHide(str:NSString,headNum:Int = 0,lastNum:Int = 0) -> String{
        
        if(str.length < headNum + lastNum){
            
            var newStr = ""
            
            for _ in 0 ..< str.length {
                
                newStr += "*"
            }
            
            return newStr
        }
        
        var newStr = ""
        
        for i in 0 ..< str.length {
            
            if(i >= headNum && i < str.length - lastNum){
                newStr += "*"
            }else{
                
                let range = str.rangeOfComposedCharacterSequence(at: i)
                let s = str.substring(with: range)
                newStr += s
            }
        }
        return newStr
    }
    
}

extension String {
    /**
     查找某个字符在字符串中最后的位置
     
     - parameter str: <#str description#>
     
     - returns: <#return value description#>
 
    func lastIndexOf(c:unichar) ->Int{
        
        let str = self as NSString
        
        
        
        for var i = str.length-1;i>=0;i -= 1 {
            
            let s = str.characterAtIndex(i)
            
            if(s == c){
                return i
            }
        }
        
        return -1
    }*/
}

