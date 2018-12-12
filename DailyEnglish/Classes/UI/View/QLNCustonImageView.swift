//
//  QLNCustonImageView.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/3.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class QLNCustonImageView: UIImageView {

    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet{
            layer.cornerRadius=cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor() {
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }

}
