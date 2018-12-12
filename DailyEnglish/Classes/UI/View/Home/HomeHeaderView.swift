//
//  HomeHeaderView.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/6.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit
import SDWebImage

class HomeHeaderView: UIView ,SDCycleScrollViewDelegate{
    
    var scrolInfos:NSArray!
    var newsInfos:NSArray!
    
    var newsInfo:HomeNewsInfo!
    
    var scrolHeight:CGFloat!
    var sortHeight:CGFloat!
    var newsHeight:CGFloat!
    
    var bannerBGView:UIView!
    var sortBGView:UIView!
    var newsBGView:UIView!
    
    func initData(sInfos:NSArray,nInfos:NSArray){
        
        self.scrolInfos = sInfos
        self.newsInfos = nInfos
        self.newsInfo = self.newsInfos.object(at: 0) as? HomeNewsInfo
        
        calculationHeight()
        initBanner()
        initSort()
        initNews()
        
        self.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        
    }
    
    func calculationHeight(){
        
        scrolHeight = (screenSize.width - 30) / 400 * 160
        sortHeight = screenSize.width / 430 * 105
        newsHeight = screenSize.width / 430 * 200
        
        let tempHeight =  scrolHeight + sortHeight + newsHeight
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height:tempHeight + 40)
    }
    
    func initNews(){
        newsBGView = UIView()
        newsBGView.backgroundColor = UIColor.white
        self.addSubview(newsBGView)
        _ = newsBGView.sd_layout()?.topSpaceToView(sortBGView,10)?.leftSpaceToView(self,0)?.rightSpaceToView(self,0)?.heightIs(newsHeight)
        
        let tempView = UIView()
        tempView.backgroundColor = bgColor
        newsBGView.addSubview(tempView)
        _ = tempView.sd_layout()?.topSpaceToView(newsBGView,5)?.leftSpaceToView(newsBGView,15)?.widthIs(4)?.heightIs(15)
        
        let title = UILabel()
        title.text = self.newsInfo.name! as String
        title.font = UIFont(name: fontStr1, size: 14)
        title.textColor = bgColor
        newsBGView.addSubview(title)
        _ = title.sd_layout()?.centerYEqualToView(tempView)?.leftSpaceToView(tempView,10)?.heightIs(20)
        title.setSingleLineAutoResizeWithMaxWidth(300)
        
        let overallWidth = screenSize.width
        let latticeWidth = overallWidth / 3
        let btnWidth = latticeWidth - 30
        
        var i:CGFloat = 0
        for item in self.newsInfo.content {
            let newsBtn = UIImageView()
            
            let bgView = UIView()
            newsBGView.addSubview(bgView)
            _ = bgView.sd_layout()?.leftSpaceToView(newsBGView,latticeWidth * i)?.widthIs(latticeWidth)?.topSpaceToView(title,0)?.bottomSpaceToView(newsBGView,0)
            
            let url = HttpService.shared().picUrlHead + ((item as! HomeNewsContentInfo).pic as String)
            newsBtn.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "bg_transparent"), options: .cacheMemoryOnly, completed: nil)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(onNews))
            newsBtn.isUserInteractionEnabled = true
            newsBtn.addGestureRecognizer(tap)
            newsBtn.tag = Int(1000 + i)
            bgView.addSubview(newsBtn)
            _ = newsBtn.sd_layout()?.centerXEqualToView(bgView)?.widthIs(btnWidth)?.topSpaceToView(bgView,5)?.bottomSpaceToView(bgView,20)
            
            let label = UILabel()
            label.text = (item as! HomeNewsContentInfo).name! as String
            label.font = UIFont(name: fontStr1, size: 12)
            bgView.addSubview(label)
            _ = label.sd_layout()?.centerXEqualToView(newsBtn)?.topSpaceToView(newsBtn,3)?.heightIs(14)
            label.setSingleLineAutoResizeWithMaxWidth(100)
            
            i += 1
        }
        
    }
    
    @objc func onNews(tap:UITapGestureRecognizer){
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BookDetails") as! BookDetails
        vc.bookInfo = self.newsInfo.content.object(at: tap.view!.tag - 1000) as? HomeNewsContentInfo
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    func initBanner(){
        
        bannerBGView = UIView()
        bannerBGView.backgroundColor = UIColor.white
        self.addSubview(bannerBGView)
        _ = bannerBGView.sd_layout()?.topSpaceToView(self,0)?.leftSpaceToView(self,0)?.rightSpaceToView(self,0)?.heightIs(scrolHeight+10)
        
        var paths = [String]()
        var titles = [String]()
        //获取网络数据轮播器
        for i in 0 ..< scrolInfos.count {
            if((scrolInfos.object(at: i) as! ScrolInfo).type == 0) {
                paths.append(HttpService.shared().picUrlHead + ((scrolInfos.object(at: i) as! ScrolInfo).pic as String))
            }else{
                paths.append((scrolInfos.object(at: i) as! ScrolInfo).pic as String)
            }
            
            titles.append(((scrolInfos.object(at: i) as! ScrolInfo).title as String))
        }
        
        if paths.count > 0 {
            //轮播器
            let cycleScrollView = SDCycleScrollView(frame: CGRect(x: 15, y: 0, width: screenSize.width - 30, height: scrolHeight))
            cycleScrollView.clearCache()
            cycleScrollView.imageURLStringsGroup = paths
            cycleScrollView.titlesGroup = titles
            cycleScrollView.pageControlBottomOffset = 20
            cycleScrollView.placeholderImage = UIImage(named: "bg_transparent")
            cycleScrollView.autoScrollTimeInterval = 3
            cycleScrollView.delegate = self
            
            cycleScrollView.layer.masksToBounds = true
            cycleScrollView.layer.cornerRadius = 5.0

            if(paths.count == 1){
                cycleScrollView.showPageControl = false
                cycleScrollView.autoScroll = false
            }

            bannerBGView.addSubview(cycleScrollView)
            
        }
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let model = self.scrolInfos.object(at: index) as! ScrolInfo
        
        if(model.type == 1){
            
            let vc = ADWeb()
            vc.url_string = model.mp3url! as String
            AppService.shared().navigate.pushViewController(vc, animated: true)
            
        }else if(model.type == 0){
            
            let sb = UIStoryboard(name:"Home", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "AudioDetails") as! AudioDetails
            vc.initModel(model: model)
            AppService.shared().navigate.pushViewController(vc, animated: true)
        }
    }
    
    @objc func onSort(){
        AppService.shared().mainTabbar.turnView(index: 1)
        
    }
    
    @objc func onEssence(){
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Essence") as! Essence
        vc.books = self.newsInfos
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    @objc func onGame(){
        let loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        HttpService.shared().post(urlLast: "api/games", parameters: nil, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            let dict = obj?.mj_keyValues()
            
            let vc = ADWeb()
            vc.url_string = (dict?.object(forKey: "url") as! String)
            AppService.shared().navigate.pushViewController(vc, animated: true)
            
            EasyLoadingView.hidenLoading(loadingView)
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(loadingView)
        }
    }
    
    @objc func onDay(){
        if(AppService.shared().checkLogin()){
            let dateStr = NSString.getNowTime()
            
            let arr = dateStr?.components(separatedBy: "-")
            
            let year = (arr![0] as NSString).intValue
            let month = (arr![1] as NSString).intValue
            let day = (arr![2] as NSString).intValue
            
            var dateStr1 = "\(String(describing: year))-\(String(describing: month))-\(String(describing: day))"
            if(day < 10){
                dateStr1 = "\(String(describing: year))-\(String(describing: month))-0\(String(describing: day))"
            }
            
            let sb = UIStoryboard(name:"Personal", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SignIn") as!  SignIn
            vc.initDatas(year: Int(year), month: Int(month), day: Int(day),dateStr: dateStr1,isToday: true)
            AppService.shared().navigate.pushViewController(vc, animated: true)
        }
    }
    
    func initSort(){
        sortBGView = UIView()
        sortBGView.backgroundColor = UIColor.white
        self.addSubview(sortBGView)
        _ = sortBGView.sd_layout()?.topSpaceToView(bannerBGView,10)?.leftSpaceToView(self,0)?.rightSpaceToView(self,0)?.heightIs(sortHeight)
        
        let overallWidth = screenSize.width
        let latticeWidth = overallWidth * 0.25
        let btnWidth = (latticeWidth - 30) * 0.75
        
        let btnY = sortHeight / 2 - btnWidth / 2 - 10
        
        let sortBtn = UIButton(frame: CGRect(x: overallWidth * 0.25 - latticeWidth / 2 - btnWidth / 2, y: btnY, width: btnWidth, height: btnWidth))
        sortBtn.setImage(UIImage(named: "home_category"), for: .normal)
        sortBGView.addSubview(sortBtn)
        sortBtn.addTarget(self, action: #selector(onSort), for: .touchUpInside)
        
        let sortLabel = UILabel()
        sortBGView.addSubview(sortLabel)
        sortLabel.text = "分类"
        _ = sortLabel.sd_layout()?.topSpaceToView(sortBtn,5)?.centerXEqualToView(sortBtn)?.heightIs(18)
        sortLabel.setSingleLineAutoResizeWithMaxWidth(100)
        
        let essenceBtn = UIButton(frame: CGRect(x: overallWidth * 0.5 - latticeWidth / 2 - btnWidth / 2, y: btnY, width: btnWidth, height: btnWidth))
        essenceBtn.setImage(UIImage(named: "iv_home_activity"), for: .normal)
        sortBGView.addSubview(essenceBtn)
        essenceBtn.addTarget(self, action: #selector(onEssence), for: .touchUpInside)
        
        let essenceLabel = UILabel()
        sortBGView.addSubview(essenceLabel)
        essenceLabel.text = "精华"
        _ = essenceLabel.sd_layout()?.topSpaceToView(essenceBtn,5)?.centerXEqualToView(essenceBtn)?.heightIs(18)
        essenceLabel.setSingleLineAutoResizeWithMaxWidth(100)
        
        let gameBtn = UIButton(frame: CGRect(x: overallWidth * 0.75 - latticeWidth / 2 - btnWidth / 2, y: btnY, width: btnWidth, height: btnWidth))
        gameBtn.setImage(UIImage(named: "home_game"), for: .normal)
        sortBGView.addSubview(gameBtn)
        gameBtn.addTarget(self, action: #selector(onGame), for: .touchUpInside)
        
        let gameLabel = UILabel()
        sortBGView.addSubview(gameLabel)
        gameLabel.text = "小游戏"
        _ = gameLabel.sd_layout()?.topSpaceToView(gameBtn,5)?.centerXEqualToView(gameBtn)?.heightIs(18)
        gameLabel.setSingleLineAutoResizeWithMaxWidth(100)
        
        let readBtn = UIButton(frame: CGRect(x: overallWidth - latticeWidth / 2 - btnWidth / 2, y: btnY, width: btnWidth, height: btnWidth))
        readBtn.setImage(UIImage(named: "sign"), for: .normal)
        readBtn.addTarget(self, action: #selector(onDay), for: .touchUpInside)
        sortBGView.addSubview(readBtn)

        let readLabel = UILabel()
        sortBGView.addSubview(readLabel)
        readLabel.text = "每日一读"
        _ = readLabel.sd_layout()?.topSpaceToView(readBtn,5)?.centerXEqualToView(readBtn)?.heightIs(18)
        readLabel.setSingleLineAutoResizeWithMaxWidth(100)
    }
    
}
