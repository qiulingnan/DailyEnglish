//
//  SignInRecord.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/7.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class SignInRecord: UIViewController {

    var calenderView:LXCalendarView!
    var loadingView:EasyLoadingView!
    
    var signInData:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initCalender()
        
        self.loadSingInDatas()
    }
    
    func loadSingInDatas(){
        
        let parameters = ["uid":AppService.shared().uid,"appid":"mryy"] as [String : Any]
        
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        HttpService.shared().post(urlLast: "userCheck/lists", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            self.calenderView.datas = (obj as! [Any])
            self.calenderView.dealData()
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
        }
    }
    
    func initCalender(){
        
        self.calenderView = LXCalendarView(frame: CGRect(x: 20, y: 130, width: screenSize.width - 40, height: 0))
        
        self.calenderView.currentMonthTitleColor = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1)
        self.calenderView.lastMonthTitleColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)
        self.calenderView.nextMonthTitleColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1)
        
        self.calenderView.isHaveAnimation = false
        self.calenderView.isCanScroll = true
        self.calenderView.isShowLastAndNextBtn = true
        self.calenderView.isShowLastAndNextDate = true
        
        self.calenderView.todayTitleColor = UIColor.black
        self.calenderView.selectBackColor = bgColor
        
        
        
        self.calenderView.backgroundColor = UIColor.white
        self.view.addSubview(self.calenderView)
        
        self.calenderView.selectBlock = { (year:NSInteger,month:NSInteger,day:NSInteger) in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            var dataStr = "\(String(describing: year))-\(String(describing: month))-\(String(describing: day))"
            if(day < 10){
                dataStr = "\(String(describing: year))-\(String(describing: month))-0\(String(describing: day))"
            }
            let selectDate = dateFormatter.date(from: dataStr)
            
            let currentData = dateFormatter.date(from: NSString.getNowTime())
            
            // 判断是否大于当前时间
            
            let result = selectDate?.compare(currentData!)
            
            if (result == ComparisonResult.orderedDescending) {
                //大于当前日期
                AppService.shared().showTip(tip: "选择的日期还不可以进行签到")
            }else if (result == ComparisonResult.orderedAscending){
                //小于当前日期
                let sb = UIStoryboard(name:"Personal", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "SignIn") as!  SignIn
                vc.initDatas(year: year, month: month, day: day,dateStr: dataStr,isToday: false)
                AppService.shared().navigate.pushViewController(vc, animated: true)
            }else if (result == ComparisonResult.orderedSame){
                //等于当前日期
                let sb = UIStoryboard(name:"Personal", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "SignIn") as!  SignIn
                vc.initDatas(year: year, month: month, day: day,dateStr: dataStr,isToday: true)
                AppService.shared().navigate.pushViewController(vc, animated: true)

            }
            
        }
        
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onToday(_ sender: Any) {
        
    }
    
    @IBAction func onRanking(_ sender: Any) {
        let sb = UIStoryboard(name:"Personal", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SignInRanking")
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
}
