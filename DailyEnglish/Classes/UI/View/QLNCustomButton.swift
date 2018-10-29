//
//  QLNCustomButton.swift
//  ManPlaying
//
//  Created by qln on 17/4/27.
//  Copyright © 2017年 邱岭男. All rights reserved.
//


/*
 *   主要用于让 UIButton  可以在storyBoard 中可视化的设置圆角 边框颜色
 *
 */

import UIKit

@IBDesignable

class QLNCustomButton: UIButton {

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
