//
//  SMSVerification.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/4.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class SMSVerification: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeField: QLNTextField!
    
    var phoneNumber:String!
    var uid:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "短信验证码已发送至"+phoneNumber

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touch))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func touch() {
        self.view.endEditing(true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSure(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if(codeField.text != "" && self.uid == codeField.text){
            let sb = UIStoryboard(name:"Login", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ResetPassWorld") as! ResetPassWorld
            vc.phoneNumber = self.phoneNumber
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            AppService.shared().showTip(tip: "验证码不正确")
        }
    }
    
    @IBAction func onResend(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let time = Int(TimeUtil.currentTimeMillis())
        
        let sign = (("1"+phoneNumber+"\(time)").md5+"En8848@com").md5
        let parameters = ["phone":phoneNumber,"sign":sign,"t":"1","timestamp":time] as [String : Any]
        
        EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            return AppService.shared().netConfig
        }
        
        HttpService.shared().post(urlLast: "send/code", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            EasyLoadingView.hidenLoading()
            
            AppService.shared().showTip(tip: "获取验证码成功")
            
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            
            EasyLoadingView.hidenLoading()
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
