//
//  EditNikeName.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/5.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class EditNikeName: UIView ,UITextFieldDelegate {
    
    var centerView:UIView!
    var nikeField:UITextField!
    
    var personal:PersonalCenter!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadView()
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touch))
        self.addGestureRecognizer(tap)
        
        self.registerForKeyboardNotifications()
    }
    
    @objc func touch() {
        self.endEditing(true)
    }
    
    func registerForKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWasShown(aNotification:NSNotification){
        
        let keyboardFrame = (aNotification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let height = keyboardFrame!.origin.y
        
        let rect = self.centerView.convert(self.centerView.bounds, to: self)
        
        if(rect.maxY > height){
            self.viewMovewUp(y: rect.maxY - height + 10)
        }
        
    }
    
    @objc func keyboardWillBeHidden(aNotification:NSNotification){
        let frame = self.frame
        
        self.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    func viewMovewUp(y:CGFloat){
        
        let frame = self.frame
        
        self.frame = CGRect(x: frame.origin.x, y: 0 - y, width: frame.width, height: frame.height)
    }
    
    func loadView(){
        centerView = UIView()
        centerView.backgroundColor = UIColor.white
        self.addSubview(centerView)
        _ = centerView.sd_layout()?.centerYEqualToView(self)?.leftSpaceToView(self,15)?.rightSpaceToView(self,15)?.heightIs(150)
        
        let title = UILabel()
        title.text = "请设置你的昵称"
        title.font = UIFont(name: fontStr1, size: 20)
        centerView.addSubview(title)
        _ = title.sd_layout()?.leftSpaceToView(centerView,15)?.topSpaceToView(centerView,10)?.rightSpaceToView(centerView,20)?.heightIs(30)
        
        nikeField = UITextField()
        nikeField.placeholder = "昵称"
        nikeField.borderStyle = .none
        centerView.addSubview(nikeField)
        _ = nikeField.sd_layout()?.leftSpaceToView(centerView,15)?.topSpaceToView(title,20)?.rightSpaceToView(centerView,20)?.heightIs(30)
        
        let line = UIView()
        line.backgroundColor = bgColor
        centerView.addSubview(line)
        _ = line.sd_layout()?.leftSpaceToView(centerView,15)?.topSpaceToView(nikeField,0)?.rightSpaceToView(centerView,20)?.heightIs(1)
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1), for: .normal)
        sureBtn.titleLabel?.font = UIFont(name: fontStr1, size: 16)
        centerView.addSubview(sureBtn)
        _ = sureBtn.sd_layout()?.topSpaceToView(line,20)?.rightSpaceToView(centerView,20)?.heightIs(30)?.widthIs(50)
        sureBtn.addTarget(self, action: #selector(onSure), for: .touchUpInside)
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = UIFont(name: fontStr1, size: 16)
        cancelBtn.setTitleColor(UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1), for: .normal)
        centerView.addSubview(cancelBtn)
        _ = cancelBtn.sd_layout()?.topSpaceToView(line,20)?.rightSpaceToView(sureBtn,20)?.heightIs(30)?.widthIs(50)
        cancelBtn.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        
    }
    
    @objc func onSure(){
        
        self.endEditing(true)
        
        if(self.nikeField.text != ""){
            let parameters = ["nick":self.nikeField.text!,"uid":AppService.shared().uid!] as [String : Any]
            
            EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
                return AppService.shared().netConfig
            }
            
            HttpService.shared().post(urlLast: "sign/update_nick", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
                
                self.personal.resetNikeName(nikeName: self.nikeField.text!)
                
                self.removeFromSuperview()
                
                EasyLoadingView.hidenLoading()
                
                AppService.shared().showTip(tip: "修改昵称成功")
                
                
            }) { (task:URLSessionDataTask?, error:NSError?) in
                EasyLoadingView.hidenLoading()
                
                AppService.shared().showTip(tip: "修改昵称失败")
            }
        }else{
            AppService.shared().showTip(tip: "昵称不能为空")
        }
    }
    
    @objc func onCancel(){
        self.removeFromSuperview()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
