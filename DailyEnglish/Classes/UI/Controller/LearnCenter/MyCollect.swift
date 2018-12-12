//
//  MyCollect.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/4.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class MyCollect: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppService.shared().collectDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let collect = AppService.shared().collectDatas.object(at: indexPath.row) as! CollectData
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = collect.title! as String
        
        let time = cell.viewWithTag(2) as! UILabel
        time.text = collect.time! as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
        AppService.shared().removeCollect(index: indexPath.row)
        self.table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collect = AppService.shared().collectDatas.object(at: indexPath.row) as! CollectData
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AudioDetails") as! AudioDetails
        vc.initDatas(id: collect.id, title: collect.title, mp3Url: collect.mp3Url, mp3lrcUrl: collect.lrcUrl)
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
