//
//  BookNet.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/21.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class BookNet: UIViewController {
    
    @IBOutlet weak var wordView: WordView!
    @IBOutlet weak var sentenceView: SentenceView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSegement(_ sender: Any) {
        let selectIndex = (sender as! UISegmentedControl).selectedSegmentIndex
        
        if(selectIndex == 0){
            wordView.isHidden = false
            sentenceView.isHidden = true
        }else if(selectIndex == 1){
            wordView.isHidden = true
            sentenceView.isHidden = false
        }
    }
    
    @IBAction func onBcak(_ sender: Any) {
        AppService.shared().navigate.popViewController(animated: true)
    }
}
