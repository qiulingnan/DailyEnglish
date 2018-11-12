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
        
        setSelectItemImage()
        
        self.navigationController?.isNavigationBarHidden = true
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
//        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    //设置选中状态的图片，主要用于处理让图片选中状态不渲染tinkcolor
    func setSelectItemImage(){
        
        var temp = ["iv_tuijian_press","iv_classify_press","iv_study_press","iv_me_pres"]
        
        for i in 0..<4{
            self.viewControllers?[i].tabBarItem.selectedImage = UIImage(named: temp[i])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        }
        
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
