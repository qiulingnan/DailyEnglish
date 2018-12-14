//
//  DailyRecommendation.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/6.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class DailyRecommendation: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var table: UITableView!
    
    var scrolInfos:NSArray!
    var newsInfos:NSArray!
    
    var tableDatas:NSMutableArray!
    var lastId = 0 // 记录获取到的数据最后一个的id
    
    var loadingView:EasyLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.isHidden = true
        
        self.table.dataSource = self
        self.table.delegate = self
        
        loadScrolData()
        
        initRefresh()
        headerRereshing()
        
        if #available(iOS 11.0, *) {
            table.estimatedRowHeight = 0
            table.estimatedSectionFooterHeight = 0
            table.estimatedSectionHeaderHeight = 0
            table.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
    }
    
    func loadScrolData(){
        
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        let parameters = ["adType":1]
        HttpService.shared().post(urlLast: "api/carousel", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            self.scrolInfos = ScrolInfo.mj_objectArray(withKeyValuesArray: obj)
            self.loadAdData()
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }
    }
    
    func loadAdData(){
        HttpService.shared().post(urlLast: "api/recommend", parameters: nil, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            self.newsInfos = HomeNewsInfo.mj_objectArray(withKeyValuesArray: obj)
            
            let header = HomeHeaderView()
            header.initData(sInfos: self.scrolInfos, nInfos: self.newsInfos)
            self.table.tableHeaderView = header
            
            self.table.isHidden = false
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }
    }
    
    func initRefresh(){
        self.table.delaysContentTouches = false

        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的headerRereshing方法)
        
        self.table.bindHeadRefreshHandler({
            
            self.headerRereshing()
            
        }, themeColor: UIColor.white, refreshStyle: .animatableArrow)
        
        self.table.bindFootRefreshHandler({
            
            self.footerRereshing()
            
        }, themeColor: UIColor.white, refreshStyle: .animatableArrow)
        
        self.table.footRefreshControl.setAlertTextColor(UIColor.black)
        self.table.footRefreshControl.autoRefreshOnFoot = true
    }
    
    func headerRereshing(){
        
        let parameters = ["adType":1]
        
        HttpService.shared().post(urlLast: "api/pages", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            self.tableDatas = HomeTableInfo.mj_objectArray(withKeyValuesArray: obj)
            
            self.table.headRefreshControl.endRefreshing()
            
            self.table.reloadData()
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            
            self.table.headRefreshControl.endRefreshing()
        }
    }
    
    func footerRereshing(){
        
        if(self.tableDatas == nil){
            self.headerRereshing()
            return
        }
        
        self.lastId = (self.tableDatas.lastObject as! HomeTableInfo).id.intValue

        let parameters = ["adType":1,"lastid":self.lastId]
        
        HttpService.shared().post(urlLast: "api/pages", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            let tempDatas = HomeTableInfo.mj_objectArray(withKeyValuesArray: obj)
            
            self.tableDatas.addObjects(from: tempDatas as! [Any])
            
            self.table.footRefreshControl.endRefreshing(withAlertText: "加载完成", completion: {
                self.table.reloadData()
            })
            
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            
            self.table.footRefreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let sectionHeader = UIView()
        
        let tempView = UIView()
        tempView.backgroundColor = bgColor
        sectionHeader.addSubview(tempView)
        _ = tempView.sd_layout()?.topSpaceToView(sectionHeader,5)?.leftSpaceToView(sectionHeader,15)?.widthIs(4)?.heightIs(15)
        
        let title = UILabel()
        title.text = "每日英语"
        title.font = UIFont(name: fontStr1, size: 14)
        title.textColor = bgColor
        sectionHeader.addSubview(title)
        _ = title.sd_layout()?.centerYEqualToView(tempView)?.leftSpaceToView(tempView,10)?.heightIs(20)
        title.setSingleLineAutoResizeWithMaxWidth(300)


        return sectionHeader
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDatas != nil ? self.tableDatas.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let tableInfo = self.tableDatas.object(at: indexPath.row) as! HomeTableInfo
        
        let titleLabel = cell.viewWithTag(1) as! UILabel
        titleLabel.text = tableInfo.title! as String
        
        let contentLabel = cell.viewWithTag(2) as! UILabel
        contentLabel.text = tableInfo.small_text! as String
        
        let typeLabel = cell.viewWithTag(4) as! UILabel
        typeLabel.layer.masksToBounds = true
        typeLabel.layer.cornerRadius = 3.0
        typeLabel.layer.borderWidth = 1
        typeLabel.layer.borderColor = UIColor(red: 70/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1).cgColor
        typeLabel.text = "广告"
        typeLabel.textColor = UIColor(red: 70/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1)
        
        let imageView = cell.viewWithTag(3) as! UIImageView
        var url = tableInfo.pic as String
        if(tableInfo.id != 0){
            url = HttpService.shared().picUrlHead + (tableInfo.pic as String)
            typeLabel.text = "推荐"
            typeLabel.textColor = UIColor(red: 224/255.0, green: 159/255.0, blue: 152/255.0, alpha: 1)
            typeLabel.layer.borderColor = UIColor(red: 224/255.0, green: 159/255.0, blue: 152/255.0, alpha: 1).cgColor
        }
        imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "bg_transparent"), options: .cacheMemoryOnly, completed: nil)
        
        let nameLabel = cell.viewWithTag(5) as! UILabel
        nameLabel.text = tableInfo.pclassname! as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableInfo = self.tableDatas.object(at: indexPath.row) as! HomeTableInfo
        
        if(tableInfo.id != 0){
            let sb = UIStoryboard(name:"Home", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "AudioDetails") as! AudioDetails
            vc.initDatas(id: tableInfo.id, title: tableInfo.title, mp3Url: tableInfo.mp3url, mp3lrcUrl: tableInfo.mp3lrc)
            AppService.shared().navigate.pushViewController(vc, animated: true)
        }else{
            let vc = ADWeb()
            vc.url_string = tableInfo.mp3url! as String
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    //处理section header悬停
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.table! {
            let sectionHeaderHeight = CGFloat(45.0)//headerView的高度
            if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {

                scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0);

            } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {

//                scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0);
            }
        }
    }
    
    @IBAction func onSearch(_ sender: Any) {
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Search")
        let temp = vc.view as! Search
        temp.initData()
        self.view.addSubview(temp)
    }
}
