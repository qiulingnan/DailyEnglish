//
//  BatchDownloadProsses.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/5.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class BatchDownloadProsses: UIView {
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var btn: QLNCustomButton!
    @IBOutlet weak var label: UILabel!
    
    var downloads:NSArray!
    var batchDownload:BatchDownload!
    var currentCount = 0
    var downloadState = 0
    
    var isCancel = false
    
    func initDatas(datas:NSArray,batchDownload:BatchDownload){
        self.downloads = datas
        self.batchDownload = batchDownload
        
        label.text = "\(currentCount)/\(self.downloads.count)"
        self.download()
    }
    
    var loadSure = false
    func download(){
        
        if(isCancel) {return}
        
        let download = downloads.object(at: currentCount) as! DownloadInfo
        
        label.text = "\(currentCount)/\(self.downloads.count)"
        
        currentCount += 1
        
        let receipt = MCDownloader.shared().downloadReceipt(forURLString: download.mp3url! as String)
        receipt?.setDownloaderProgressBlock({ (receivedSize:Int, expectedSize:Int, speed:Int, targetURL:URL?) in
            if(download.mp3url.isEqual(to: (targetURL?.absoluteString)!)){
                self.progress.progress = Float((Double(receivedSize) / 1024.0 / 1024) / (Double(expectedSize) / 1024.0 / 1024))
            }
        })
        
        self.loadSure = false
        MCDownloader.shared().downloadData(with: URL(string: download.mp3url as String), progress: { (receivedSize:Int, expectedSize:Int, speed:Int, targetURL:URL?) in
            
            
        }) { (receipt:MCDownloadReceipt?, error:Error?, finished:Bool) in
            
            if(self.loadSure) {return}
            self.loadSure = true
            
            if(error == nil){
                self.downloadLrc(download: download)
            }else{
                AppService.shared().showTip(tip: "下载失败,请重新尝试")
                self.batchDownload.table.reloadData()
                self.removeFromSuperview()
            }
        }
        
    }
    
    func downloadLrc(download:DownloadInfo){
        MCDownloader.shared().downloadData(with: URL(string: download.mp3lrc as String), progress: { (receivedSize:Int, expectedSize:Int, speed:Int, targetURL:URL?) in
            
        }) { (receipt:MCDownloadReceipt?, error:Error?, finished:Bool) in
            if(error == nil){
                self.comitDownload(download: download)
            }else{
                AppService.shared().showTip(tip: "下载失败,请重新尝试")
                self.batchDownload.table.reloadData()
                self.removeFromSuperview()
            }
        }
    }
    
    func comitDownload(download:DownloadInfo){
        let data = DownloadData()
        data.initDatas(id: download.id, mp3lrc: download.mp3lrc, mp3url: download.mp3url, title: download.title)
        if(!AppService.shared().findDownloadData(data: data)){
            AppService.shared().addDownload(data: data)
            
            if(self.currentCount == self.downloads.count){
                self.btn.setTitle("完成", for: .normal)
                self.progress.progress = 1
                self.downloadState = 1
                self.batchDownload.table.reloadData()
                self.label.text = "\(self.currentCount)/\(self.downloads.count)"
            }else{
                self.progress.progress = 0
                self.download()
                
            }
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        if(self.downloadState == 0){
            isCancel = true
        }
        self.removeFromSuperview()
    }
}
