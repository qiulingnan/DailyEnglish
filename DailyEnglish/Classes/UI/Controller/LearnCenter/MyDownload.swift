//
//  MyDownload.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/4.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class MyDownload: UIViewController ,UITableViewDelegate,UITableViewDataSource{
   
    

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppService.shared().downloadDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let download = AppService.shared().downloadDatas.object(at: indexPath.row) as! DownloadData
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = download.title! as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let download = AppService.shared().downloadDatas.object(at: indexPath.row) as! DownloadData
        
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AudioDetails") as! AudioDetails
        vc.initDatas(id: download.id, title: download.title, mp3Url: download.mp3url, mp3lrcUrl: download.mp3lrc)
        AppService.shared().navigate.pushViewController(vc, animated: true)
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
        AppService.shared().removeDownload(index: indexPath.row)
        self.table.reloadData()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
