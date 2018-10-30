//
//  ADDetails.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/10/31.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class ADDetails: UIViewController {

    @IBOutlet weak var web: UIWebView!
    
    var url:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSURLRequest(url: NSURL(string: url)! as URL)
        web.loadRequest(request as URLRequest)
        // Do any additional setup after loading the view.
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
