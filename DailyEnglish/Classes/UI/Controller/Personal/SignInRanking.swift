//
//  SignInRanking.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/8.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class SignInRanking: UIViewController {
    
    var pagingView: JXPagingView!
    var header: UIView!
    var HeaderHeight: Int = 200
    var headerTitleHeight: Int = 50
    var listViewArray: [JXPagingViewListViewDelegate]!
    var categoryView: JXCategoryTitleView!
    var titles = ["总积分排好", "平均分排行"]
    var loadingView:EasyLoadingView!
    var score:UILabel!
    
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
        
        self.loadScore()
    }
    
    func preferredHeader() {
        
        header = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: CGFloat(HeaderHeight)))
        header.backgroundColor = UIColor(red: 53/255, green: 138/255, blue: 249/255, alpha: 1)
        
        let backBtn = UIButton()
        let img = UIImage(named: "btn_back_normal")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        backBtn.tintColor = UIColor.white
        backBtn.setImage(img, for: .normal)
        backBtn.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        header.addSubview(backBtn)
        _ = backBtn.sd_layout()?.leftSpaceToView(header,15)?.topSpaceToView(header,10)?.widthIs((img.size.width))?.heightIs((img.size.height))
        
        let navTitle = UILabel()
        navTitle.text = "签到积分榜"
        navTitle.textColor = UIColor.white
        navTitle.textAlignment = .center
        header.addSubview(navTitle)
        _ = navTitle.sd_layout()?.centerXEqualToView(header)?.topSpaceToView(header,10)?.widthIs(200)?.heightIs(20)
        
        let bgImg = UIImageView(image: UIImage(named: "iv_tianti"))
        bgImg.contentMode = .scaleAspectFit
        header.addSubview(bgImg)
        _ = bgImg.sd_layout()?.topSpaceToView(navTitle,15)?.bottomSpaceToView(header,0)?.leftSpaceToView(header,0)?.rightSpaceToView(header,0)
        
        let title = UILabel()
        title.text = "小e签到天梯积分榜"
        title.textColor = UIColor.white
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 20)
        header.addSubview(title)
        _ = title.sd_layout()?.centerYEqualToView(bgImg)?.leftSpaceToView(header,15)?.widthIs(180)?.heightIs(30)
        
        score = UILabel()
        score.text = "总平均分:0"
        score.textColor = UIColor.white
        score.textAlignment = .center
        score.font = UIFont.systemFont(ofSize: 18)
        header.addSubview(score)
        _ = score.sd_layout()?.centerXEqualToView(title)?.topSpaceToView(title,5)?.widthIs(200)?.heightIs(30)
    }
    
    func loadScore(){
        let parameters = ["appid":"mryy"]
        
        loadingView = EasyLoadingView.showLoadingText("") { () -> EasyLoadingConfig? in
            
            let config = EasyLoadingConfig.shared()
            config.showOnWindow = true
            config.tintColor = netColor
            config.superReceiveEvent = false
            return config
        }
        
        HttpService.shared().post(urlLast: "userCheck/scoreAvg", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            let arr = obj as! NSArray
            
            if(arr.count > 0){
                let dict = arr.object(at: 0) as! NSDictionary
                
                self.score.text = "总平均分:\(String(describing: dict.object(forKey: "avg")!))"
            }
            
            self.loadTotalScore()
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
        }
    }
    
    func loadTotalScore(){
        let parameters = ["appid":"mryy","p":1] as [String : Any]
        
        HttpService.shared().post(urlLast: "userCheck/rankingAll", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            let totalScore = self.listViewArray[0] as! TotalScore
            totalScore.datas = ScoreInfo.mj_objectArray(withKeyValuesArray: obj)
            totalScore.tableView.separatorStyle = .singleLine
            totalScore.tableView.reloadData()
            
            self.loadAVGScore()
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
        }
    }
    
    func loadAVGScore(){
        let parameters = ["appid":"mryy","p":1] as [String : Any]
        
        HttpService.shared().post(urlLast: "userCheck/rankingAvg", parameters: parameters as AnyObject, succeed: { (task:URLSessionDataTask?, obj:AnyObject?) in
            
            let totalScore = self.listViewArray[1] as! TotalScore
            totalScore.datas = ScoreInfo.mj_objectArray(withKeyValuesArray: obj)
            totalScore.tableView.separatorStyle = .singleLine
            totalScore.tableView.reloadData()
            
            EasyLoadingView.hidenLoading(self.loadingView)
            
        }) { (task:URLSessionDataTask?, error:NSError?) in
            EasyLoadingView.hidenLoading(self.loadingView)
        }
    }
    
    func preferredCategory(){
        categoryView = JXCategoryTitleView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(headerTitleHeight)))
        categoryView.titles = titles
        categoryView.backgroundColor = UIColor.white
        categoryView.titleSelectedColor = UIColor(red: 53/255, green: 138/255, blue: 249/255, alpha: 1)
        categoryView.titleColor = UIColor.black
        categoryView.titleColorGradientEnabled = true
        categoryView.titleLabelZoomEnabled = true
        
        let lineView = JXCategoryIndicatorLineView()
        lineView.indicatorLineViewColor = UIColor(red: 53/255, green: 138/255, blue: 249/255, alpha: 1)
        lineView.indicatorLineWidth = 100
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
        
        let view1 = TotalScore()
        view1.type = 0
        
        let view2 = TotalScore()
        view2.type = 1
        
        return [view1, view2]
    }
    
    @objc func onBack(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension SignInRanking:JXPagingViewDelegate {
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
