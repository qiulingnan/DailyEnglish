//
//  Login.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/1.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class Login: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var phoneField: QLNTextField!
    @IBOutlet weak var passWorldFeild: QLNTextField!
    @IBOutlet weak var loginBtn: QLNCustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initFeild()
        
        loginBtn.setBackgroundImage(ImageUtil.getImageWithColor(color: UIColor(red: 80/255.0, green: 195/255.0, blue: 246/255.0, alpha: 1)), for: UIControl.State.highlighted)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touch))
        self.view.addGestureRecognizer(tap)
        
    }
    
    func initFeild(){
        
        let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 38))
        leftImage.contentMode = UIView.ContentMode.scaleAspectFit
        leftImage.image = UIImage(named: "iv_register_phone")
        phoneField.leftView = leftImage
        phoneField.leftViewMode = UITextField.ViewMode.always
        
        let leftImage1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 38))
        leftImage1.contentMode = UIView.ContentMode.scaleAspectFit
        leftImage1.image = UIImage(named: "iv_register_lock")
        passWorldFeild.leftView = leftImage1
        passWorldFeild.leftViewMode = UITextField.ViewMode.always
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
        self.view.endEditing(true)
        
        if(RegularUtil.isTelNumber(num: phoneField.text! as NSString)){
            if(passWorldFeild.text!.count > 5){
                login()
            }else{
                AppService.shared().showTip(tip: "密码不能少于6位数")
            }
        }
    }
    
    func login(){
        let parameters = ["uname":phoneField.text!,"pwd":passWorldFeild.text!,"appid":AppService.shared().appid] as [String : Any]
        
        EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            return AppService.shared().netConfig
        }
        
        HttpService.shared().post(urlLast: "user/login", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            AppService.shared().isLogin = true
            
            AppService.shared().saveUserData(userName: self.phoneField.text!, passWorld: self.passWorldFeild.text!)
            
            if(AppService.shared().personal != nil){
                AppService.shared().personal.loadIcon()
                AppService.shared().personal.loadNikeName()
            }
            
            let dict:NSDictionary = obj as! NSDictionary
            
            AppService.shared().uid = dict.object(forKey: "uid")! as? String
            
            EasyLoadingView.hidenLoading()
            
            AppService.shared().showTip(tip: "登陆成功")
            
            self.navigationController?.popViewController(animated: true)
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading()
            
            AppService.shared().showTip(tip: "登陆失败")
        }
    }
    
    @IBAction func onForget(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let sb = UIStoryboard(name:"Login", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "forgetPassWorld")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onRegist(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let sb = UIStoryboard(name:"Login", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "regist")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
