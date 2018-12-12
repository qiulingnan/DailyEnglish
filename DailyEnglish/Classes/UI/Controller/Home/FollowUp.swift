//
//  FollowUp.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/13.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class FollowUp: UIViewController {

    @IBOutlet weak var navigateTitle: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var id:NSNumber!
    var titleStr:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigateTitle.text = self.titleStr

    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FollowUp :UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
}
