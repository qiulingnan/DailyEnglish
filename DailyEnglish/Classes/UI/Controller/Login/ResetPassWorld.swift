//
//  ResetPassWorld.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/4.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class ResetPassWorld: UIViewController {

    @IBOutlet weak var newField: QLNTextField!
    @IBOutlet weak var newSureField: QLNTextField!
    
    var phoneNumber:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touch))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func touch() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    @IBAction func onBack(_ sender: Any) {
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSure(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if(newField.text != ""){
            if(newSureField.text != ""){
                if(newSureField.text == newField.text){
                    sure()
                }else{
                    AppService.shared().showTip(tip: "两次密码不一致")
                }
            }else{
                AppService.shared().showTip(tip: "请确认新密码")
            }
        }else{
            AppService.shared().showTip(tip: "请输入新密码")
        }
    }
    
    func sure(){
        let parameters = ["appid":AppService.shared().appid,"uname":phoneNumber,"pwd":newField.text!] as [String : Any]
        
        HttpService.shared().post(urlLast: "user/modify_pwd", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            self.navigationController?.popViewController(animated: true)
            
            EasyLoadingView.hidenLoading()
            
            AppService.shared().showTip(tip: "修改密码成功")
            
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            
            EasyLoadingView.hidenLoading()
            
            AppService.shared().showTip(tip: "修改密码失败")
        }
    }
    
}
