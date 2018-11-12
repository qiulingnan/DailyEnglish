//
//  ForgetPassWorld.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/2.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class ForgetPassWorld: UIViewController {

    @IBOutlet weak var phoneField: QLNTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBack(_ sender: Any) {
        
        self.view.endEditing(true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onNext(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if(RegularUtil.isTelNumber(num: phoneField.text! as NSString)){
            next()
        }
    }
    
    func next(){
        
        let phoneNumber = self.phoneField.text!
        let time = Int(TimeUtil.currentTimeMillis())

        let sign = ("1\(phoneNumber)\(time)".md5+"En8848@com").md5
        let parameters = ["phone":phoneNumber,"sign":sign,"t":"1","timestamp":time] as [String : Any]

        EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            return AppService.shared().netConfig
        }

        HttpService.shared().post(urlLast: "send/code", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in

            EasyLoadingView.hidenLoading()

            AppService.shared().showTip(tip: "获取验证码成功")

            let sb = UIStoryboard(name:"Login", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SMSVerification") as! SMSVerification
            vc.phoneNumber = phoneNumber
            vc.uid =  "\(obj!)"
            self.navigationController?.pushViewController(vc, animated: true)

        }) { (task:URLSessionDataTask?, error:NSError?) in

            EasyLoadingView.hidenLoading()

        }
    }
    
}
