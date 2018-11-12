//
//  StartViewController.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/10/29.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var leapfrogBtn: ATCountdownButton!
    @IBOutlet weak var bgImage: UIImageView!
    
    var ad:ADInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leapfrogBtn.layer.masksToBounds = true
        leapfrogBtn.layer.cornerRadius = 30.0
        
        leapfrogBtn.titleLabel?.font = UIFont(name: fontStr1, size: 24)
        
        
        
        leapfrogBtn.start(withDuration: 5.0, block: { (time) in
            
            let temp = [5,4,3,2,1]
            let index = Int(time)
            if(index < 5){
                self.leapfrogBtn.setTitle("\(temp[index])", for: UIControl.State.normal)
            }
            
        }) { (Bool) in
            
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
            
        }
        
        let parameters = ["section":"1","appid":AppService.shared().appid]
        
        HttpService.shared().post(urlLast: "ad", parameters:parameters as AnyObject , succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
        
            self.ad = ADInfo.mj_object(withKeyValues: obj)!
            
            let img = self.bgImage!
            img.sd_setImage(with: NSURL(string: self.ad.imgSrc as String)! as URL, placeholderImage: UIImage(named: "bg_transparent"),options: SDWebImageOptions.retryFailed, completed: nil)
            
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            
        }
        
        bgImage.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(StartViewController.onBGClick(gestureRecognizer:)))
        bgImage.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func onBGClick(gestureRecognizer:UIGestureRecognizer){
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
