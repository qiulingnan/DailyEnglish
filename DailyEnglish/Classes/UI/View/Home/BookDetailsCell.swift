//
//  BookDetailsCell.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/1.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class BookDetailsCell: UITableViewCell {

    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var labelButton: QLNCustomButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabel1: UILabel!
    
    var book:BookListInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func updateDatas(){
        
        titleLabel.text = book.title! as String
        
        nameLabel.text = book.pclassname! as String
        nameLabel1.text = book.pclassname! as String
        
        let receipt = MCDownloader.shared().downloadReceipt(forURLString: book!.mp3url! as String)
        
        self.progress.progress = Float((receipt?.progress?.fractionCompleted)!)
        
        if((receipt?.progress?.isFinished)!){
            self.progress.progress = 0
            labelButton.isHidden = false
            downloadButton.isHidden = true
            nameLabel.isHidden = false
            nameLabel1.isHidden = true
        }else{
            labelButton.isHidden = true
            downloadButton.isHidden = false
            nameLabel.isHidden = true
            nameLabel1.isHidden = false
        }
            
        receipt?.setDownloaderProgressBlock({ (receivedSize:Int, expectedSize:Int, speed:Int, targetURL:URL?) in
            if(self.book.mp3url.isEqual(to: (targetURL?.absoluteString)!)){
                self.progress.progress = Float((Double(receivedSize) / 1024.0 / 1024) / (Double(expectedSize) / 1024.0 / 1024))
            }
        })

        receipt?.setDownloaderCompletedBlock({ (receipt:MCDownloadReceipt?, error:Error?, finished:Bool) in
            
            self.progress.progress = 0
            self.labelButton.isHidden = false
            self.downloadButton.isHidden = true
            self.nameLabel.isHidden = false
            self.nameLabel1.isHidden = true
            
            let data = DownloadData()
            data.initDatas(id: self.book.id, mp3lrc: self.book.mp3lrc, mp3url: self.book.mp3url, title: self.book.title)
            
            AppService.shared().addDownload(data: data)
        })
    }
    
    @IBAction func onDownload(_ sender: Any) {
        MCDownloader.shared().downloadData(with: URL(string: book!.mp3url as String), progress: { (receivedSize:Int, expectedSize:Int, speed:Int, targetURL:URL?) in
            
        }) { (receipt:MCDownloadReceipt?, error:Error?, finished:Bool) in

        }
        
        MCDownloader.shared().downloadData(with: URL(string: book!.mp3lrc as String), progress: { (receivedSize:Int, expectedSize:Int, speed:Int, targetURL:URL?) in
            
        }) { (receipt:MCDownloadReceipt?, error:Error?, finished:Bool) in

        }
    }
}
