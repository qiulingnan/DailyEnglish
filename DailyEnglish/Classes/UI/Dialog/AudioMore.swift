//
//  AudioMore.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/19.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class AudioMore: UIView {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var collectBtn: UIButton!
    @IBOutlet weak var interpretationSwitch: UISwitch!
    @IBOutlet weak var autoSwitch: UISwitch!
    @IBOutlet weak var excisionBtn: UISwitch!
    @IBOutlet weak var longBrightSwitch: UISwitch!
    
    var audioDetails:AudioDetails!
    var collectData:CollectData!
    
    var isCollect = false
    
    func initDatas(audioDetails:AudioDetails){
        
        self.audioDetails = audioDetails
        
        self.initSwitchs()
        
        self.initCollectData()
        
        bottomView.frame.origin.y = screenSize.height
        UIView.animate(withDuration: 0.5) {
            self.bottomView.frame.origin.y = screenSize.height - 250
        }
        
    }
    
    func removed(){
        bottomView.frame.origin.y = screenSize.height - 250
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.frame.origin.y = screenSize.height
        }) { (complete:Bool) in
            self.removeFromSuperview()
        }
        
    }
    
    func initCollectData(){
        
        collectData = CollectData()
        collectData.initDatas(id: audioDetails.id, title: audioDetails.navigateTitle! as NSString, mp3Url: audioDetails.mp3Url! as NSString, lrcUrl: audioDetails.mp3lrcUrl! as NSString, time: TimeUtil.stringFormCurrentTime() as NSString)
        
        isCollect = AppService.shared().findCollectData(data: collectData)
        
        if(isCollect){
            collectBtn.setImage(UIImage(named: "favourit_press"), for: .normal)
        }else{
            collectBtn.setImage(UIImage(named: "favourit_normol"), for: .normal)
        }
    }
    
    //根据存储的本地数据设置switch是否选中
    func initSwitchs(){
        interpretationSwitch.setOn(AppService.shared().isDefinnition, animated: false)
        autoSwitch.setOn(AppService.shared().isAutoplay, animated: false)
        excisionBtn.setOn(AppService.shared().isDividing, animated: false)
        longBrightSwitch.setOn(AppService.shared().isLongBright, animated: false)
    }
    
    @IBAction func onCollect(_ sender: Any) {
        
        if(isCollect){
            collectBtn.setImage(UIImage(named: "favourit_normol"), for: .normal)
            AppService.shared().removeCollect(data: collectData)
        }else{
            collectBtn.setImage(UIImage(named: "favourit_press"), for: .normal)
            AppService.shared().addCollect(data: collectData)
        }
        
        isCollect = !isCollect
    }
    
    @IBAction func onBook(_ sender: Any) {
        audioDetails.pauseAudio()
        
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BookNet")
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
 
    @IBAction func onInterpretation(_ sender: Any) {
        AppService.shared().isDefinnition = interpretationSwitch.isOn
        UserDefaults.standard.set(AppService.shared().isDefinnition, forKey: definnition_str)
    }
    
    @IBAction func onAuto(_ sender: Any) {
        
        AppService.shared().isAutoplay = autoSwitch.isOn
        UserDefaults.standard.set(AppService.shared().isAutoplay, forKey: autoplay_str)
    }
    
    @IBAction func onExcision(_ sender: Any) {
        
        AppService.shared().isDividing = excisionBtn.isOn
        UserDefaults.standard.set(AppService.shared().isDividing, forKey: dividing_str)
        
        if(AppService.shared().isDividing){
            audioDetails.table.separatorStyle = .singleLine
        }else{
            audioDetails.table.separatorStyle = .none
        }
    }
    
    @IBAction func onLongBright(_ sender: Any) {
        
        AppService.shared().isLongBright = longBrightSwitch.isOn
        UserDefaults.standard.set(AppService.shared().isLongBright, forKey: longBright_str)
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.removed()
    }
    
}
