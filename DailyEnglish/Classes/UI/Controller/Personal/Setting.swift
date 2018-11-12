//
//  Setting.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/6.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class Setting: UIViewController {

    @IBOutlet weak var clearCacheBtn: UIButton!
    @IBOutlet weak var cacheLabel: UILabel!
    
    @IBOutlet weak var definnition: UISwitch!//长按单词显示释义
    @IBOutlet weak var autoplay: UISwitch!//进入界面自动播放
    @IBOutlet weak var dividing: UISwitch!//内容界面显示分割线
    @IBOutlet weak var longBright: UISwitch!//保持屏幕长亮
    
    var tmpSize:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSwitchs()
        
        self.loadImageCacheSize()
    }
    
    //根据存储的本地数据设置switch是否选中
    func initSwitchs(){
        definnition.setOn(AppService.shared().isDefinnition, animated: false)
        autoplay.setOn(AppService.shared().isAutoplay, animated: false)
        dividing.setOn(AppService.shared().isDividing, animated: false)
        longBright.setOn(AppService.shared().isLongBright, animated: false)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClearCache(_ sender: Any) {
        if(tmpSize / 1024 > 0){
            let alert = UIAlertController(title: nil, message: "确定要清除缓存吗？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (alert:UIAlertAction) in
                self.clearCache()
            }))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            AppService.shared().showTip(tip: "暂无缓存")
        }
    }
    
    @IBAction func onDefinnition(_ sender: Any) {
        AppService.shared().isDefinnition = definnition.isOn
        UserDefaults.standard.set(AppService.shared().isDefinnition, forKey: definnition_str)
    }
    
    @IBAction func onAutoplay(_ sender: Any) {
        AppService.shared().isAutoplay = autoplay.isOn
        UserDefaults.standard.set(AppService.shared().isAutoplay, forKey: autoplay_str)
    }
    
    @IBAction func onDividing(_ sender: Any) {
        AppService.shared().isDividing = dividing.isOn
        UserDefaults.standard.set(AppService.shared().isDividing, forKey: dividing_str)
    }
    
    @IBAction func onLongBright(_ sender: Any) {
        AppService.shared().isLongBright = longBright.isOn
        UserDefaults.standard.set(AppService.shared().isLongBright, forKey: longBright_str)
        UIApplication.shared.isIdleTimerDisabled = AppService.shared().isLongBright
    }
    
    func loadImageCacheSize(){
        
        EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            return AppService.shared().netConfig
        }
        
        DispatchQueue.global().async {
            
            //这里写需要大量时间的代码
            self.tmpSize = Double(SDImageCache.shared().getSize()) / 1000.0 / 1000.0
            
            DispatchQueue.main.async {
                self.cacheLabel.text = self.tmpSize >= 1 ? String(format: "当前缓存%.2fM", self.tmpSize) : String(format: "当前缓存%.2fK", self.tmpSize * 1024)
                EasyLoadingView.hidenLoading()
            }
        }
        
    }
    
    func clearCache(){
        
        EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            return AppService.shared().netConfig
        }
        
        SDImageCache.shared().clearDisk {
            EasyLoadingView.hidenLoading()
            
            let tmpSize = Double(SDImageCache.shared().getSize()) / 1000.0 / 1000.0
            
            self.cacheLabel.text = tmpSize >= 1 ? String(format: "当前缓存%.2fM", tmpSize) : String(format: "当前缓存%.2fK", tmpSize * 1024)
        }
    }
    
}
