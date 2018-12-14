//
//  ScoreDetails.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/11.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class ScoreDetails: UIView {

    @IBOutlet weak var table: UITableView!
    
    var data:Evaluation!
    
    @IBAction func onShare(_ sender: Any) {
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Share")
        let share = vc.view as! Share
        share.shareType = .AudioDetails
        share.shareTitle = "我得了\(Int(data.total_score.doubleValue * 20))分！！"
        share._des = "我读了\(Int(data.total_score.doubleValue * 20))分，超厉害的呢！快来试试吧~~"
        share.initDatas()
        self.addSubview(share)
    
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.removeFromSuperview()
    }
}

extension ScoreDetails:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.word.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let word = self.data.word.object(at: indexPath.row) as! EvaluationWord
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = word.content as String
        
        let score = cell.viewWithTag(2) as! UILabel
        if(word.total_score != nil){
            score.text = "\(Int(word.total_score.doubleValue * 20.0))分"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
