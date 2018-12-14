//
//  SearchDetails.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/13.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class SearchDetails: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var searchStr:String!
    
    var searchDatas:NSMutableArray!
    
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = searchStr
        
        self.initRefresh()
    }
    
    func initRefresh(){
        self.table.delaysContentTouches = false
        
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的headerRereshing方法)
        
        self.table.bindHeadRefreshHandler({
            
            self.headerRereshing()
            
        }, themeColor: UIColor.white, refreshStyle: .animatableArrow)
        
        self.table.headRefreshControl.beginRefreshing()
        
        self.table.bindFootRefreshHandler({
            
            self.footerRereshing()
            
        }, themeColor: UIColor.white, refreshStyle: .animatableArrow)
        
        self.table.footRefreshControl.setAlertTextColor(UIColor.black)
        self.table.footRefreshControl.autoRefreshOnFoot = true
    }
    
    func headerRereshing(){
        
        self.page = 1
        
        let parameters = ["appid":"mryy","page":self.page] as [String : Any]
        
        HttpService.shared().post(urlLast: "api/search", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            self.searchDatas = ScrolInfo.mj_objectArray(withKeyValuesArray: obj)
            
            self.table.separatorStyle = .singleLine
            self.table.reloadData()
            
            self.table.headRefreshControl.endRefreshing()
            
            if(self.searchDatas.count < 20){
                self.table.footRefreshControl = nil
            }
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            self.table.headRefreshControl.endRefreshing()
        }
    }
    
    func footerRereshing(){
        
        self.page += 1
        
        let parameters = ["appid":"mryy","page":self.page] as [String : Any]
        
        HttpService.shared().post(urlLast: "api/search", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            let tempDatas = ScrolInfo.mj_objectArray(withKeyValuesArray: obj)
            self.searchDatas.addObjects(from: tempDatas as! [Any])
            
            if((tempDatas?.count)! < 20){
                self.table.footRefreshControl.endRefreshingAndNoLongerRefreshing(withAlertText: "已全部加载")
                self.table.reloadData()
            }else{
                self.table.footRefreshControl.endRefreshing(withAlertText: "加载完成", completion: {
                    self.table.reloadData()
                })
            }
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            self.table.footRefreshControl.endRefreshing()
        }
        
        
    }
    
    func loadSearchDatas(){
        
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchDetails: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchDatas != nil ? self.searchDatas.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let scrol = self.searchDatas.object(at: indexPath.row) as! ScrolInfo
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = scrol.title as String
        
        let name = cell.viewWithTag(2) as! UILabel
        name.text = scrol.pclassname as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.searchDatas.object(at: indexPath.row) as! ScrolInfo
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AudioDetails") as! AudioDetails
        vc.initModel(model: model)
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
}
