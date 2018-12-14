//
//  FollowUp.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/13.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class FollowUp: UIViewController {

    @IBOutlet weak var navigateTitle: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var titleStr:String!
    
    var loadingView:EasyLoadingView!
    
    var enDatas:NSArray!
    var chDatas:NSArray!
    var timeDatas:NSArray!
    var mp3Path:String!
    
    var scoreDatas:NSMutableArray!
    
    var selectSection = 0
    
    var recordLabel:UILabel!
    var playBtn:UIButton!
    var recordPlayBtn:UIButton!
    
    //音频播放器
    var audio:AVAudioPlayer!
    var audioState = 0
    var timer:Timer!
    
    var soundView:UIView!
    var voiceWaveView:YSCVoiceWaveView!
    var voiceWavePartentView:UIView!
    var iFlySpeechEvaluator:IFlySpeechEvaluator!
    
    var evaluationData:Evaluation!
    
    var au:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigateTitle.text = self.titleStr
        
        self.table.bounces = false
        
        self.resetAudioPlayer()
        
        self.initScore()
        self.initIFly()
        //定时器
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                     selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    func initScore(){
        
        self.scoreDatas = NSMutableArray()
        
        for _ in self.enDatas {
            
            self.scoreDatas.add(NSNumber(value: -1))
        }
        
    }
    
    func initIFly(){
        if (self.iFlySpeechEvaluator == nil) {
            self.iFlySpeechEvaluator = IFlySpeechEvaluator.sharedInstance()
        }
        self.iFlySpeechEvaluator.delegate = self
        //empty params
        self.iFlySpeechEvaluator.setParameter("", forKey: IFlySpeechConstant.params())
    }
    
    func initDatas(titleStr:String,lrcDatas:NSMutableArray,mp3Path:String){
        self.titleStr = titleStr
        self.mp3Path = mp3Path
        
        self.timeDatas = (lrcDatas.object(at: 0) as! NSArray)
        self.enDatas = (lrcDatas.object(at: 1) as! NSArray)
        self.chDatas = (lrcDatas.object(at: 2) as! NSArray)
    }
    
    func resetAudioPlayer() {
        
        audio = try! AVAudioPlayer(contentsOf: URL(string: self.mp3Path)!)
        audio.volume = 1
        audio.enableRate = true
        audio.delegate = self
        audio.prepareToPlay()
        
        audioState = 1
        audio.play()
        
        
    }
    
    func initSoundImage(soundBGView:UIView){
        self.soundView = UIView()
        self.soundView.backgroundColor = UIColor.white
        self.soundView.isUserInteractionEnabled = true
        soundBGView.addSubview(self.soundView)
        self.soundView.isHidden = true
        _ = self.soundView.sd_layout()?.leftSpaceToView(soundBGView,0)?.rightSpaceToView(soundBGView,0)?.topSpaceToView(soundBGView,0)?.bottomSpaceToView(soundBGView,0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(onSoundView))
        self.soundView.addGestureRecognizer(tap)
        
        self.voiceWavePartentView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 137))
        self.soundView.insertSubview(self.voiceWavePartentView, at: 0)
        self.voiceWaveView = YSCVoiceWaveView()
        
        let img = UIImage(named: "iv_score_wave")
        let imgView = UIImageView(image: img)
        self.soundView.addSubview(imgView)
        _ = imgView.sd_layout()?.centerXEqualToView(self.soundView)?.centerYEqualToView(self.soundView)?.widthIs((img?.size.width)!)?.heightIs((img?.size.height)!)
    }
    
    @objc func onSoundView(){
        
        self.iFlySpeechEvaluator.stopListening()
        
        self.voiceWaveView.stopVoiceWave {
            self.soundView.isHidden = true
        }
    }
    
    //定时器响应，更新进度条
    @objc func tick() {
        
        if audioState == 1 {
            if timeDatas.count <= 0 {
                return
            }
            
            let currentTime = self.audio.currentTime
            
            let index = self.selectSection + 1
            
            if(index < self.timeDatas.count){
                let lastTimes = (timeDatas[self.selectSection + 1] as! NSString).components(separatedBy: ":")
                let lastTime = Double((lastTimes[0] as NSString).intValue * 60 + (lastTimes[1] as NSString).intValue)
                
                if(currentTime >= lastTime){
                    self.onPlay()
                }
            }
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FollowUp :IFlySpeechEvaluatorDelegate {
    func onVolumeChanged(_ volume: Int32, buffer: Data!) {
        self.voiceWaveView.changeVolume(CGFloat(volume) / 50.0)
    }
    
    func onBeginOfSpeech() {
        
    }
    
    func onEndOfSpeech() {
        
    }
    
    func onCancel() {
        
    }
    
    func onCompleted(_ errorCode: IFlySpeechError!) {
        if(errorCode.errorCode != 0){
            AppService.shared().showTip(tip: errorCode.errorDesc)
        }else{
            if(self.soundView.superview != nil){
                self.voiceWaveView.stopVoiceWave {
                    self.soundView.isHidden = true
                }
            }
            
            AudioSet.setAudiu()
            
            self.saveAudioData()
        }
    }
    
    func onResults(_ results: Data!, isLast: Bool) {
        if(isLast){
            
            let dict = try! XMLReader.dictionary(forXMLData: results) as NSDictionary
            let dict1 = dict.object(forKey: "xml_result") as! NSDictionary
            let dict2 = dict1.object(forKey: "read_sentence") as! NSDictionary
            let dict3 = dict2.object(forKey: "rec_paper") as! NSDictionary
            let dict4 = dict3.object(forKey: "read_chapter") as! NSDictionary
            let dict5 = dict4.object(forKey: "sentence") as! NSDictionary
            
            evaluationData = Evaluation.mj_object(withKeyValues: dict5)
            
            self.scoreDatas.replaceObject(at: selectSection, with: NSNumber(value: Int(evaluationData.total_score.doubleValue * 20.0)))
            
            self.table.reloadData()
            
        }
    }
    
}

extension FollowUp:AVAudioPlayerDelegate {
    
    func saveAudioData(){
        let home = NSHomeDirectory() as NSString
        let docPath = home.appendingPathComponent("Library/Caches") as NSString
        let saveFilePath = docPath.appendingPathComponent("RecordAudio_\(self.selectSection).wav")
        let pcmFilePath = docPath.appendingPathComponent("RecordAudio.pcm")
        
        let data = AudioSet.pcm_(to_wav: pcmFilePath, sampleRate: 16000)
        
        if(FileManager.default.fileExists(atPath: saveFilePath)){
            try! FileManager.default.removeItem(atPath: saveFilePath)
        }
        data.write(toFile: saveFilePath, atomically: true)
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.onPlay()
    }
}

extension FollowUp :UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let enLabel = cell.viewWithTag(1) as! UILabel
        enLabel.text = enDatas.object(at: indexPath.section) as? String
        
        let chLabel = cell.viewWithTag(2) as! UILabel
        chLabel.text = chDatas.object(at: indexPath.section) as? String
        
        if(selectSection == indexPath.section){
            enLabel.textColor = UIColor.black
            chLabel.textColor = UIColor.black
        }else{
            enLabel.textColor = UIColor(red: 120/225.0, green: 120/225.0, blue: 120/225.0, alpha: 1)
            chLabel.textColor = UIColor(red: 120/225.0, green: 120/225.0, blue: 120/225.0, alpha: 1)
        }
        
        let scoreLabel = cell.viewWithTag(3) as! UILabel
        let score = self.scoreDatas.object(at: indexPath.section) as! NSNumber
        scoreLabel.text = "\(score)'"
        
        if(score.intValue == -1){
            scoreLabel.isHidden = true
        }else{
            scoreLabel.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        audio.pause()
        audioState = 0
        if(self.selectSection == indexPath.section){
            self.selectSection = -1
        }else{
            self.selectSection = indexPath.section
        }
        
        self.table.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.enDatas.count
    }
    
    @objc func onTouchHeader(){
        self.cancelSelectSection()
    }
    
    @objc func onTouchFooter(){
        self.cancelSelectSection()
    }
    
    func cancelSelectSection(){
        self.selectSection = -1
        
        audio.pause()
        audioState = 0
        
        self.table.reloadData()
        
        self.iFlySpeechEvaluator.cancel()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(self.selectSection == section){
            let header = UIView()
            header.backgroundColor = UIColor.white
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(onTouchHeader))
            header.addGestureRecognizer(tap)
            
            let image = UIImage(named: "card_default_blue")
            let imageView = UIImageView(image: image)
            header.addSubview(imageView)
            _ = imageView.sd_layout()?.centerXEqualToView(header)?.centerYEqualToView(header)?.widthIs((image?.size.width)!)?.heightIs((image?.size.height)!)
            
            return header
        }
        return nil
    }
    
    @objc func onPlay(){
        
        if(audioState == 0){
            self.playBtn.setImage(UIImage(named: "btn_pause_press_content"), for: .normal)
            
            let times = (timeDatas[self.selectSection] as! NSString).components(separatedBy: ":")
            let time = Double((times[0] as NSString).intValue * 60 + (times[1] as NSString).intValue)
            self.audio.currentTime = time
            audioState = 1
            audio.play()
            
        }else if(audioState == 1){
            self.playBtn.setImage(UIImage(named: "btn_play_normal"), for: .normal)
            audio.pause()
            audioState = 0
        }
    }
    
    @objc func onRerocd(){
        AudioSet.resetAudiu()
        
        if(audioState == 1){
            self.onPlay()
        }
        
        let home = NSHomeDirectory() as NSString
        let docPath = home.appendingPathComponent("Library/Caches") as NSString
        let filePath = docPath.appendingPathComponent("RecordAudio_\(self.selectSection).wav")
        let pcmFilePath = docPath.appendingPathComponent("RecordAudio.pcm")
        
        if(FileManager.default.fileExists(atPath: filePath)){
            try! FileManager.default.removeItem(atPath: filePath)
        }
        if(FileManager.default.fileExists(atPath: pcmFilePath)){
            try! FileManager.default.removeItem(atPath: pcmFilePath)
        }
        
        self.iFlySpeechEvaluator.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
        self.iFlySpeechEvaluator.setParameter("utf-8", forKey: IFlySpeechConstant.text_ENCODING())
        self.iFlySpeechEvaluator.setParameter("xml", forKey: IFlySpeechConstant.ise_RESULT_TYPE())
        self.iFlySpeechEvaluator.setParameter("RecordAudio.pcm", forKey: IFlySpeechConstant.ise_AUDIO_PATH())
        self.iFlySpeechEvaluator.setParameter("en_us", forKey: IFlySpeechConstant.language())
        self.iFlySpeechEvaluator.setParameter("read_sentence", forKey: IFlySpeechConstant.ise_CATEGORY())
        self.iFlySpeechEvaluator.setParameter("60000", forKey: IFlySpeechConstant.speech_TIMEOUT())
        self.iFlySpeechEvaluator.startListening((self.enDatas.object(at: selectSection) as! String).data(using: String.Encoding.utf8)!, params: nil)
        
        self.soundView.isHidden = false
        self.voiceWaveView.show(inParentView: self.voiceWavePartentView)
        self.voiceWaveView.startVoiceWave()
    }
    
    @objc func onRecordPlay(){
        
        if((self.scoreDatas.object(at: selectSection) as! NSNumber).intValue != -1){
            
            let home = NSHomeDirectory() as NSString
            let docPath = home.appendingPathComponent("Library/Caches") as NSString
            let filePath = docPath.appendingPathComponent("RecordAudio_\(self.selectSection).wav")
            
            if(FileManager.default.fileExists(atPath: filePath)){
                
                au = try! AVAudioPlayer(contentsOf: URL(string: filePath)!)
                au.volume = 1
                au.play()
            }
        }else{
            AppService.shared().showTip(tip: "您还没有评分")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(self.selectSection == section){
            let footer = UIView()
            footer.backgroundColor = UIColor.white
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(onTouchFooter))
            footer.addGestureRecognizer(tap)
            
            var img = UIImage(named: "btn_score_normal")
            let recordBtn = UIButton()
            recordBtn.setImage(img, for: .normal)
            recordBtn.addTarget(self, action: #selector(onRerocd), for: .touchUpInside)
            footer.addSubview(recordBtn)
            _ = recordBtn.sd_layout()?.centerXEqualToView(footer)?.centerYEqualToView(footer)?.widthIs((img?.size.width)!)?.heightIs((img?.size.height)!)
            
            self.recordLabel = UILabel()
            self.recordLabel.text = "点击按钮 看你能读多少分"
            self.recordLabel.textColor = UIColor(red: 120/225.0, green: 120/225.0, blue: 120/225.0, alpha: 1)
            self.recordLabel.textAlignment = .center
            self.recordLabel.font = UIFont.systemFont(ofSize: 14)
            footer.addSubview(self.recordLabel)
            _ = self.recordLabel.sd_layout()?.centerXEqualToView(recordBtn)?.bottomSpaceToView(recordBtn,10)?.widthIs(300)?.heightIs(20)
            
            let countLabel = UILabel()
            countLabel.text = "\(section + 1)/\(self.enDatas.count)"
            countLabel.textColor = UIColor(red: 120/225.0, green: 120/225.0, blue: 120/225.0, alpha: 1)
            countLabel.font = UIFont.systemFont(ofSize: 14)
            countLabel.textAlignment = .center
            footer.addSubview(countLabel)
            _ = countLabel.sd_layout()?.centerXEqualToView(recordBtn)?.topSpaceToView(recordBtn,10)?.widthIs(300)?.heightIs(20)
            
            img = UIImage(named: "btn_play_normal")
            self.playBtn = UIButton()
            self.playBtn.setImage(img, for: .normal)
            if(audioState == 1){
                self.playBtn.setImage(UIImage(named: "btn_pause_press_content"), for: .normal)
            }
            self.playBtn.addTarget(self, action: #selector(onPlay), for: .touchUpInside)
            footer.addSubview(self.playBtn)
            _ = self.playBtn.sd_layout()?.rightSpaceToView(recordBtn,30)?.centerYEqualToView(recordBtn)?.widthIs((img?.size.width)!)?.heightIs((img?.size.height)!)
            
            img = UIImage(named: "btn_record_normol")
            self.recordPlayBtn = UIButton()
            self.recordPlayBtn.backgroundColor = UIColor(red: 254/255.0, green: 192/255.0, blue: 125/255.0, alpha: 1)
            self.recordPlayBtn.layer.masksToBounds = true
            self.recordPlayBtn.layer.cornerRadius = (img?.size.width)!/2
            self.recordPlayBtn.addTarget(self, action: #selector(onRecordPlay), for: .touchUpInside)
            
            if((self.scoreDatas.object(at: section) as! NSNumber).intValue != -1){
                
                self.recordPlayBtn.setImage(nil, for: .normal)
                self.recordPlayBtn.setTitle("\(self.scoreDatas.object(at: selectSection))'", for: .normal)
            }else{
                self.recordPlayBtn.setImage(img, for: .normal)
                self.recordPlayBtn.setTitle("", for: .normal)
            }
            footer.addSubview(self.recordPlayBtn)
            _ = self.recordPlayBtn.sd_layout()?.leftSpaceToView(recordBtn,30)?.centerYEqualToView(recordBtn)?.widthIs((img?.size.width)!)?.heightIs((img?.size.height)!)
            
            self.initSoundImage(soundBGView: footer)
            
            let line1 = UIView()
            line1.backgroundColor = UIColor.lightGray
            footer.addSubview(line1)
            _ = line1.sd_layout()?.leftSpaceToView(footer,0)?.rightSpaceToView(footer,0)?.bottomSpaceToView(footer,0)?.heightIs(1)
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(self.selectSection == section){
            return 120
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(self.selectSection == section){
            return 150
        }
        return 0
    }

}
