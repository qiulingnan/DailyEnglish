//
//  RewardPay.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/6.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class RewardPay: UIView {

    @IBOutlet weak var nickField: UITextField!
    @IBOutlet weak var totalTextField: QLNTextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var wechatCheck: UIImageView!
    @IBOutlet weak var alipayCheck: UIImageView!
    
    var currentField:UITextField!
    
    var keyboardIsShow = false
    
    var payState = "wxpay"
    
    var loadingView:EasyLoadingView!
    
    func initDatas(){
        
        let money = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 30))
        money.text = "¥:"
        money.textColor = UIColor.red
        totalTextField.leftView = money
        totalTextField.leftViewMode = UITextField.ViewMode.always
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touch))
        self.addGestureRecognizer(tap)
        
        self.registerForKeyboardNotifications()
        
        bottomView.frame.origin.y = screenSize.height
        UIView.animate(withDuration: 0.5) {
            self.bottomView.frame.origin.y = screenSize.height - 443
        }
        
    }
    
    func removed(){
        bottomView.frame.origin.y = screenSize.height - 443
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.frame.origin.y = screenSize.height
        }) { (complete:Bool) in
            self.removeFromSuperview()
        }
        
    }
    
    @objc func touch() {
        
        if(keyboardIsShow){
            self.endEditing(true)
        }else{
            self.removed()
        }
       
    }
    
    func registerForKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWasShown(aNotification:NSNotification){
        
        keyboardIsShow = true
        
        let keyboardFrame = (aNotification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let height = keyboardFrame!.origin.y
        
        let rect = self.currentField.convert(self.currentField.bounds, to: self)
        
        if(rect.maxY > height){
            self.viewMovewUp(y: rect.maxY - height + 10)
        }
        
    }
    
    @objc func keyboardWillBeHidden(aNotification:NSNotification){
        
        keyboardIsShow = false
        
        let frame = self.frame
        
        self.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    func viewMovewUp(y:CGFloat){
        
        let frame = self.frame
        
        self.frame = CGRect(x: frame.origin.x, y: 0 - y, width: frame.width, height: frame.height)
    }
    
    @IBAction func onWechat(_ sender: Any) {
        self.payState = "wxpay"
        self.wechatCheck.image = UIImage(named: "checkbox_checked")
        self.alipayCheck.image = UIImage(named: "checkbox_normal")
    }
    
    @IBAction func onAlipay(_ sender: Any) {
        self.payState = "alipay"
        self.wechatCheck.image = UIImage(named: "checkbox_normal")
        self.alipayCheck.image = UIImage(named: "checkbox_checked")
    }
    
    @IBAction func onSure(_ sender: Any) {
        
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        var parameters = ["money":self.totalTextField.text!,"appid":"mryy","pay":payState] as [String : Any]
        
        if(self.nickField.text != ""){
            parameters = ["money":self.totalTextField.text!,"appid":"mryy","pay":payState,"reward_name":self.nickField.text!] as [String : Any]
        }
        
        HttpService.shared().post(urlLast: "trade/reward", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            if(self.payState == "wxpay"){
                let payInfo = PayInfo.mj_object(withKeyValues: obj)
                self.wxPay(pay: payInfo!)
            }else{
                let payInfo = PayInfo()
                payInfo.alipay = (obj as! NSString)
                self.alipay(pay: payInfo)
            }
            
            EasyLoadingView.hidenLoading(self.loadingView)
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }
    }
    
    func payCallBack(dict:NSDictionary){
        if(self.payState == "wxpay"){
            self.removeFromSuperview()
        }else{
            if((dict).value(forKey: "resultStatus") as! String == "9000") {
                self.removeFromSuperview()
            }else {
                AppService.shared().showTip(tip: "支付失败")
            }
        }
    }
    
    func wxPay(pay:PayInfo){
        
        AlipayService.sharedService().callBack = {(dict:NSDictionary) in
            self.payCallBack(dict: dict)
        }
        
        let request = PayReq()
        
        request.partnerId = pay.partnerid as String
        request.prepayId = pay.prepay_id as String
        request.package = pay.package as String
        request.nonceStr = pay.nonce_str as String
        request.timeStamp = UInt32(pay.timestamp.intValue)
        request.sign = pay.sign as String
        WXApi.send(request)
    }
    
    func alipay(pay:PayInfo){
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
        let appScheme = "en8848.daily"
        
        AlipaySDK.defaultService()?.payOrder(pay.alipay as String, fromScheme: appScheme, callback: { (dict:[AnyHashable : Any]?) in
            self.payCallBack(dict: dict! as NSDictionary)
        })
    }
    
}

extension RewardPay :UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentField = textField
    }
}
