//
//  WordView.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/21.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class WordView: UIView ,UITableViewDelegate,UITableViewDataSource{
    
    var audioPlayer:STKAudioPlayer!
    
    //重置播放器
    func resetAudioPlayer() {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        audioPlayer = STKAudioPlayer(options: options)
        
        audioPlayer.meteringEnabled = true
        audioPlayer.volume = 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppService.shared().wordDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let word = AppService.shared().wordDatas.object(at: indexPath.row) as! WordData
        
        let time = cell.viewWithTag(1) as! UILabel
        time.text = word.time! as String
        
        let title = cell.viewWithTag(2) as! UILabel
        title.text = word.word! as String
        
        let phonetic = cell.viewWithTag(3) as! UILabel
        phonetic.text = word.phonetic! as String
        
        let mean = cell.viewWithTag(4) as! UILabel
        mean.text = word.mean! as String
        
        let sound = cell.viewWithTag(5) as! UIButton
        sound.addTarget(self, action: #selector(onSound), for: .touchUpInside)
        
        return cell
    }
    
    @objc func onSound(_ sender:Any){
        let cell = (sender as! UIButton).superview?.superview?.superview
        
        let indexPath = (self.viewWithTag(1) as! UITableView).indexPath(for: cell as! UITableViewCell)
        let wordData = AppService.shared().wordDatas.object(at: indexPath!.row) as! WordData
        
        if(audioPlayer == nil){
            self.resetAudioPlayer()
        }
        
        audioPlayer.play(wordData.audio as String)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        AppService.shared().removeWord(index: indexPath.row)
        (self.viewWithTag(1) as! UITableView).reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let wordData = AppService.shared().wordDatas.object(at: indexPath.row) as! WordData
//        let parameters = ["word":wordData.word] as [String : Any]
//        
//        EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
//            return AppService.shared().netConfig
//        }
//        
//        HttpService.shared().post(urlLast: "dict/desc", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
//            
//            let sb = UIStoryboard(name:"Home", bundle: nil)
//            let vc = sb.instantiateViewController(withIdentifier: "WordInterpretation")
//            let wordView = vc.view as! WordInterpretation
//            wordView.initDatas(wordInfo: WordInfo.mj_object(withKeyValues: obj), audioDetails: self)
//            self.view.addSubview(wordView)
//            
//            EasyLoadingView.hidenLoading()
//            
//        }) { (task:URLSessionDataTask?, error:NSError?) in
//            EasyLoadingView.hidenLoading()
//        }
    }
    
}
