//
//  AudioDetails.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/9.
//  Copyright © 2018年 邱岭男. All rights reserved.
//  播放
//

import UIKit

class AudioDetails: UIViewController ,STKAudioPlayerDelegate ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var repeatBtn: UIButton!
    @IBOutlet weak var playBackSlider: UISlider!
    @IBOutlet weak var table: UITableView!
    
    var id:NSNumber!
    var navigateTitle:String!
    
    var mp3Url:String!
    var mp3lrcUrl:String!
    
    var isPlay = false
    var isFirstPlay = true
    var isRepeat = false
    
    //更新进度条定时器
    var timer:Timer!
    //音频播放器
    var audioPlayer: STKAudioPlayer!
    
    var lrcDatas:NSMutableArray!
    var currentIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.isHidden = true
        self.table.bounces = false
        
//        loadContent()
        downloadLrc()
        
        self.titleLabel.text = navigateTitle
        
        playBackSlider.setThumbImage(UIImage(named: "slide"), for: .normal)
        playBackSlider.setThumbImage(UIImage(named: "slide"), for: .highlighted)
        
        //定时器
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                     selector: #selector(tick), userInfo: nil, repeats: true)
        
        resetAudioPlayer()
        
        if(AppService.shared().isAutoplay){
            self.onPlay(self.playBtn)
        }
    }
    
    func initModel(model:ScrolInfo){
        
        self.id = model.id
        self.navigateTitle = model.title! as String
        
        self.mp3Url = model.mp3url! as String
        self.mp3lrcUrl = model.mp3lrc! as String
    }
    
    //重置播放器
    func resetAudioPlayer() {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        audioPlayer = STKAudioPlayer(options: options)
        
        audioPlayer.meteringEnabled = true
        audioPlayer.volume = 1
        audioPlayer.delegate = self
    }
    
    //定时器响应，更新进度条
    @objc func tick() {
        
        if isPlay {
            //更新进度条进度值
            let progress = audioPlayer.progress
            let duration = audioPlayer.duration
            self.playBackSlider!.value = Float(progress/duration)
            
            self.updateLRCView()
        }
    }
    
    func updateLrcTable(index:Int){
        
        if(self.currentIndex == index){
            return
        }
        
        self.currentIndex = index
        
        self.table.reloadData()
        
        let indexPath = NSIndexPath(row: index, section: 0)
        self.table.selectRow(at: indexPath as IndexPath, animated: true, scrollPosition: .middle)
    }
    
    func updateLRCView(){
        
        let lrcTimeArray = self.lrcDatas.object(at: 0) as! NSMutableArray
        
        if lrcTimeArray.count <= 0 {
            return
        }
        
        let currentTime = self.audioPlayer.progress
        for i in 0 ..< lrcTimeArray.count{
            let times = (lrcTimeArray[i] as! NSString).components(separatedBy: ":")
            
            let time = (times[0] as NSString).intValue * 60 + (times[1] as NSString).intValue

            if(i == lrcTimeArray.count - 1){
                if(Int(currentTime) > time){
                    self.updateLrcTable(index: i)
                    break
                }
            }else if(i == 0){
                let times1 = (lrcTimeArray[i+1] as! NSString).components(separatedBy: ":")
                let time1 = (times1[0] as NSString).intValue * 60 + (times1[1] as NSString).intValue
                
                if(Int(currentTime) < time1){
                    self.updateLrcTable(index: i)
                    break
                }
                
            }else{
                let times1 = (lrcTimeArray[i-1] as! NSString).components(separatedBy: ":")
                let time1 = (times1[0] as NSString).intValue * 60 + (times1[1] as NSString).intValue

                if(Int(currentTime) < time && Int(currentTime) > time1){
                    self.updateLrcTable(index: i-1)
                    break
                }
            }
        }
        
    }
    
    @IBAction func onSlider(_ sender: Any) {
        
        if(isFirstPlay){
            self.playBackSlider.value = 0
        }
        
        let duration = audioPlayer.duration
        let sliderProgress = self.playBackSlider.value
        audioPlayer.seek(toTime: duration * Double(sliderProgress))
        
        if !isPlay && !isFirstPlay{
            self.playBtn.setImage(UIImage(named: "btn_pause_press_content"), for: .normal)
            audioPlayer.resume()
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
    
    func downloadLrc(){
        
        EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            return AppService.shared().netConfig
        }
        /* 创建网络下载对象 */
        
        let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        /* 下载地址 */
        let url = URL(string: self.mp3lrcUrl)
        let request = NSURLRequest(url: url!)
        
        /* 下载路径 */
        let path = (NSHomeDirectory() as NSString).appendingPathComponent("Documents")
        let lrcPath = (path as NSString).appendingPathComponent(lrcDownloadName) as NSString
        
        if(FileManager.default.fileExists(atPath: lrcPath as String)){
            try! FileManager.default.removeItem(atPath: lrcPath as String)
        }
        
        /* 开始请求下载 */
        
        let downloadTask = manager.downloadTask(with: request as URLRequest, progress: { (progress:Progress) in
            
        }, destination: { (url:URL, response:URLResponse) -> URL in
            return URL(fileURLWithPath: lrcPath as String)
        }) { (response:URLResponse, url:URL?, error:Error?) in
            
            if(error == nil){
                
                self.table.isHidden = false
                self.lrcDatas = StringUtil.analysisLrc()
                self.table.reloadData()
                
                if(AppService.shared().isAutoplay){
                    self.onPlay(self.playBtn)
                }
                    
            }
            
            EasyLoadingView.hidenLoading()
        }
        downloadTask.resume()
    }
    
//    func loadContent(){
//        let parameters = ["id":self.id] as [String : Any]
//
//        EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
//            return AppService.shared().netConfig
//        }
//
//        HttpService.shared().post(urlLast: "api/detail", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
//
//            EasyLoadingView.hidenLoading()
//
//        }) { (task:URLSessionDataTask?, error:NSError?) in
//            EasyLoadingView.hidenLoading()
//        }
//    }
    
    @IBAction func onMore(_ sender: Any) {
        
    }
    
    @IBAction func onPlay(_ sender: Any) {
        
        if(self.isPlay){
            self.playBtn.setImage(UIImage(named: "btn_play_normal"), for: .normal)
            audioPlayer.pause()
        }else{
            self.playBtn.setImage(UIImage(named: "btn_pause_press_content"), for: .normal)
            if(isFirstPlay){
                audioPlayer.play(URL(string: self.mp3Url)!)
                isFirstPlay = false
            }else{
                audioPlayer.resume()
            }
        }
        
        self.isPlay = !self.isPlay
    }
    
    @IBAction func onPrevious(_ sender: Any) {
        
        var progress = audioPlayer.progress - 5
        let duration = audioPlayer.duration
        if(progress < 0 ){ progress = 0 }
        
        self.playBackSlider!.value = Float(progress/duration)
        audioPlayer.seek(toTime: progress)
    }
    
    @IBAction func onNext(_ sender: Any) {
        
        var progress = audioPlayer.progress + 5
        let duration = audioPlayer.duration
        if(progress > duration ){ progress = duration }
        
        self.playBackSlider!.value = Float(progress/duration)
        audioPlayer.seek(toTime: progress)
        
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
    
    @IBAction func onBottomMore(_ sender: Any) {
        
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //开始播放歌曲
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     didStartPlayingQueueItemId queueItemId: NSObject) {
        
    }
    
    //缓冲完毕
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        
    }
    
    //播放状态变化
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     stateChanged state: STKAudioPlayerState,
                     previousState: STKAudioPlayerState) {
    }
    
    //播放结束
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     didFinishPlayingQueueItemId queueItemId: NSObject,
                     with stopReason: STKAudioPlayerStopReason,
                     andProgress progress: Double, andDuration duration: Double) {
        resetAudioPlayer()
        self.resetDatas()
    }
    
    //发生错误
    func audioPlayer(_ audioPlayer: STKAudioPlayer,
                     unexpectedError errorCode: STKAudioPlayerErrorCode) {
        print("Error when playing music \(errorCode)")
        resetAudioPlayer()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.lrcDatas != nil) ? (self.lrcDatas.object(at: 0) as! NSArray).count:0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let lrcens = self.lrcDatas.object(at: 1) as! NSArray
        let lrcchs = self.lrcDatas.object(at: 2) as! NSArray
        let enstr = lrcens.object(at: indexPath.row) as? String
        let chstr = lrcchs.object(at: indexPath.row) as? String
        
        let label = cell.viewWithTag(1) as! UILabel
        label.text = enstr
        
        let label1 = cell.viewWithTag(2) as! UILabel
        label1.text = chstr
        
        if(self.currentIndex == indexPath.row){
            label.textColor = bgColor
            label1.textColor = bgColor
        }else{
            label.textColor = UIColor.black
            label1.textColor = UIColor.black
        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}
