//
//  AlbumSort.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/3.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class AlbumSort: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var table: UITableView!
    var loadingView:EasyLoadingView!
    
    var albumDatas:NSArray!
    
    var singleWidth:CGFloat!
    var singleheight:CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.bounces = false
        
        singleWidth = screenSize.width / 4

        self.loadTableDatas()
    }
    
    func loadTableDatas(){
        
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        HttpService.shared().post(urlLast: "api/book", parameters: nil, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            self.albumDatas = AlbumInfo.mj_objectArray(withKeyValuesArray: obj)
            
            self.table.reloadData()
            
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumDatas != nil ? self.albumDatas.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let album = self.albumDatas.object(at: indexPath.row) as! AlbumInfo
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = album.classname! as String
        
        let buttonView = cell.viewWithTag(2)! as UIView
        
        for item in buttonView.subviews {
            if(item.isKind(of: UILabel.self)){
                item.removeFromSuperview()
            }
        }
        
        var i = 0
        
        for item in album.child {
            
            if((item as! AlbumChildInfo).classname == nil){
                continue
            }
            
            let x = CGFloat((i % 4)) * singleWidth
            let y = CGFloat((i / 4)) * singleheight
            
            let tempLabel = UILabel(frame: CGRect(x: x, y: y, width: singleWidth, height: singleheight))
            tempLabel.textAlignment = .center
            tempLabel.font = UIFont.systemFont(ofSize: 16)
            tempLabel.tag = 1000 + i
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(onButton))
            tempLabel.isUserInteractionEnabled = true
            tempLabel.addGestureRecognizer(tap)
            
            let length = (item as! AlbumChildInfo).classname.length >= 4 ? 4 : (item as! AlbumChildInfo).classname.length
            tempLabel.text = (item as! AlbumChildInfo).classname.substring(to: length)
            
            buttonView.addSubview(tempLabel)
            
            i += 1
        }
        
        return cell
    }
    
    @objc func onButton(tap:UIGestureRecognizer){
        
        let button = tap.view as! UILabel
        let cell = button.superview?.superview?.superview as! UITableViewCell
        
        let indexPath = self.table.indexPath(for: cell)
        
        let tempAlbum = self.albumDatas.object(at: (indexPath?.row)!) as! AlbumInfo
        
        let sb = UIStoryboard(name:"AlbumSort", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AlbumList") as! AlbumList
        vc.album = (tempAlbum.child.object(at: button.tag - 1000) as! AlbumChildInfo)
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let album = self.albumDatas.object(at: indexPath.row) as! AlbumInfo
        return CGFloat(((album.child.count - 1) / 4) + 1) * singleheight + 45
    }
}
