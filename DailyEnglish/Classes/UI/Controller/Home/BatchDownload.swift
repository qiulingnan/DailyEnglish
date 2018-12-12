//
//  BatchDownload.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/3.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class BatchDownload: UIViewController ,UITableViewDelegate ,UITableViewDataSource ,XMFDropBoxViewDataSource ,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectEpisode: UIButton!
    @IBOutlet weak var table: UITableView!
    
    var bookInfo:HomeNewsContentInfo!
    var loadingView:EasyLoadingView!
    
    var downloadList:DownloadListInfo!
    
    var cureentPage = 1
    
    var isShowDarp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = bookInfo.name! as String
        
        self.table.bounces = false

        self.loadTableDatas()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touch))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if isShowDarp {
            return true
        }
        return false
    }
    
    @objc func touch(){
        
        isShowDarp = false
        XMFDropBoxView.removeAllDropBox()
        
    }
    
    func loadTableDatas(){
        let parameters = ["cid":bookInfo.cid,"page":cureentPage] as [String : Any]
        
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        HttpService.shared().post(urlLast: "api/downloadlist", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            self.downloadList = DownloadListInfo.mj_object(withKeyValues: obj)
            
            self.table.separatorStyle = .singleLine
            self.table.reloadData()
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(self.downloadList != nil && self.downloadList.content != nil){
            return self.downloadList.content.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let download = self.downloadList.content.object(at: indexPath.row) as! DownloadInfo
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = download.title! as String
        
//        let name = cell.viewWithTag(2) as! UILabel
//        name.text = download.classname! as String
        
        let img = cell.viewWithTag(3) as! UIImageView
        if(download.isSelect){
            img.image = UIImage(named: "checkbox_checked")
        }else{
            img.image = UIImage(named: "checkbox_normal")
        }
        
        let receipt = MCDownloader.shared().downloadReceipt(forURLString: download.mp3url! as String)
        let receipt1 = MCDownloader.shared().downloadReceipt(forURLString: download.mp3lrc! as String)
        let backView = cell.viewWithTag(4)! as UIView
        if((receipt?.progress?.isFinished)! && (receipt1?.progress?.isFinished)!){
            img.image = UIImage(named: "checkbox_checked")
            backView.backgroundColor = UIColor(red: 88/255.0, green: 88/255.0, blue: 88/255.0, alpha: 88/255.0)
        }else{
            backView.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    //XMDropBox
    func dropBoxView(_ dropBoxView: XMFDropBoxView!, itemAt index: UInt) -> String? {
        
        return (self.downloadList.pages.object(at: Int(index)) as! String)
    }
    
    func dropBoxView(_ dropBoxView: XMFDropBoxView!, heightForItemAt index: UInt) -> CGFloat {
        return 30.0
    }
    
    func numberOfItem(in dropBoxView: XMFDropBoxView!) -> UInt {
        return UInt(self.downloadList.pages!.count)
    }
    
    func width(in dropBoxView: XMFDropBoxView!) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.downloadList.content.object(at: indexPath.row) as! DownloadInfo
        let receipt = MCDownloader.shared().downloadReceipt(forURLString: item.mp3url! as String)
        let receipt1 = MCDownloader.shared().downloadReceipt(forURLString: item.mp3lrc! as String)
        
        if(!(receipt?.progress?.isFinished)! || !(receipt1?.progress?.isFinished)!){
            let download = self.downloadList.content.object(at: indexPath.row) as! DownloadInfo
            download.isSelect = !download.isSelect
            
            self.table.reloadData()
        }
        
    }
    
    @IBAction func onPage(_ sender: Any) {
        
        if(self.downloadList == nil){
            AppService.shared().showTip(tip: "数据获取失败，请重新尝试")
            return
        }
        
        let box = XMFDropBoxView.dropBox(withLocationView: sender as! UIButton, dataSource: self)
        
        isShowDarp = true
        
        box?.selectItem({ (index:UInt) in
            if(self.cureentPage != index+1){
                self.selectEpisode.setTitle("选集\(self.downloadList.pages.object(at: Int(index)))", for: .normal)
                self.cureentPage = Int(index+1)
                self.isShowDarp = false
                self.loadTableDatas()
            }
            
            XMFDropBoxView.removeAllDropBox()
        })
        
        box?.displayDropBox()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onAll(_ sender: Any) {
        
        for item in self.downloadList.content {
            let receipt = MCDownloader.shared().downloadReceipt(forURLString: (item as! DownloadInfo).mp3url! as String)
            let receipt1 = MCDownloader.shared().downloadReceipt(forURLString: (item as! DownloadInfo).mp3lrc! as String)
            if((receipt?.progress?.isFinished)! && (receipt1?.progress?.isFinished)!){
                continue
            }
            (item as! DownloadInfo).isSelect = true
        }
        self.table.reloadData()
    }
    
    @IBAction func onInverse(_ sender: Any) {
        for item in self.downloadList.content {
            let receipt = MCDownloader.shared().downloadReceipt(forURLString: (item as! DownloadInfo).mp3url! as String)
            let receipt1 = MCDownloader.shared().downloadReceipt(forURLString: (item as! DownloadInfo).mp3lrc! as String)
            if((receipt?.progress?.isFinished)! && (receipt1?.progress?.isFinished)!){
                continue
            }
            (item as! DownloadInfo).isSelect = !(item as! DownloadInfo).isSelect
        }
        self.table.reloadData()
    }
    
    @IBAction func onDownload(_ sender: Any) {
        
        let needDownload = NSMutableArray()
        
        for item in self.downloadList.content {
            let receipt = MCDownloader.shared().downloadReceipt(forURLString: (item as! DownloadInfo).mp3url! as String)
            let receipt1 = MCDownloader.shared().downloadReceipt(forURLString: (item as! DownloadInfo).mp3lrc! as String)
            if (item as! DownloadInfo).isSelect && (!(receipt?.progress?.isFinished)! || !(receipt1?.progress?.isFinished)!){
                needDownload.add(item)
            }
        }
        
        if(needDownload.count > 0){
            let sb = UIStoryboard(name:"Home", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "BatchDownloadProsses")
            
            let temp = vc.view as! BatchDownloadProsses
            temp.initDatas(datas: needDownload, batchDownload: self)
            self.view.addSubview(temp)
            
        }else{
            AppService.shared().showTip(tip: "还没有选择下载任务")
        }
    }
}
