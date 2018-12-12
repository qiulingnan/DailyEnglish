//
//  BookDetails.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/22.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class BookDetails: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    @IBOutlet weak var navigateTitle: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var subscriptionBtn: UIButton!
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var table: UITableView!
    
    var bookInfo:HomeNewsContentInfo!
    
    var adInfo:ADInfo!
    
    var bookLists:NSMutableArray!
    
    var isSubscription = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initHearder()
        self.initRefresh()

        self.loadADData()
        self.loadTableDatas()
        
    }
    
    func initBookInfo(album:AlbumListInfo){
        
        bookInfo = HomeNewsContentInfo()
        bookInfo.cid = album.cid
        bookInfo.intro = album.intro
        bookInfo.name = album.name
        bookInfo.par = album.par
        bookInfo.pic = album.pic
        
    }
    
    func initRefresh(){
        self.table.delaysContentTouches = false
        
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的headerRereshing方法)
        
        self.table.bindFootRefreshHandler({
            
            self.footerRereshing()
            
        }, themeColor: UIColor.white, refreshStyle: .animatableArrow)
        
        self.table.footRefreshControl.setAlertTextColor(UIColor.black)
        self.table.footRefreshControl.autoRefreshOnFoot = true
    }
    
    func footerRereshing(){
        
        if(self.bookLists == nil){
            self.loadTableDatas()
            return
        }
        
        let lastId = (self.bookLists.lastObject as! BookListInfo).id.intValue
        
        let parameters = ["lastid":lastId,"cid":bookInfo.cid] as [String : Any]
        
        HttpService.shared().post(urlLast: "api/lists", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            let tempDatas = BookListInfo.mj_objectArray(withKeyValuesArray: obj)
            
            self.bookLists.addObjects(from: tempDatas as! [Any])
            
            if((tempDatas?.count)! < 10){
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
    
    func initHearder(){
        
        let url = HttpService.shared().picUrlHead + (bookInfo.pic as String)
        bookImage!.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "bg_transparent"), options: .cacheMemoryOnly, completed: nil)
        
        navigateTitle.text = bookInfo.name! as String
        titleLabel.text = bookInfo.name! as String
        contentLabel.text = bookInfo.intro! as String
        
        if(AppService.shared().findSubscriptionData(data: bookInfo)){
            subscriptionBtn.setTitle("已订阅", for: .normal)
            isSubscription = true
        }
    }
    
    func loadTableDatas(){
        let parameters = ["cid":bookInfo.cid] as [String : Any]
        
        HttpService.shared().post(urlLast: "api/lists", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            self.bookLists = BookListInfo.mj_objectArray(withKeyValuesArray: obj)
            
            self.table.separatorStyle = .singleLine
            self.table.reloadData()
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            
        }
    }

    func loadADData(){
        let parameters = ["section":16,"appid":"mryy"] as [String : Any]

        HttpService.shared().post(urlLast: "ad", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in

            self.adInfo = ADInfo.mj_object(withKeyValues: obj)
            
            self.adImage.sd_setImage(with: URL(string: self.adInfo.imgSrc as String), placeholderImage: UIImage(named: "bg_transparent"), options: .cacheMemoryOnly, completed: nil)
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.onAD))
            self.adImage.isUserInteractionEnabled = true
            self.adImage.addGestureRecognizer(tap)

        }) { (task:URLSessionDataTask?, error:NSError?) in
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookLists != nil ? bookLists.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookDetailsCell
        
        cell.book = (bookLists.object(at: indexPath.row) as! BookListInfo)
        
        cell.updateDatas()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = UIView()
        sectionHeader.backgroundColor = UIColor.white
        
        let title = UILabel()
        title.text = bookInfo.name! as String
        title.font = UIFont(name: fontStr1, size: 18)
        title.textColor = bgColor
        sectionHeader.addSubview(title)
        _ = title.sd_layout()?.centerYEqualToView(sectionHeader)?.centerXEqualToView(sectionHeader)?.heightIs(20)
        title.setSingleLineAutoResizeWithMaxWidth(300)
        
        let line = UIView()
        line.backgroundColor = bgColor
        sectionHeader.addSubview(line)
        _ = line.sd_layout()?.leftSpaceToView(sectionHeader,0)?.bottomSpaceToView(sectionHeader,0)?.rightSpaceToView(sectionHeader,0)?.heightIs(2)
        
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let book = self.bookLists.object(at: indexPath.row) as! BookListInfo
        
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AudioDetails") as! AudioDetails
        vc.initDatas(id: book.id, title: book.title, mp3Url:  book.mp3url, mp3lrcUrl: book.mp3lrc)
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset
        if (offset.y <= 0) {
            offset.y = 0
        }
        scrollView.contentOffset = offset
    }
    
    @objc func onAD(gesture:UITapGestureRecognizer){
        let vc = ADWeb()
        vc.url_string = adInfo.toUrl! as String
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSubscription(_ sender: Any) {
        
        isSubscription = !isSubscription
        
        if(isSubscription){
            subscriptionBtn.setTitle("已订阅", for: .normal)
            
            bookInfo.subscriptionTime = TimeUtil.stringFormCurrentTime() as NSString
            AppService.shared().addSubscription(data: bookInfo)
            
        }else{
            subscriptionBtn.setTitle("添加订阅", for: .normal)
            
            AppService.shared().removeSubscription(data: bookInfo)
        }
    }
    
    @IBAction func onBatch(_ sender: Any) {
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BatchDownload") as! BatchDownload
        
        vc.bookInfo = self.bookInfo
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
