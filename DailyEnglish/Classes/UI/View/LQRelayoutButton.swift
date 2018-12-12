//
//  LQRelayoutButton.swift
//  LQRelayoutButtonSwift
//
//  Created by LiuQiqiang on 2018/8/17.
//  Copyright © 2018年 LiuQiqiang. All rights reserved.
//

import UIKit

enum LQButtonRelayout {
    case left, bottom, normal
}
extension UIButton {
    
    func relayout(_ style: LQButtonRelayout) {
        
        self.layoutIfNeeded()
        guard let titleFrame = self.titleLabel?.frame else {
            return
        }
        guard let imageFrame = self.imageView?.frame else {
            return
        }
        
        let space = titleFrame.minX - imageFrame.minX - imageFrame.width
        
        if style == .left {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleFrame.width + space, bottom: 0, right: -(titleFrame.width + space))
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(titleFrame.minX - imageFrame.minX), bottom: 0, right: titleFrame.minX - imageFrame.minX)
        } else if style == .bottom {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: titleFrame.height + space, right: -(titleFrame.width))
            self.titleEdgeInsets = UIEdgeInsets(top: imageFrame.height + space, left: -(imageFrame.width), bottom: 0, right: 0)
        }
    }
}


















