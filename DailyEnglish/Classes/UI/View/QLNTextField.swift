//
//  QLNTextField.swift
//  ExcellentLetter2
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

//
//  解决了UITextField的LeftView左边距紧贴UITextField的问题
//

import UIKit

class QLNTextField: UITextField {
    
    var offsetX:CGFloat = 10.0 // 默认偏移量
    var offsetY:CGFloat = 1.0

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.leftViewRect(forBounds: bounds)
        iconRect.origin.x += offsetX
        iconRect.origin.y -= offsetY
        return iconRect
    }

}
