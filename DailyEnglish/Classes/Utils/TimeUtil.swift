//
//  TimeUtil.swift
//  ExcellentLetter
//
//  Created by apple on 15/7/30.
//  Copyright (c) 2015年 gns. All rights reserved.
//

import UIKit

class TimeUtil: NSObject {
    
    
    class func currentTime()->Double {
        return NSDate().timeIntervalSince1970
    }
    
    class func currentTimeMillis()->Double {
        return NSDate().timeIntervalSince1970*1000
    }
    
    class func timeToData(time:Double)->NSDate {
        
        let date:NSDate = NSDate(timeIntervalSince1970: time)
        
        return date
    }
    
    class func stringFromDate(date:NSDate) ->String{
        
            
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let destDateString = dateFormatter.string(from: date as Date)
        
        return destDateString
        
    }
    
    class func dateToTime(str:String) ->TimeInterval {
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.short
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        formatter.timeZone = NSTimeZone(name: "Asia/Shanghai")! as TimeZone
        
        let date:NSDate = formatter.date(from: str)! as NSDate
        return date.timeIntervalSince1970
    }
    
    /**
     获取当前的年月日   NSDateComponents
     */
//    class func currentData() -> NSDateComponents{
//        //获取当前时间
//        let now = NSDate()
//        let calendar = NSCalendar.current
//        let unitFlags:NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute]
//
//        return calendar.dateComponents(in: unitFlags, from: now)
//    }
    
//    class func currentWeek() -> Int{
//
//        let weekDays = [7,1,2,3,4,5,6]
//
//        let time:Double = currentTime()
//
//        let date:NSDate = timeToData(time)
//
//        return weekDays[date.dayOfWeek()]
//    }
//
//    class func dayInDate() -> Int{
//
//        let current = currentTime()
//        let begin1 = dateToTime("2015-10-11 00:00:00")
//        let end1 = dateToTime("2016-01-09 23:59:59")
//        let begin2 = dateToTime("2016-01-10 00:00:00")
//        let end2 = dateToTime("2016-04-09 23:59:59")
//
//        if(current > begin1 && current < end1){
//            return 0
//        }else if(current > begin2 && current < end2){
//            return 1
//        }
//        return 1
//    }
    
//    class func getDatesString(dayCount:Int) -> [String]{
//        var dates = [String]()
//        for i in 0 ..< dayCount {
//
//            let time:Double = TimeUtil.currentTime() + (Double)(24 * 3600 * (i+1))
//
//            let date:NSDate = TimeUtil.timeToData(time)
//            let dateFormat:NSDateFormatter = NSDateFormatter()
//            dateFormat.dateFormat = "yyy-MM-dd"
//            let str:NSString = dateFormat.stringFromDate(date)
//            dates.append(str as String)
//        }
//
//        return dates
//    }
    
    /**
     格式化时间差，几秒，几分，几小时
     
     - parameter str: 需要判断的时间
     
     - returns:
     */
    class func compareCurrentTime(str:String) -> String{
        
        if((str as NSString).doubleValue > 10000){
            return ""
        }
        
        let nowTime = currentTime()
        let lastTime = dateToTime(str: str)
        
        let temp = (Int)(nowTime - lastTime)
        
        var result:String
        if (temp < 60) {
            result = String(format: "%d秒前",temp)
            
        }else if(temp / 60 < 60){
            
            result = String(format: "%d分前",temp / 60)
            
        }else if(temp / 60 / 60 < 24){
            result = String(format: "%d小时前",temp / 60 / 60)
            
        }else{
            
            result = String(format: "%d天前",temp / 60 / 60 / 24)
        }
        
        return  result
    }
}

extension NSDate {
    
    
    func dayOfWeek() -> Int {
        
        
        let interval = self.timeIntervalSince1970;
        
        
        let days = Int(interval / 86400);
        
        
        return (days - 3) % 7;
        
    }
    
}
