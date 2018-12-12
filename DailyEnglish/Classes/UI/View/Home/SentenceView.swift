//
//  SentenceView.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/21.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class SentenceView: UIView ,UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppService.shared().sentenceDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let sentence = AppService.shared().sentenceDatas.object(at: indexPath.row) as! SentenceData
        
        let timeLabel = cell.viewWithTag(1) as! UILabel
        timeLabel.text = sentence.time as String
        
        let enLabel = cell.viewWithTag(2) as! UILabel
        enLabel.text = sentence.enstr as String
        
        let chLabel = cell.viewWithTag(3) as! UILabel
        chLabel.text = sentence.chstr as String
        
        return cell
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
        AppService.shared().removeSentence(index: indexPath.row)
        (self.viewWithTag(1) as! UITableView).reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sentence = AppService.shared().sentenceDatas.object(at: indexPath.row) as! SentenceData
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AudioDetails") as! AudioDetails
        vc.initDatas(id: sentence.id, title: sentence.title, mp3Url: sentence.mp3Url, mp3lrcUrl: sentence.lrcUrl)
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
}
