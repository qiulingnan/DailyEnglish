//
//  SpeedSpeech.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/2.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class SpeedSpeech: UIView ,UITableViewDelegate,UITableViewDataSource{
    
    let datas = ["0.5x","0.65x","0.8x","1.0x","1.2x","1.04x","1.6x","1.8x"]
    let speedDatas = [0.5,0.65,0.8,1.0,1.2,1.04,1.6,1.8]
    
    var details:AudioDetails!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = datas[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        details.resetSpeed(speed: Float(speedDatas[indexPath.row]),index: indexPath.row)
        self.removeFromSuperview()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}
