//
//  Regist.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/2.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class Regist: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var phoneFeild: QLNTextField!
    @IBOutlet weak var codeFeild: QLNTextField!
    @IBOutlet weak var setField: QLNTextField!
    @IBOutlet weak var codeBtn: QLNCustomButton!
    @IBOutlet weak var registBtn: QLNCustomButton!
    
    var uid:NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initFeild()
        
        registBtn.setBackgroundImage(ImageUtil.getImageWithColor(color: UIColor(red: 80/255.0, green: 195/255.0, blue: 246/255.0, alpha: 1)), for: UIControl.State.highlighted)
        
        setField.isHidden = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touch))
        self.view.addGestureRecognizer(tap)
    }
    
    func initFeild(){
        
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 38))
        leftImage.contentMode = UIView.ContentMode.scaleAspectFit
        leftImage.image = UIImage(named: "iv_register_phone")
        phoneFeild.leftView = leftImage
        phoneFeild.leftViewMode = UITextField.ViewMode.always
        
        let leftImage1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 38))
        leftImage1.contentMode = UIView.ContentMode.scaleAspectFit
        leftImage1.image = UIImage(named: "iv_register_code")
        codeFeild.leftView = leftImage1
        codeFeild.leftViewMode = UITextField.ViewMode.always
        
        let leftImage2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 38))
        leftImage2.contentMode = UIView.ContentMode.scaleAspectFit
        leftImage2.image = UIImage(named: "iv_register_lock")
        setField.leftView = leftImage2
        setField.leftViewMode = UITextField.ViewMode.always
    }
    
    @objc func touch() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onGetCode(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let phoneNumber = phoneFeild.text!
        
        if(RegularUtil.isTelNumber(num: phoneNumber as NSString)){
            self.codeBtn.startTime(withDuration: 60)
            getCode(phoneNumber: phoneNumber)
        }
    }
    
    //获取验证码
    func getCode(phoneNumber:String){
        
        let time = Int(TimeUtil.currentTimeMillis())
        
        let sign = ("1\(phoneNumber)\(time)".md5+"En8848@com").md5
        
        let parameters = ["phone":phoneNumber,"sign":sign,"t":"1","timestamp":time] as [String : Any]
        
        EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            return AppService.shared().netConfig
        }
        
        HttpService.shared().post(urlLast: "send/code", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            EasyLoadingView.hidenLoading()
            
            AppService.shared().showTip(tip: "获取验证码成功")
            
            self.setField.isHidden = false
            
            self.uid = "\(obj!)" as NSString

        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading()
            
            AppService.shared().showTip(tip: "获取验证码失败")
        }
    }
    
    func regist(){
        
        EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            return AppService.shared().netConfig
        }
        
        let phoneNumber = phoneFeild.text!
        
        let parameters = ["appid":AppService.shared().appid,"deviceid":phoneNumber,"uid":uid,"phone":phoneNumber,"pwd":setField.text!] as [String : Any]
        
        HttpService.shared().post(urlLast: "user/bind", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            self.navigationController?.popViewController(animated: true)
            
            EasyLoadingView.hidenLoading()
            
            AppService.shared().showTip(tip: "注册成功")
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            
            EasyLoadingView.hidenLoading()
            
            AppService.shared().showTip(tip: "注册失败")
        }
        
    }
    
    @IBAction func onRegist(_ sender: Any) {
        self.view.endEditing(true)
        
        let phoneNumber = phoneFeild.text!
        
        if(RegularUtil.isTelNumber(num: phoneNumber as NSString)){
            if(self.uid != nil && codeFeild.text != "" && self.uid.isEqual(to: codeFeild.text!)){
                if((self.setField.text?.count)! >= 6){
                    regist()
                }else{
                    AppService.shared().showTip(tip: "密码不能少于6位数")
                }
            }else{
                AppService.shared().showTip(tip: "验证码不对")
            }
        }
    }
    
    
}
