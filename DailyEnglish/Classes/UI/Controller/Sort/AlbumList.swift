//
//  AlbumList.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/3.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class AlbumList: UIViewController ,UITableViewDelegate,UITableViewDataSource{
   
    @IBOutlet weak var table: UITableView!
    
    var album:AlbumChildInfo!
    
    var loadingView:EasyLoadingView!
    
    var albumListDatas:NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.bounces = false

        self.loadTableData()
    }
    
    func loadTableData(){
        let parameters = ["cid":album.classid] as [String : Any]
        
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        HttpService.shared().post(urlLast: "api/classlist", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            self.albumListDatas = AlbumListInfo.mj_objectArray(withKeyValuesArray: obj)
            self.table.reloadData()
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumListDatas != nil ? self.albumListDatas.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let albumList = self.albumListDatas.object(at: indexPath.row) as! AlbumListInfo
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let url = HttpService.shared().picUrlHead + (albumList.pic as String)
        imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "bg_transparent"), options: .cacheMemoryOnly, completed: nil)
        
        let titleLabel = cell.viewWithTag(2) as! UILabel
        titleLabel.text = albumList.name! as String
        
        let contentLabel = cell.viewWithTag(3) as! UILabel
        contentLabel.text = albumList.intro! as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let albumList = self.albumListDatas.object(at: indexPath.row) as! AlbumListInfo
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BookDetails") as! BookDetails
        vc.initBookInfo(album: albumList)
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
