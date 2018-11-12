//
//  PersonalCenter.swift  个人中心
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/10/31.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class PersonalCenter: UIViewController {

    @IBOutlet weak var rewardBtn: UIButton!  //打赏
    @IBOutlet weak var challengeBtn: UIButton!  //挑战赛
    @IBOutlet weak var signInBtn: UIButton! //签到
    @IBOutlet weak var opinionBtn: UIButton! //意见
    @IBOutlet weak var settingBtn: UIButton! //设置
    @IBOutlet weak var exitBtn: UIButton!  //退出
    @IBOutlet weak var aboutBtn: UIButton! // 关于
    
    @IBOutlet weak var iconBtn: UIButton!
    @IBOutlet weak var nikeNameLabel: UILabel!
    
    @IBOutlet weak var scroll: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppService.shared().personal = self
        
        initBtnSelectBG()
        loadIcon()
        loadNikeName()
        
        scroll.bounces = false
        
        self.iconBtn.layer.masksToBounds = true
        self.iconBtn.layer.cornerRadius = 85.0/2
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onNikeName))
        self.nikeNameLabel.isUserInteractionEnabled = true
        self.nikeNameLabel.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        scroll.contentSize = CGSize(width: 0, height: 195+350)
    }
    
    func initBtnSelectBG(){
        
        rewardBtn.setBackgroundImage(ImageUtil.getImageWithColor(color: btnSelectBGColor), for: UIControl.State.highlighted)
        challengeBtn.setBackgroundImage(ImageUtil.getImageWithColor(color: btnSelectBGColor), for: UIControl.State.highlighted)
        signInBtn.setBackgroundImage(ImageUtil.getImageWithColor(color: btnSelectBGColor), for: UIControl.State.highlighted)
        opinionBtn.setBackgroundImage(ImageUtil.getImageWithColor(color: btnSelectBGColor), for: UIControl.State.highlighted)
        settingBtn.setBackgroundImage(ImageUtil.getImageWithColor(color: btnSelectBGColor), for: UIControl.State.highlighted)
        exitBtn.setBackgroundImage(ImageUtil.getImageWithColor(color: btnSelectBGColor), for: UIControl.State.highlighted)
        aboutBtn.setBackgroundImage(ImageUtil.getImageWithColor(color: btnSelectBGColor), for: UIControl.State.highlighted)
        
    }
    
    func loadIcon(){
        
        if(AppService.shared().userName != nil && AppService.shared().userName != ""){
            let iconImage = ImageUtil.readImage(name: icon_image as NSString)
            if(iconImage != nil){
                iconBtn.setImage(iconImage, for: UIControl.State.normal)
            }
        }
        
    }
    
    @objc func onNikeName(){
        
        if(AppService.shared().checkLogin()){
            let editNike = EditNikeName(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
            editNike.personal = self
            AppService.shared().navigate.view.addSubview(editNike)
        }
        
    }
    
    func resetNikeName(nikeName:String){
        self.nikeNameLabel.text = nikeName
    }
    
    func loadNikeName(){
        if(AppService.shared().userName != nil && AppService.shared().userName != ""){
            
            if(AppService.shared().isLogin){
                nikeNameLabel.text = AppService.shared().userName
                
                let parameters = ["uids":AppService.shared().uid!] as [String : Any]
                
                HttpService.shared().post(urlLast: "sign/get_nicks", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
                    
                    let arr:NSArray = obj as! NSArray
                    
                    let dict:NSDictionary = arr.object(at: 0) as! NSDictionary
                    
                    self.nikeNameLabel.text = dict.object(forKey: "nick") as? String
                }) { (task:URLSessionDataTask?, error:NSError?) in
                    
                }
            }
            
        }
    }

    @IBAction func onIcon(_ sender: Any) {
        
        if(AppService.shared().checkLogin()){
            LYLPhotoTailoringTool.shared()?.photoTailoring({ (image:UIImage?) in
                self.iconBtn.setImage(image, for: UIControl.State.normal)
                
                var data:NSData!
                if image?.pngData() == nil {
                    data = image!.jpegData(compressionQuality: 0.2)! as NSData
                }
                else {
                    data = image!.pngData()! as NSData
                }
                ImageUtil.saveImage(imageData: data, name: icon_image)
                
            })
        }
    }
    
    @IBAction func onReward(_ sender: Any) {
        
    }
    
    @IBAction func onChallenge(_ sender: Any) {
        
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        
    }
    
    @IBAction func onOpintion(_ sender: Any) {
        
    }
    
    @IBAction func onSetting(_ sender: Any) {
        let sb = UIStoryboard(name:"Personal", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Setting")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onExit(_ sender: Any) {
        AppService.shared().exitLogin()
        
        self.iconBtn.setImage(UIImage(named: "card_default_1"), for: .normal)
        self.nikeNameLabel.text = "点击设置你的昵称"
    }
    
    @IBAction func onAbout(_ sender: Any) {
        
    }
    
}
