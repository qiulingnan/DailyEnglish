//
//  NewReward.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/6.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class NewReward: UIView {
    @objc public var tableView: UITableView!
    
    var datas = NSArray()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView(frame: frame, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        addSubview(tableView)
        _ = tableView.sd_layout()?.leftSpaceToView(self,0)?.rightSpaceToView(self,0)?.topSpaceToView(self,0)?.bottomSpaceToView(self,0)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension NewReward:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        for item in cell.contentView.subviews {
            item.removeFromSuperview()
        }
        
        let reward = self.datas.object(at: indexPath.row) as! RewardInfo
        
        let name = UILabel()
        name.text = reward.nick! as String
        name.font = UIFont.systemFont(ofSize: 22)
        name.textColor = UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1)
        cell.contentView.addSubview(name)
        _ = name.sd_layout()?.leftSpaceToView(cell.contentView,15)?.centerYEqualToView(cell.contentView)?.heightIs(30)?.widthIs(150)
        
        let total = UILabel()
        total.text = "\(String(describing: reward.total!))元"
        total.font = UIFont.systemFont(ofSize: 22)
        total.textColor = UIColor.red
        total.textAlignment = .right
        cell.contentView.addSubview(total)
        _ = total.sd_layout()?.rightSpaceToView(cell.contentView,15)?.centerYEqualToView(cell.contentView)?.heightIs(30)?.widthIs(150)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension NewReward:JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self
    }
    
    func listScrollView() -> UIScrollView {
        return self.tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        
    }
    
}
