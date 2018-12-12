//
//  WordInterpretation.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/16.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class WordInterpretation: UIView ,UITableViewDelegate,UITableViewDataSource{
    
    var audioDetails:AudioDetails!
    var wordInfo:WordInfo!
    var audioPlayer:STKAudioPlayer!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneticLabel: UILabel!
    @IBOutlet weak var interpretationLabel: UILabel!
    
    func initDatas( wordInfo:WordInfo,audioDetails:AudioDetails){
        self.wordInfo = wordInfo
        self.audioDetails = audioDetails
        
        self.resetAudioPlayer()
        self.initHearderView()
        
    }
    
    func initHearderView(){
        
        titleLabel.text = wordInfo.word! as String
        
        phoneticLabel.text = wordInfo.phonetic! as String
        
        interpretationLabel.text = ""
        if(wordInfo.mean != nil){
            interpretationLabel.text = StringUtil.addStrings(strArr: wordInfo.mean)
        }
        
    }
    
    //重置播放器
    func resetAudioPlayer() {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        audioPlayer = STKAudioPlayer(options: options)
        
        audioPlayer.meteringEnabled = true
        audioPlayer.volume = 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
            if(wordInfo.english != nil && wordInfo.english.count > 0){
                return wordInfo.english.count
            }
        }else if(section == 1){
            if(wordInfo.example != nil && wordInfo.example.count > 0){
                return wordInfo.example.count
            }
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell\(indexPath.section)", for: indexPath)

        if(indexPath.section == 0){
            
            if(wordInfo.english != nil && wordInfo.english.count > 0){
                let enInfo = wordInfo.english.object(at: indexPath.row) as! EnglishInfo
                
                let label1 = cell.viewWithTag(1) as! UILabel
                label1.text = "\(indexPath.row + 1).\(String(describing: enInfo.title!))"
                let label2 = cell.viewWithTag(2) as! UILabel
                label2.text = enInfo.explain! as String
            }
            
        }else if(indexPath.section == 1){
            if(wordInfo.example != nil && wordInfo.example.count > 0){
                let exampleInfo = wordInfo.example.object(at: indexPath.row) as! ExampleInfo
                
                let label1 = cell.viewWithTag(1) as! UILabel
                label1.text = "\(indexPath.row + 1).\(String(describing: exampleInfo.en!))"
                let label2 = cell.viewWithTag(2) as! UILabel
                label2.text = exampleInfo.ch! as String
                
                let button = cell.viewWithTag(3) as! UIButton
                button.isHidden = false
            }else{
                let button = cell.viewWithTag(3) as! UIButton
                button.isHidden = true
            }
            
        }

        return cell

    }
    
    @IBAction func onExampleSound(_ sender: Any) {
        let button = sender as! UIButton
        let cell = button.superview?.superview as! UITableViewCell
        
        let indexPath = self.table.indexPath(for: cell)! as NSIndexPath
        
        if(wordInfo.example != nil && wordInfo.example.count > 0){
            
            let example = wordInfo.example.object(at: indexPath.row) as! ExampleInfo
            let url = "\(String(describing: example.audio!))"
            
            if(url.range(of: "http://") != nil){
                audioPlayer.play(url)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        
        let title = UILabel()
        title.font = UIFont(name: fontStr1, size: 18)
        header.addSubview(title)
        _ = title.sd_layout()?.centerYEqualToView(header)?.leftSpaceToView(header,20)?.heightIs(20)
        title.setSingleLineAutoResizeWithMaxWidth(300)
        
        if(section == 0){
            title.text = "英文释义"
        }else if(section == 1){
            title.text = "例句"
        }
        
        return header
    }
    
    //处理section header悬停
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.table! {
            let sectionHeaderHeight = CGFloat(45.0)//headerView的高度
            if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
                
                scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0);
                
            } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
                
                scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0);
            }
        }
    }
    
    @IBAction func onSound(_ sender: Any) {
        
        if(wordInfo.audio != nil && wordInfo.audio.count > 0){
            
            let url = "\(wordInfo.audio.object(at: 0))"
            
            if(url.range(of: "http://") != nil){
                audioPlayer.play(url)
            }
            
        }
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.audioPlayer.stop()
        self.removeFromSuperview()
    }
    
    @IBAction func onAdd(_ sender: Any) {
        
        var audio:NSString = ""
        if(wordInfo.audio != nil && wordInfo.audio.count > 0){
            audio = "\(wordInfo.audio.object(at: 0))" as NSString
        }
        
        var mean:NSString = ""
        if(wordInfo.mean != nil){
            mean = StringUtil.addStrings(strArr: wordInfo.mean) as NSString
        }
        
        let word = WordData()
        word.initDatas(audio: audio, phonetic: wordInfo.phonetic, word: wordInfo.word, mean: mean, time: TimeUtil.stringFormCurrentTime() as NSString)
        AppService.shared().addWord(data: word)
        AppService.shared().showTip(tip: "添加单词成功")
    }
}
