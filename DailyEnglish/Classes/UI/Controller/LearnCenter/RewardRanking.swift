//
//  RewardRanking.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/5.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class RewardRanking: UIViewController {
    
    var pagingView: JXPagingView!
    var header: UIView!
    var HeaderHeight: Int = 200
    var headerTitleHeight: Int = 50
    var listViewArray: [JXPagingViewListViewDelegate]!
    var categoryView: JXCategoryTitleView!
    var titles = ["打赏排行", "最新打赏"]
    var loadingView:EasyLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listViewArray = preferredListViewsArray()
        
        self.preferredHeader()
        self.preferredCategory()
        
        pagingView = preferredPagingView()
        pagingView.backgroundColor = UIColor.black
        pagingView.mainTableView.bounces = false
//        pagingView.mainTableView.gestureDelegate = self
        pagingView.frame = CGRect(x: 0, y: 20, width: screenSize.width, height: screenSize.height - 20)
        self.view.addSubview(pagingView)
        
        categoryView.contentScrollView = pagingView.listContainerView.collectionView
        
        //扣边返回处理，下面的代码要加上
        pagingView.listContainerView.collectionView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.loadRankingDatas()
    }
    
    func loadRankingDatas(){
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        let parameters = ["list_type":"sort"]
        HttpService.shared().post(urlLast: "trade/rewardlists", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            let ranking = self.listViewArray[0] as! Ranking
            ranking.datas = RewardInfo.mj_objectArray(withKeyValuesArray: obj)
            ranking.tableView.separatorStyle = .singleLine
            ranking.tableView.reloadData()
            
            self.loadNewDatas()
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }
    }
    
    func loadNewDatas(){
        let parameters = ["list_type":"new"]
        HttpService.shared().post(urlLast: "trade/rewardlists", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            let news = self.listViewArray[1] as! NewReward
            news.datas = RewardInfo.mj_objectArray(withKeyValuesArray: obj)
            news.tableView.reloadData()
            
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }
    }
    
    func preferredHeader() {
        
        header = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: CGFloat(HeaderHeight)))
        header.backgroundColor = bgColor
        
        let backBtn = UIButton()
        let img = UIImage(named: "btn_back_normal")
        backBtn.setImage(img, for: .normal)
        backBtn.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        header.addSubview(backBtn)
        _ = backBtn.sd_layout()?.leftSpaceToView(header,15)?.topSpaceToView(header,10)?.widthIs((img?.size.width)!)?.heightIs((img?.size.height)!)
        
        let navTitle = UILabel()
        navTitle.text = "打赏支持"
        navTitle.textAlignment = .center
        header.addSubview(navTitle)
        _ = navTitle.sd_layout()?.centerXEqualToView(header)?.topSpaceToView(header,10)?.widthIs(200)?.heightIs(20)
        
        let btn = UIButton()
        let image = UIImage(named: "reward_bg_big")
        btn.setBackgroundImage(image, for: .normal)
        btn.addTarget(self, action: #selector(onReward), for: .touchUpInside)
        header.addSubview(btn)
        _ = btn.sd_layout()?.centerXEqualToView(header)?.topSpaceToView(navTitle,20)?.widthIs((image?.size.width)!)?.heightIs((image?.size.height)!)
        
    }
    
    @objc func onReward(){
        let sb = UIStoryboard(name:"LearnCenter", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RewardPay")
        let tempView = vc.view as! RewardPay
        tempView.initDatas()
        self.view.addSubview(tempView)
    }
    
    @objc func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func preferredCategory(){
        categoryView = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(headerTitleHeight)))
        categoryView.titles = titles
        categoryView.backgroundColor = UIColor.white
        categoryView.titleSelectedColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        categoryView.titleColor = UIColor.black
        categoryView.titleColorGradientEnabled = true
        categoryView.titleLabelZoomEnabled = true
        
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorLineViewColor = UIColor(red: 105/255, green: 144/255, blue: 239/255, alpha: 1)
        lineView.indicatorLineWidth = 80
        categoryView.indicators = [lineView]
        
        let lineWidth = 1/UIScreen.main.scale
        let lineLayer = CALayer()
        lineLayer.backgroundColor = UIColor.lightGray.cgColor
        lineLayer.frame = CGRect(x: 0, y: categoryView.bounds.height - lineWidth, width: categoryView.bounds.width, height: lineWidth)
        categoryView.layer.addSublayer(lineLayer)
    }
    
    func preferredPagingView() -> JXPagingView {
        return JXPagingView(delegate: self)
    }
    
    func preferredListViewsArray() -> [JXPagingViewListViewDelegate] {
        
        let view1 = Ranking()
        
        let view2 = NewReward()
        
        return [view1, view2]
    }
}

extension RewardRanking:JXPagingViewDelegate {
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return HeaderHeight
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return header
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return headerTitleHeight
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return categoryView
    }
    
    func listViews(in pagingView: JXPagingView) -> [JXPagingViewListViewDelegate] {
        return listViewArray
    }
    
}
