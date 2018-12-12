//
//  TotalScore.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/8.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class TotalScore: UIView {
    
    @objc public var tableView: UITableView!
    
    var type = 0
    var page = 2
    var datas = NSMutableArray()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView(frame: frame, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.bounces = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        addSubview(tableView)
        _ = tableView.sd_layout()?.leftSpaceToView(self,0)?.rightSpaceToView(self,0)?.topSpaceToView(self,0)?.bottomSpaceToView(self,0)
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        super.willMove(toSuperview: newSuperview)
        
        if(newSuperview != nil){
            self.tableView.delaysContentTouches = false
            
            // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的headerRereshing方法)
            self.tableView.bindFootRefreshHandler({
                
                self.footerRereshing()
                
            }, themeColor: UIColor.white, refreshStyle: .animatableArrow)
            
            self.tableView.footRefreshControl.setAlertTextColor(UIColor.black)
            self.tableView.footRefreshControl.autoRefreshOnFoot = true
        }
    }
    
    func footerRereshing(){
        
        let parameters = ["appid":"mryy","p":self.page] as [String : Any]
        
        var urlLast = "userCheck/rankingAll"
        if(self.type == 1){
            urlLast = "userCheck/rankingAvg"
        }
        
        HttpService.shared().post(urlLast: urlLast, parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            let tempDatas = ScoreInfo.mj_objectArray(withKeyValuesArray: obj)
            
            self.datas.addObjects(from: tempDatas as! [Any])
            
            self.page += 1
            self.tableView.footRefreshControl.endRefreshing(withAlertText: "加载完成", completion: {
                self.tableView.reloadData()
            })
            
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            
            self.tableView.footRefreshControl.endRefreshing()
        }
    }
}

extension TotalScore:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        for item in cell.contentView.subviews {
            item.removeFromSuperview()
        }
        
        let score = self.datas.object(at: indexPath.row) as! ScoreInfo
        
        let indexLabel = UILabel()
        indexLabel.text = "\(indexPath.row + 1)"
        indexLabel.font = UIFont.systemFont(ofSize: 20)
        indexLabel.textAlignment = .center
        indexLabel.textColor = UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1)
        cell.contentView.addSubview(indexLabel)
        _ = indexLabel.sd_layout()?.leftSpaceToView(cell.contentView,30)?.centerYEqualToView(cell.contentView)?.widthIs(30)?.heightIs(40)
        
        if(indexPath.row < 3){
            let img = UIImageView(image: UIImage(named: "order_\(indexPath.row + 1)"))
            img.contentMode = .scaleAspectFit
            cell.contentView.addSubview(img)
            _ = img.sd_layout()?.leftSpaceToView(cell.contentView,30)?.centerYEqualToView(cell.contentView)?.widthIs(30)?.heightIs(40)
            
        }
        
        let scoreLabel = UILabel()
        
        if(type == 0){
            scoreLabel.text =  "\(String(describing: score.total!))分"
        }else{
            scoreLabel.text =  "\(String(describing: score.avg!))分"
        }
        
        scoreLabel.font = UIFont.systemFont(ofSize: 20)
        scoreLabel.textColor = UIColor.red
        cell.contentView.addSubview(scoreLabel)
        _ = scoreLabel.sd_layout()?.rightSpaceToView(cell.contentView,30)?.centerYEqualToView(cell.contentView)?.heightIs(40)
        scoreLabel.setSingleLineAutoResizeWithMaxWidth(150)
        
        let name = UILabel()
        name.text = score.username as String
        name.font = UIFont.systemFont(ofSize: 20)
        name.textColor =  UIColor(red: 100/255.0, green: 100/255.0, blue: 100/255.0, alpha: 1)
        cell.contentView.addSubview(name)
        _ = name.sd_layout()?.rightSpaceToView(scoreLabel,15)?.centerYEqualToView(cell.contentView)?.heightIs(40)?.leftSpaceToView(indexLabel,20)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset
        if (offset.y <= 0) {
            offset.y = 0
        }
        scrollView.contentOffset = offset
    }
    
}

extension TotalScore:JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return self
    }
    
    func listScrollView() -> UIScrollView {
        return self.tableView
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        
    }
    
}
