//
//  AudioDetails.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/9.
//  Copyright © 2018年 邱岭男. All rights reserved.
//  播放
//

import UIKit
import AVFoundation

enum ABRepeatState {
    case nomarl
    case selectA
    case selectB
    case none
}

class AudioDetails: UIViewController ,UITableViewDelegate,UITableViewDataSource ,AVAudioPlayerDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var repeatBtn: UIButton!
    @IBOutlet weak var playBackSlider: UISlider!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var bottomMoreView: UIView!
    @IBOutlet weak var en_chBtn: UIButton!
    @IBOutlet weak var speedBtn: UIButton!
    @IBOutlet weak var abrepeatView: UIView!
    @IBOutlet weak var setABBtn: QLNCustomButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var aView: UIView!
    @IBOutlet weak var bLabel: UILabel!
    @IBOutlet weak var bView: UIView!
    @IBOutlet weak var aLabelLeft: NSLayoutConstraint!
    @IBOutlet weak var aViewLeft: NSLayoutConstraint!
    @IBOutlet weak var bLabelLeft: NSLayoutConstraint!
    @IBOutlet weak var bViewLeft: NSLayoutConstraint!
    @IBOutlet weak var abRepeatViewBottom: NSLayoutConstraint!
    
    var id:NSNumber!
    var navigateTitle:String!
    
    var mp3Url:String!
    var mp3lrcUrl:String!
    
    var mp3Path:String!
    var lrcPath:String!
    
    var isPlay = false
    var isFirstPlay = true
    var isRepeat = false
    
    var en_chCurrentType = 0
    var enHidden = false
    var chHidden = false
    
    var loadingView:EasyLoadingView!
    
    //更新进度条定时器
    var timer:Timer!
    //音频播放器
    var audio:AVAudioPlayer!
    
    var lrcDatas:NSMutableArray!
    var currentIndex = -1
    
    var isPlaying = false  //检测当前播放的audio是否是播放了一部分退出又进来的，如果是，需要继续播放
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.isHidden = true
        self.table.bounces = false
        
        self.bottomMoreView.isHidden = true
        
        self.titleLabel.text = navigateTitle
        
        playBackSlider.setThumbImage(UIImage(named: "slide"), for: .normal)
        playBackSlider.setThumbImage(UIImage(named: "slide"), for: .highlighted)
        
        //定时器
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                     selector: #selector(tick), userInfo: nil, repeats: true)
        
        if(AppService.shared().isDividing){
            self.table.separatorStyle = .singleLine
        }
        
        checkMp3Data()
    }
    
    //查看本地有没有下载过mp3数据
    func checkMp3Data(){
        
        if(AppService.shared().playAudio != nil){
            AppService.shared().playAudio.removeFromSuperview()
            
            if(self.id == AppService.shared().palyAudioId){
                self.isPlaying = true
                let path = (NSHomeDirectory() as NSString).appendingPathComponent("Documents")
                self.mp3Path = (path as NSString).appendingPathComponent(mp3DownloadName)
                self.lrcPath = (path as NSString).appendingPathComponent(lrcDownloadName)
                analysisLrc()
                return
            }else{
                AppService.shared().audio.stop()
            }
        }
        
        let receipt = MCDownloader.shared().downloadReceipt(forURLString: self.mp3Url)
        let lrcReceipt = MCDownloader.shared().downloadReceipt(forURLString: self.mp3lrcUrl)
        
        if((receipt?.progress?.isFinished)! && (lrcReceipt?.progress?.isFinished)!){
            self.mp3Path = receipt?.filePath
            
            self.lrcPath = lrcReceipt?.filePath
            
            analysisLrc()
        }else{
            downloadMp3()
        }
        
    }
    
    func initModel(model:ScrolInfo){
        
        self.id = model.id
        self.navigateTitle = model.title! as String
        
        self.mp3Url = model.mp3url! as String
        self.mp3lrcUrl = model.mp3lrc! as String
    }
    
    func initDatas(id:NSNumber,title:NSString,mp3Url:NSString,mp3lrcUrl:NSString){
        self.id = id
        self.navigateTitle = title as String
        self.mp3Url = mp3Url as String
        self.mp3lrcUrl = mp3lrcUrl as String
    }
    
    //重置播放器
    func resetAudioPlayer() {
        
        audio = try! AVAudioPlayer(contentsOf: URL(string: self.mp3Path)!)
        audio.volume = 1
        audio.delegate = self
        audio.enableRate = true
        audio.prepareToPlay()
        
        self.playBackSlider.maximumValue = Float(audio.duration)
        
        if(isPlaying){
            AppService.shared().audio.stop()
            audio.currentTime = AppService.shared().audio.currentTime
            self.onPlay(self.playBtn)
        }
    }
    
    //定时器响应，更新进度条
    @objc func tick() {
        
        if isPlay {
            //更新进度条进度值
            self.playBackSlider!.value = Float(audio.currentTime)

            self.updateLRCView()
            
            self.updateABRepeat()
        }
    }
    
    func updateABRepeat(){
        if(self.isABRepeat){
            if(self.audio.currentTime >= self.bTime){
                self.audio.currentTime = self.aTime
            }
        }
    }
    
    func updateLrcTable(index:Int){
        
        if(self.currentIndex == index){
            return
        }
        
        self.currentIndex = index
        
        self.table.reloadData()
        
        let indexPath = NSIndexPath(row: index, section: 0)
        self.table.selectRow(at: indexPath as IndexPath, animated: false, scrollPosition: .middle)
    }
    
    func updateLRCView(){
        
        let lrcTimeArray = self.lrcDatas.object(at: 0) as! NSMutableArray

        if lrcTimeArray.count <= 0 {
            return
        }

        let currentTime = self.audio.currentTime

        let firstTimes = (lrcTimeArray[1] as! NSString).components(separatedBy: ":")
        let lastTimes = (lrcTimeArray[lrcTimeArray.count - 1] as! NSString).components(separatedBy: ":")
        let firstTime = (firstTimes[0] as NSString).intValue * 60 + (firstTimes[1] as NSString).intValue
        let lastTime = (lastTimes[0] as NSString).intValue * 60 + (lastTimes[1] as NSString).intValue

        //当前播放时间小于第二条的起始时间
        if Int(currentTime) < firstTime {
            self.updateLrcTable(index: 0)
            return
        }
        //当前播放时间大于最后一条的起始时间
        if Int(currentTime) > lastTime {
            self.updateLrcTable(index: lrcTimeArray.count - 1)
            return
        }

        for i in 1 ..< lrcTimeArray.count{

            let times = (lrcTimeArray[i] as! NSString).components(separatedBy: ":")
            let time = (times[0] as NSString).intValue * 60 + (times[1] as NSString).intValue

            let times1 = (lrcTimeArray[i-1] as! NSString).components(separatedBy: ":")
            let time1 = (times1[0] as NSString).intValue * 60 + (times1[1] as NSString).intValue

            if(Int(currentTime) < time && Int(currentTime) > time1){
                self.updateLrcTable(index: i-1)
                break
            }

        }
        
    }
    
    @IBAction func onSlider(_ sender: Any) {
        
        if(isFirstPlay){
            self.playBackSlider.value = 0
        }
        
        audio.currentTime = TimeInterval(self.playBackSlider.value)

        if !isPlay && !isFirstPlay{
            self.playBtn.setImage(UIImage(named: "btn_pause_press_content"), for: .normal)
            audio.play()
            self.isPlay = !self.isPlay
        }
    }
    
    //当前播放结束后调用
    func resetDatas(){
        
        self.isPlay = false
        self.isFirstPlay = true
        self.playBtn.setImage(UIImage(named: "btn_play_normal"), for: .normal)
        self.playBackSlider.value = 0
        
        if(self.isRepeat){
            self.onPlay(self.playBtn)
        }
    }
    
    func downloadMp3(){
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        /* 创建网络下载对象 */
        
        let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        /* 下载地址 */
        let url = URL(string: self.mp3Url)
        let request = NSURLRequest(url: url!)
        
        /* 下载路径 */
        let path = (NSHomeDirectory() as NSString).appendingPathComponent("Documents")
        let mp3Path1 = (path as NSString).appendingPathComponent(mp3DownloadName) as NSString
        
        if(FileManager.default.fileExists(atPath: mp3Path1 as String)){
            try! FileManager.default.removeItem(atPath: mp3Path1 as String)
        }
        
        /* 开始请求下载 */
        
        let downloadTask = manager.downloadTask(with: request as URLRequest, progress: { (progress:Progress) in
            
        }, destination: { (url:URL, response:URLResponse) -> URL in
            return URL(fileURLWithPath: mp3Path1 as String)
        }) { (response:URLResponse, url:URL?, error:Error?) in
            
            if(error == nil){
                self.downloadLrc()
                self.mp3Path = mp3Path1 as String
            }else{
                AppService.shared().showTip(tip: "获取mp3信息失败")
                EasyLoadingView.hidenLoading(self.loadingView)
            }
            
        }
        downloadTask.resume()
    }
    
    func downloadLrc(){
        
        /* 创建网络下载对象 */
        
        let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        /* 下载地址 */
        let url = URL(string: self.mp3lrcUrl)
        let request = NSURLRequest(url: url!)
        
        /* 下载路径 */
        let path = (NSHomeDirectory() as NSString).appendingPathComponent("Documents")
        let lrcPath1 = (path as NSString).appendingPathComponent(lrcDownloadName) as NSString
        
        if(FileManager.default.fileExists(atPath: lrcPath1 as String)){
            try! FileManager.default.removeItem(atPath: lrcPath1 as String)
        }
        
        /* 开始请求下载 */
        
        let downloadTask = manager.downloadTask(with: request as URLRequest, progress: { (progress:Progress) in
            
        }, destination: { (url:URL, response:URLResponse) -> URL in
            return URL(fileURLWithPath: lrcPath1 as String)
        }) { (response:URLResponse, url:URL?, error:Error?) in
            
            if(error == nil){
                
                self.lrcPath = lrcPath1 as String
                self.analysisLrc()
                
            }
            
            EasyLoadingView.hidenLoading(self.loadingView)
        }
        downloadTask.resume()
    }
    
    func analysisLrc(){
        self.table.isHidden = false
        self.lrcDatas = StringUtil.analysisLrc(lrcPath: self.lrcPath)
        self.table.reloadData()
        
        resetAudioPlayer()
        
        if(AppService.shared().isAutoplay){
            self.onPlay(self.playBtn)
        }
    }
    
    @IBAction func onMore(_ sender: Any) {
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AudioMore")
        let more = vc.view as! AudioMore
        more.initDatas(audioDetails: self)
        self.view.addSubview(more)
    }
    
    func pauseAudio(){
        self.playBtn.setImage(UIImage(named: "btn_play_normal"), for: .normal)
        audio.pause()
    }
    
    @IBAction func onPlay(_ sender: Any) {
        
        if(self.isPlay){
            self.playBtn.setImage(UIImage(named: "btn_play_normal"), for: .normal)
            audio.pause()
        }else{
            self.playBtn.setImage(UIImage(named: "btn_pause_press_content"), for: .normal)
            if(isFirstPlay){
                isFirstPlay = false
            }
            audio.play()
        }
        
        self.isPlay = !self.isPlay
    }
    
    @IBAction func onPrevious(_ sender: Any) {
        
        audio.currentTime = audio.currentTime - 5 > 0 ? audio.currentTime - 5 : 0
        
        if !isPlay {
            self.playBtn.setImage(UIImage(named: "btn_pause_press_content"), for: .normal)
            audio.play()
            self.isPlay = !self.isPlay
        }
    }
    
    @IBAction func onNext(_ sender: Any) {
        
        audio.currentTime = audio.currentTime + 5 >= audio.duration ? audio.duration : audio.currentTime + 5
        
        if !isPlay {
            self.playBtn.setImage(UIImage(named: "btn_pause_press_content"), for: .normal)
            audio.play()
            self.isPlay = !self.isPlay
        }
    }
    
    @IBAction func onRepeat(_ sender: Any) {
        
        self.isRepeat = !self.isRepeat
        
        if(self.isRepeat){
            self.repeatBtn.setImage(UIImage(named: "iv_loop_selected_normol"), for: .normal)
            
            AppService.shared().showTip(tip: "循环播放已开启")
            
        }else{
            self.repeatBtn.setImage(UIImage(named: "iv_loop_normol"), for: .normal)
            
            AppService.shared().showTip(tip: "循环播放已关闭")
        }
    }
    
    @IBAction func onEN_CH(_ sender: Any) {
        self.en_chCurrentType = (self.en_chCurrentType + 1) % 3
        
        self.en_chBtn.setBackgroundImage(UIImage(named: "play_container_btn_\(self.en_chCurrentType)"), for: .normal)
        
        if(self.en_chCurrentType == 0){
            self.enHidden = false
            self.chHidden = false
        }else if(self.en_chCurrentType == 1){
            self.enHidden = false
            self.chHidden = true
        }else if(self.en_chCurrentType == 2){
            self.enHidden = true
            self.chHidden = false
        }
        
        self.table.reloadData()
    }
    
    @IBAction func onSpeedSpeech(_ sender: Any) {
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SpeedSpeech")
        let speed = vc.view as! SpeedSpeech
        speed.details = self
        self.view.addSubview(speed)
    }
    
    func resetSpeed(speed:Float,index:Int){
        audio.rate = speed
        speedBtn.setBackgroundImage(UIImage(named: "play_container_speed_0_\(index)_normol"), for: .normal)
    }
    
    @IBAction func onFollowUp(_ sender: Any) {
        
        if(isPlay){
            self.onPlay(self.playBtn)
        }
        
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "FollowUp") as! FollowUp
        vc.initDatas(titleStr: self.navigateTitle, lrcDatas: self.lrcDatas, mp3Path: self.mp3Path)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onABRepeat(_ sender: Any) {
        self.abrepeatView.isHidden = false
    }
    
    @IBAction func onExitAB(_ sender: Any) {
        self.setABState(state: .nomarl, rect: CGRect())
        self.abrepeatView.isHidden = true
    }
    
    var abState:ABRepeatState = .nomarl
    var aTime:Double!
    var bTime:Double!
    var isABRepeat = false
    
    func setABState(state:ABRepeatState,rect:CGRect){
        
        self.abState = state
        
        switch abState {
        case .nomarl:
            self.aLabel.isHidden = true
            self.aView.isHidden = true
            self.bLabel.isHidden = true
            self.bView.isHidden = true
            self.setABBtn.setTitle("设为A点", for: .normal)
            self.isABRepeat = false
            break
        case .selectA:
            self.aLabel.isHidden = false
            self.aView.isHidden = false
            
            aLabelLeft.constant = rect.origin.x
            aViewLeft.constant = rect.origin.x + 2
            
            self.setABBtn.setTitle("设为B点", for: .normal)
            aTime = self.audio.currentTime
            break
        case .selectB:
            
            bTime = self.audio.currentTime
            
            if(bTime <= aTime){
                AppService.shared().showTip(tip: "设置失败,B点时间必须大于A点")
                return
            }
            
            self.isABRepeat = true
            self.audio.currentTime = self.aTime
            
            self.bLabel.isHidden = false
            self.bView.isHidden = false
            
            bLabelLeft.constant = rect.origin.x
            bViewLeft.constant = rect.origin.x + 2
            
            
            break
        case .none:
            break
        }
    }
    
    @IBAction func onSetAB(_ sender: Any) {
        
        let rect = self.playBackSlider.convert(self.playBackSlider.bounds, to: nil)
        let tempRect = self.playBackSlider.thumbRect(forBounds: self.playBackSlider.bounds, trackRect: rect, value: self.playBackSlider.value)
        
        if(self.abState == .nomarl){
            self.setABState(state: .selectA, rect: tempRect)
        }else if(self.abState == .selectA){
            self.setABState(state: .selectB, rect: tempRect)
        }else if(self.abState == .selectB){
            AppService.shared().showTip(tip: "正在AB复读，如需修改请先重置")
        }
        
    }
    
    @IBAction func onResetAB(_ sender: Any) {
        self.setABState(state: .nomarl, rect: CGRect())
    }
    
    @IBAction func onShare(_ sender: Any) {
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Share")
        let share = vc.view as! Share
        share.shareType = .AudioDetails
        share.shareTitle = self.navigateTitle
        share._des = "每日英语,精彩你的生活!"
        share.initDatas()
        self.view.addSubview(share)
        
    }
    
    @IBAction func onBottomMore(_ sender: Any) {
        if(self.bottomMoreView.isHidden){
            
            self.abRepeatViewBottom.constant = 80
            self.bottomMoreView.transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.5) {
                self.bottomMoreView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }else{
            self.abRepeatViewBottom.constant = 0
        }
        
        self.bottomMoreView.isHidden = !self.bottomMoreView.isHidden
    }
    
    @IBAction func onBack(_ sender: Any) {
        
        if(self.audio.currentTime != 0){
            AppService.shared().recordPlayAudio(audio: self.audio, palyAudioId: self.id, palyAudioTitle: self.navigateTitle, palyAudioMp3Url: self.mp3Url, palyAudioMp3lrcUrl: self.mp3lrcUrl)
        }else{
            AppService.shared().playAudio = nil
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAddSentence(_ sender: Any) {
        let cell = (sender as! UIButton).superview?.superview
        
        let indexPath = self.table.indexPath(for: cell as! UITableViewCell)
        
        let lrcens = self.lrcDatas.object(at: 1) as! NSArray
        let lrcchs = self.lrcDatas.object(at: 2) as! NSArray
        let enstr = lrcens.object(at: indexPath!.row)
        let chstr = lrcchs.object(at: indexPath!.row)
        
        let sentence = SentenceData()
        
        sentence.initDatas(id: self.id, title: self.navigateTitle! as NSString, mp3Url: self.mp3Url! as NSString, lrcUrl: self.mp3lrcUrl! as NSString, time: TimeUtil.stringFormCurrentTime() as NSString, enstr: enstr as! NSString, chstr: chstr as! NSString)
        
        AppService.shared().addSentence(data: sentence)
        
        AppService.shared().showTip(tip: "已添加到笔记本")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.lrcDatas != nil) ? (self.lrcDatas.object(at: 0) as! NSArray).count:0
    }
    
    func showWordInterpretation(word:String){
        
        let newWord = StringUtil.removeNotEn(str: word as NSString)
        let parameters = ["word":newWord] as [String : Any]
        
        EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            return AppService.shared().netConfig
        }
        
        HttpService.shared().post(urlLast: "dict/desc", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
        
            let sb = UIStoryboard(name:"Home", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "WordInterpretation")
            let wordView = vc.view as! WordInterpretation
            wordView.initDatas(wordInfo: WordInfo.mj_object(withKeyValues: obj), audioDetails: self)
            self.view.addSubview(wordView)
            
            EasyLoadingView.hidenLoading()
        
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let lrcens = self.lrcDatas.object(at: 1) as! NSArray
        let lrcchs = self.lrcDatas.object(at: 2) as! NSArray
        let enstr = lrcens.object(at: indexPath.row) as? String
        let chstr = lrcchs.object(at: indexPath.row) as? String
        
        var attStr = NSMutableAttributedString(string: enstr!)
        if((enstr?.count)! > 0){
            
            let arr = enstr?.components(separatedBy: " ")
            let linkRangeArray = StringUtil.getRanges(strArray: arr! as NSArray)
            
            for i in 0 ..< linkRangeArray.count {
                
                let linkRange = linkRangeArray[i] as! NSRange
                
                let configure =  CJLabel.configureAttributes([kCTFontAttributeName as String:UIFont.systemFont(ofSize: 18)], isLink: true, activeLinkAttributes: [kCJActiveBackgroundFillColorAttributeName:UIColor.yellow], parameter: arr![i], clickLinkBlock: { (linkModel:CJLabelLinkModel?) in
                    
                    self.showWordInterpretation(word: linkModel?.parameter as! String)
                }, longPress: { (linkModel:CJLabelLinkModel?) in
                    
                    self.showWordInterpretation(word: linkModel?.parameter as! String)
                })
                
                attStr = CJLabel.configureAttrString(attStr, at: linkRange, configure: configure)
                
            }
        }
        
        let label = cell.viewWithTag(1) as! CJLabel
        let label1 = cell.viewWithTag(2) as! UILabel
        let button = cell.viewWithTag(3) as! UIButton
        
        if(self.currentIndex == indexPath.row){
            attStr.addAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, value: bgColor, range: NSRange(location: 0, length: attStr.length))
            label1.textColor = bgColor
            button.isHidden = false
//            if(enstr != ""){
//                button.isHidden = false
//            }else{
//                button.isHidden = true
//            }
            
        }else{
            attStr.removeAttribute(kCTForegroundColorAttributeName as NSAttributedString.Key, range: NSRange(location: 0, length: attStr.length))
            label1.textColor = UIColor.black
            button.isHidden = true
        }
        
        label.attributedText = attStr
        label1.text = chstr
        
        if(enHidden){
            label.attributedText = nil
            label.text = ""
        }
        
        if(chHidden){
            label1.text = ""
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.resetDatas()
    }
}
