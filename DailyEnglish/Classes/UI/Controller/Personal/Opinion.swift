//
//  Opinion.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/12.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class Opinion: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.placeholder = "请填写您的宝贵意见吧~"
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touch))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func touch(){
        
        self.view.endEditing(true)
    }

    @IBAction func onComit(_ sender: Any) {
        AppService.shared().showTip(tip: "意见反馈成功")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension Opinion: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}

extension Opinion :UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
