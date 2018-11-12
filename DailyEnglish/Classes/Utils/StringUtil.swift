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
    
    class func firstChineseVaule(str:String) -> Int {
        
        for (index, value) in str.enumerated() {
            
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return index
            }
        }
        return -1
    }
    
    //解析lrc
    class func analysisLrc() ->NSMutableArray{
        
        let path = (NSHomeDirectory() as NSString).appendingPathComponent("Documents")
        let lrcPath = (path as NSString).appendingPathComponent(lrcDownloadName)
        
        let lyc = try! String(contentsOfFile: lrcPath, encoding: String.Encoding(rawValue: UInt(bitPattern: -2147483623)))
        
        let timeArray = NSMutableArray()
        let enArray = NSMutableArray()
        let chArray = NSMutableArray()
        
        var lycArray = lyc.components(separatedBy: "\n")
        // 去掉完全没有内容的空行，数组中每个元素的内容将为“[时间]歌词”
        lycArray = lycArray.filter { $0 != "" }
        
        let number = "0123456789"
        
        // 将歌词以对应的时间为Key放入字典
        for j in 0 ..< lycArray.count {
            // 用“]”分割字符串，可能含有多个时间对应个一句歌词的现象,并且歌词可能为空,例如：“[00:12.34][01:56.78]”，这样分割后的数组为：["[00:12.34", "[01:56.78", ""]
            var arrContentLRC = lycArray[j].components(separatedBy: "]")
            
            // 这里处理非歌词行，例如"[ti:","[ar:"，判断数组中每个元素的第二个字符是不是数字,如果是数字，则这一行是要显示的歌词，进入循环
            // number:定义的字符串“0123456789”，辅助判断字符是否为数字
            if(number.components(separatedBy: (arrContentLRC[0] as NSString).substring(with: NSMakeRange(1, 1))).count > 1) {
                
                // 最后一个元素是歌词，不用处理
                // 如果有多个时间对应一个歌词，每个时间处理一次
                for k in 0..<(arrContentLRC.count - 1) {
                    // 将元素内容中的“[”去掉
                    if arrContentLRC[k].contains("[") {
                        arrContentLRC[k] = (arrContentLRC[k] as NSString).substring(from: 1)
                    }
                }
                timeArray.add(arrContentLRC[0])
                
                let tempStr = arrContentLRC[arrContentLRC.count - 1] as NSString
                let index = firstChineseVaule(str: tempStr as String)
                
                if(index != -1){
                    let enStr = tempStr.substring(with: NSMakeRange(0, index))
                    let chStr = tempStr.substring(with: NSMakeRange(index, tempStr.length-index))
                    enArray.add(enStr)
                    chArray.add(chStr)
                }else{
                    enArray.add("")
                    chArray.add(tempStr)
                }
                
            }
        }
        
        let tempArr = NSMutableArray()
        tempArr.add(timeArray)
        tempArr.add(enArray)
        tempArr.add(chArray)
        
        return tempArr
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
        
    var md5: String {
        let str = cString(using: .utf8)
        let strLen = CC_LONG(lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
            
        CC_MD5(str!, strLen, result)
            
        var hash = ""
        for i in 0..<digestLen {
            hash = hash.appendingFormat("%02x", result[i])
        }
        
        result.deallocate()
//        result.deallocate(capacity: digestLen)
        
        return hash
    }
}

