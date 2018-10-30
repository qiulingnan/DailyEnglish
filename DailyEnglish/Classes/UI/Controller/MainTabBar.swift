//
//  MainTabBar.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/10/30.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        AppService.shared().navigate = self.navigationController
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
