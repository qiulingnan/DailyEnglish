//
//  LearnCenter.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/3.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class LearnCenter: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppService.shared().subscriptionDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let subscription = AppService.shared().subscriptionDatas.object(at: indexPath.row) as! HomeNewsContentInfo
        
        let img = cell.viewWithTag(1) as! UIImageView
        let url = HttpService.shared().picUrlHead + (subscription.pic as String)
        img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "bg_transparent"), options: .cacheMemoryOnly, completed: nil)
        
        let title = cell.viewWithTag(2) as! UILabel
        title.text = subscription.name as String
        
        let time = cell.viewWithTag(3) as! UILabel
        time.text = subscription.subscriptionTime as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BookDetails") as! BookDetails
        vc.bookInfo = (AppService.shared().subscriptionDatas.object(at: indexPath.row) as! HomeNewsContentInfo)
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBookNet(_ sender: Any) {
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BookNet")
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    @IBAction func onCollect(_ sender: Any) {
        let sb = UIStoryboard(name:"LearnCenter", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MyCollect")
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    @IBAction func onDownload(_ sender: Any) {
        let sb = UIStoryboard(name:"LearnCenter", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "MyDownload")
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    @IBAction func onReward(_ sender: Any) {
        let sb = UIStoryboard(name:"LearnCenter", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RewardRanking")
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
}
