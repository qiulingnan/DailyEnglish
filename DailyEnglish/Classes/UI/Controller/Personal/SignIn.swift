//
//  SignIn.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/9.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class SignIn: UIViewController {
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var enLabel: UILabel!
    @IBOutlet weak var chLabel: UILabel!
    @IBOutlet weak var scoreDetails: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var recordingBtn: UIButton!
    @IBOutlet weak var soundBGView: UIView!
    @IBOutlet weak var table: UITableView!
    
    var year:Int!
    var month:Int!
    var day:Int!
    var dataStr:String!
    var isToday:Bool!
    
    var loadingView:EasyLoadingView!
    
    var signInfo:SignInfo!
    
    var iFlySpeechEvaluator:IFlySpeechEvaluator!
    
    var audioPlayer:STKAudioPlayer!
    var audioPlayer1:STKAudioPlayer!
    var isPlay = false
    
    var soundView:UIView!
    var voiceWaveView:YSCVoiceWaveView!
    var voiceWavePartentView:UIView!
    
    var tableDatas:NSMutableArray!
    
    var evaluationData:Evaluation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isToday){
            self.signInBtn.isHidden = false
        }else{
            self.signInBtn.isHidden = true
        }
        
        self.table.bounces = false
        
        self.checkAudio()
        
        self.resetAudioPlayer()
        self.initSoundImage()
        self.initIFly()
        
        self.loadSignStatement()
    }
    
    //检测本地有没有存储当天的语音信息
    func checkAudio(){
        let eva = AppService.shared().findSignIn(dateStr: self.dataStr)
        
        if(eva != nil){
            
            if((eva?.isSignIn == 1)){
                self.signInBtn.isHidden = true
            }
            self.recordingBtn.setImage(nil, for: .normal)
            self.recordingBtn.setTitle("\(Int((eva! as EvaluationData).total_score.doubleValue * 20.0))'", for: .normal)
        }
    }
    
    func resetAudioPlayer() {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        audioPlayer = STKAudioPlayer(options: options)
        
        audioPlayer.delegate = self
        audioPlayer.meteringEnabled = true
        audioPlayer.volume = 1
        
        self.resetAudioPlayer1()
    }
    
    func resetAudioPlayer1() {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        audioPlayer1 = STKAudioPlayer(options: options)
        
        audioPlayer1.delegate = self
        audioPlayer1.meteringEnabled = true
        audioPlayer1.volume = 1
    }
    
    func initSoundImage(){
        self.soundView = UIView()
        self.soundView.backgroundColor = UIColor.white
        self.soundView.isUserInteractionEnabled = true
        self.soundBGView.addSubview(self.soundView)
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
    
    @objc func onSoundView(tap:UIGestureRecognizer){
        
        self.iFlySpeechEvaluator.stopListening()
        
        self.voiceWaveView.stopVoiceWave {
            self.soundView.isHidden = true
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
    
    //获取签到语句
    func loadSignStatement(){
        let parameters = ["appid":"mryy","time":self.dataStr]
        
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        HttpService.shared().post(urlLast: "UserCheck/Everyday", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            self.signInfo = SignInfo.mj_object(withKeyValues: obj)
            
            self.enLabel.text = self.signInfo.en as String
            self.chLabel.text = self.signInfo.zh as String
            
            self.loadTableData()
            EasyLoadingView.hidenLoading(self.loadingView)
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
        }
    }
    
    func initDatas(year:Int,month:Int,day:Int,dateStr:String,isToday:Bool){
        self.year = year
        self.month = month
        self.day = day
        self.dataStr = dateStr
        self.isToday = isToday
    }
    
    func sign(){
        
        let home = NSHomeDirectory() as NSString
        let docPath = home.appendingPathComponent("Documents") as NSString
        let filePath = docPath.appendingPathComponent("SignAudio/\(self.dataStr!).wav")
        
        let av = try! AVAudioPlayer(contentsOf: URL(string: filePath)!)
        
        let eva = AppService.shared().findSignIn(dateStr: self.dataStr)
        
        
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        let parameters = ["appid":"mryy","is_show":1,"uid":AppService.shared().uid,"sentenceId":self.signInfo.sentence_id,
                          "score":eva!.total_score.doubleValue * 20.0,"duration":av.duration * 1000] as [String : Any]
        
        let session = AFHTTPSessionManager()

        session.post("http://common.api.en8848.com/UserCheck/signIn", parameters: parameters, constructingBodyWith: { (data:AFMultipartFormData) in

            let audioData = NSMutableData(contentsOfFile: filePath)

            data.appendPart(withFileData: audioData! as Data, name: "audio", fileName: "\(self.dataStr!).wav", mimeType: "wav")

        }, progress: { (progress:Progress) in

        }, success: { (task:URLSessionDataTask, responseObject:Any?) in

            let obj = NetStatus.mj_object(withKeyValues: responseObject)!

            if(obj.status == 0){
                
                AppService.shared().showTip(tip: "签到成功")

                self.signInBtn.isHidden = true
                let eva = AppService.shared().findSignIn(dateStr: self.dataStr)
                eva?.isSignIn = 1
                AppService.shared().addSignIn(data: eva!)

                EasyLoadingView.hidenLoading(self.loadingView)
            }else{
                print(obj.status)
                AppService.shared().showTip(tip: obj.msg as String)
            }

            EasyLoadingView.hidenLoading(self.loadingView)
        }) { (task:URLSessionDataTask?, error:Error) in

            EasyLoadingView.hidenLoading(self.loadingView)
        }
        
    }

    @IBAction func onSign(_ sender: Any) {
        let eva = AppService.shared().findSignIn(dateStr: self.dataStr)
        if(eva != nil && Int((eva?.total_score.doubleValue)! * 20) >= 60){
            self.sign()
        }else{
            AppService.shared().showTip(tip: "分数达到60分才可以签到")
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onScoreDetils(_ sender: Any) {
        let sb = UIStoryboard(name:"Personal", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ScoreDetails")
        let tempView = vc.view as! ScoreDetails
        tempView.data = self.evaluationData
        self.view.addSubview(tempView)
    }
    
    @IBAction func onStar(_ sender: Any) {
        
        let btn = sender as! UIButton
        let cell = btn.superview?.superview as! UITableViewCell
        let indexPath = self.table.indexPath(for: cell)
        
        let signList = self.tableDatas.object(at: indexPath!.row) as! SIgnListInfo
        
        if(signList.isStar){
            btn.setImage(UIImage(named: "good_checked"), for: .normal)
            btn.setTitle("1", for: .normal)
        }else{
            btn.setImage(UIImage(named: "good_normol"), for: .normal)
            btn.setTitle("0", for: .normal)
        }
        signList.isStar = !signList.isStar
    }
    
    @IBAction func onAudio(_ sender: Any) {
        
        audioPlayer1.stop()
        
        let cell = (sender as! UIButton).superview?.superview?.superview as! UITableViewCell
        let indexPath = self.table.indexPath(for: cell)
        
        let signList = self.tableDatas.object(at: indexPath!.row) as! SIgnListInfo
        
        self.audioPlayer.play(signList.audio as String)
        
        if(currentAudioImage != nil){
            currentAudioImage.stopAnimating()
            audioFlag = true
            currentAudioImage = nil
        }
        
        let audioImage = (cell.viewWithTag(6) as! UIImageView)
        audioImage.animationImages = ([UIImage(named: "sign_voice_01"),UIImage(named: "sign_voice_02"),UIImage(named: "sign_voice_03")] as! [UIImage])
        
        audioImage.animationDuration = 2.0
        audioImage.startAnimating()
        
        currentAudioImage = audioImage
    }
    
    var currentAudioImage:UIImageView!
    var audioFlag = false
    
    @IBAction func onPlay(_ sender: Any) {
        if self.isPlay {
            self.playBtn.setImage(UIImage(named: "btn_play_normal"), for: .normal)
            self.audioPlayer1.pause()
        }else{
            self.playBtn.setImage(UIImage(named: "btn_pause_press_content"), for: .normal)
            
            if(self.audioPlayer1.state == .paused){
                self.audioPlayer1.resume()
            }else{
                self.audioPlayer1.play(URL(string: self.signInfo.mp3 as String)!)
            }
            
        }
        
        self.isPlay = !self.isPlay
    }
    
    @IBAction func onFollowUp(_ sender: Any) {
        
        AudioSet.resetAudiu()
        
        let home = NSHomeDirectory() as NSString
        let docPath = home.appendingPathComponent("Documents") as NSString
        let filePath = docPath.appendingPathComponent("SignAudio/\(self.dataStr!).wav")
        
        let pcmDocPath = home.appendingPathComponent("Library/Caches") as NSString
        let pcmFilePath = pcmDocPath.appendingPathComponent("TempAudio.pcm")
        if(FileManager.default.fileExists(atPath: filePath)){
            try! FileManager.default.removeItem(atPath: filePath)
        }
        
        if(FileManager.default.fileExists(atPath: pcmFilePath)){
            try! FileManager.default.removeItem(atPath: pcmFilePath)
        }
        
        self.iFlySpeechEvaluator.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
        self.iFlySpeechEvaluator.setParameter("utf-8", forKey: IFlySpeechConstant.text_ENCODING())
        self.iFlySpeechEvaluator.setParameter("xml", forKey: IFlySpeechConstant.ise_RESULT_TYPE())
        self.iFlySpeechEvaluator.setParameter("TempAudio.pcm", forKey: IFlySpeechConstant.ise_AUDIO_PATH())
        self.iFlySpeechEvaluator.setParameter("en_us", forKey: IFlySpeechConstant.language())
        self.iFlySpeechEvaluator.setParameter("read_sentence", forKey: IFlySpeechConstant.ise_CATEGORY())
        self.iFlySpeechEvaluator.setParameter("60000", forKey: IFlySpeechConstant.speech_TIMEOUT())
        self.iFlySpeechEvaluator.startListening((self.signInfo.en as String).data(using: String.Encoding.utf8)!, params: nil)
        
        self.soundView.isHidden = false
        self.voiceWaveView.show(inParentView: self.voiceWavePartentView)
        self.voiceWaveView.startVoiceWave()
        
    }
    
    var au:AVAudioPlayer!
    @IBAction func onPlayRecording(_ sender: Any) {
        let home = NSHomeDirectory() as NSString
        let docPath = home.appendingPathComponent("Documents") as NSString
        let filePath = docPath.appendingPathComponent("SignAudio/\(self.dataStr!).wav")
        
        if(FileManager.default.fileExists(atPath: filePath)){
            
            au = try! AVAudioPlayer(contentsOf: URL(string: filePath)!)
            au.volume = 1
            au.play()
        }
    }
    
}

extension SignIn:IFlySpeechEvaluatorDelegate {
    
    func saveAudioData(){
        /// 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString
        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.appendingPathComponent("Library/Caches") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("TempAudio.pcm")

        let data = AudioSet.pcm_(to_wav: filePath, sampleRate: 16000)

        let saveDocPath = home.appendingPathComponent("Documents") as NSString
        let saveFilePath = saveDocPath.appendingPathComponent("SignAudio/\(self.dataStr!).wav")

        if(FileManager.default.fileExists(atPath: saveFilePath)){
            try! FileManager.default.removeItem(atPath: saveFilePath)
        }
        data.write(toFile: saveFilePath, atomically: true)
        
        let ev = EvaluationData()
        ev.initData(total_score: self.evaluationData.total_score, date: self.dataStr! as NSString)
        AppService.shared().addSignIn(data: ev)
    }
    
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
            
            self.recordingBtn.setImage(nil, for: .normal)
            self.recordingBtn.setTitle("\(Int(evaluationData.total_score.doubleValue * 20.0))'", for: .normal)
            
            self.scoreDetails.isHidden = false
        }
        
    }
  
}

extension SignIn:UITableViewDelegate,UITableViewDataSource {
    
    func loadTableData(){
        let parameters = ["appid":"mryy","uid":AppService.shared().uid,"sid":self.signInfo.id] as [String : Any]
        
        HttpService.shared().post(urlLast: "UserCheck/CheckAll", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            self.tableDatas = SIgnListInfo.mj_objectArray(withKeyValuesArray: obj)
            
            self.table.separatorStyle = .singleLine
            self.table.reloadData()
        }) { (task:URLSessionDataTask?, error:NSError?) in
//            EasyLoadingView.hidenLoading(self.loadingView)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDatas != nil ? self.tableDatas.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let signList = self.tableDatas.object(at: indexPath.row) as! SIgnListInfo
        
        let nick = cell.viewWithTag(1) as! UILabel
        nick.text = signList.userinfo.nick as String
        
        let time = cell.viewWithTag(2) as! UILabel
        time.text = signList.created_at as String
        
        let duration = cell.viewWithTag(3) as! UILabel
        duration.text = "\(signList.duration.intValue / 1000)\""
        
        let score = cell.viewWithTag(4) as! UILabel
        score.text = signList.score.stringValue
        
        let scoreImg = cell.viewWithTag(5) as! UIImageView
        if(signList.score.intValue >= 90){
            scoreImg.image = UIImage(named: "sign_score_great")
        }else{
            scoreImg.image = UIImage(named: "sign_score_good")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    @objc func onScoreRanking(){
        let sb = UIStoryboard(name:"Personal", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SignInRanking")
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    @objc func onSelfScore(){
        
        let parameters = ["appid":"mryy","uid":AppService.shared().uid]
        
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        HttpService.shared().post(urlLast: "UserCheck/scoreALL", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            let dict = obj?.mj_keyValues()
            let sb = UIStoryboard(name:"Personal", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SelfScore")
            let tempView = vc.view as! SelfScore
            let eva = AppService.shared().findSignIn(dateStr: self.dataStr)
            var sc = "0"
            if(eva != nil){
                sc = "\(Int((eva?.total_score.doubleValue)! * 20.0))"
            }
            
            tempView.initDatas(dict: dict!, year: self.year, month: self.month, day: self.day, sc: sc)
            self.view.addSubview(tempView)
            
            EasyLoadingView.hidenLoading(self.loadingView)
        }) { (task:URLSessionDataTask?, error:NSError?) in
            
            AppService.shared().showTip(tip: "获取数据失败")
            
            EasyLoadingView.hidenLoading(self.loadingView)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = UIView()
        sectionView.backgroundColor = bgColor
        
        let line = UIView()
        line.backgroundColor = UIColor.white
        sectionView.addSubview(line)
       _ =  line.sd_layout()?.centerXEqualToView(sectionView)?.centerYEqualToView(sectionView)?.widthIs(1)?.heightIs(40)
        
        let leftBtn = UIButton()
        leftBtn.setTitle("点击查看积分排名详情", for: .normal)
        leftBtn.setTitleColor(UIColor.white, for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        leftBtn.addTarget(self, action: #selector(onScoreRanking), for: .touchUpInside)
        sectionView.addSubview(leftBtn)
        _ = leftBtn.sd_layout()?.leftSpaceToView(sectionView,0)?.rightSpaceToView(line,0)?.topSpaceToView(sectionView,0)?.bottomSpaceToView(sectionView,0)
        
        let rightBtn = UIButton()
        rightBtn.setTitle("点击查看个人成绩", for: .normal)
        rightBtn.setTitleColor(UIColor.white, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.addTarget(self, action: #selector(onSelfScore), for: .touchUpInside)
        sectionView.addSubview(rightBtn)
        _ = rightBtn.sd_layout()?.leftSpaceToView(line,0)?.rightSpaceToView(sectionView,0)?.topSpaceToView(sectionView,0)?.bottomSpaceToView(sectionView,0)
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}

extension SignIn:STKAudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
        
        if(audioPlayer == self.audioPlayer1){
            self.playBtn.setImage(UIImage(named: "btn_play_normal"), for: .normal)
            self.isPlay = false
        }else{
            if(currentAudioImage != nil){
                if(audioFlag){
                    audioFlag = false
                }else{
                    currentAudioImage.stopAnimating()
                    currentAudioImage = nil
                }
                
            }
        }
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
        
    }
    
    
}
