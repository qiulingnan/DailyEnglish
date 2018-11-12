//
//  ADWeb.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/8.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class ADWeb: HWBaseWebViewController {

    var model:ScrolInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadBackItems()
        self.url = URL(string: model.mp3url as String)
        
    }
    
    func loadBackItems() {
        let goBackBtn = UIButton.init()
        
        goBackBtn.setImage(UIImage.init(named: "btn_back_normal"), for:.normal)
        goBackBtn.setTitle("", for:.normal)
        goBackBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        goBackBtn.sizeToFit()
//        goBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8)
        
        let backItem = UIBarButtonItem.init(customView: goBackBtn)
        let items:[UIBarButtonItem] = [backItem]
        self.navigationItem.leftBarButtonItems = items
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}
