//
//  Search.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/13.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class Search: UIView {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var table: UITableView!
    
    func initData(){
        searchField.becomeFirstResponder()
    }
    
    @IBAction func onSearch(_ sender: Any) {
        if(searchField.text != ""){
            AppService.shared().addSearchData(data: searchField.text!)
            
            self.table.reloadData()
            
            self.goSearchDetails(str: searchField.text!)
        }else{
            AppService.shared().showTip(tip: "请输入搜索内容")
        }
    }
    
    func goSearchDetails(str:String){
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchDetails") as! SearchDetails
        vc.searchStr = str
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    @IBAction func onRemoveAll(_ sender: Any) {
        AppService.shared().removeAllSearch()
        self.table.reloadData()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.removeFromSuperview()
    }
}

extension Search:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppService.shared().searchDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = (AppService.shared().searchDatas.object(at: indexPath.row) as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goSearchDetails(str: (AppService.shared().searchDatas.object(at: indexPath.row) as! String))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        AppService.shared().removeSearch(index: indexPath.row)
        self.table.reloadData()
    }
}
