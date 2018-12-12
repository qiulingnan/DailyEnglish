//
//  PlayAudio.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/12/12.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class PlayAudio: UIView {
    
    var imgView:UIImageView!

    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.white
        
        let img = UIImage(named: "iv_home_play")
        imgView = UIImageView(image: img)
        self.addSubview(imgView)
        _ = imgView.sd_layout()?.leftSpaceToView(self,15)?.centerYEqualToView(self)?.widthIs(25)?.heightIs(25)
        
        let noticeLabel = SYNoticeBrowseLabel(frame: CGRect(x: 40, y: 0, width: screenSize.width - 40, height: 30))
        self.addSubview(noticeLabel)
        noticeLabel.textColor = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1)
        noticeLabel.textFont = UIFont.systemFont(ofSize: 14)
        noticeLabel.texts = [AppService.shared().palyAudioTitle]
        noticeLabel.textAnimationPauseWhileClick = false
        noticeLabel.browseMode = .horizontalScrollWhileSingle
        noticeLabel.reloadData()
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onTouch))
        self.addGestureRecognizer(tap)
    }
    
    func rotationAnimation(){
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") // 让其在z轴旋转
        rotationAnimation.toValue = NSNumber(value: .pi * 2.0) // 旋转角度
        rotationAnimation.duration = 1.5 // 旋转周期
        rotationAnimation.isCumulative = true // 旋转累加角度
        rotationAnimation.repeatCount = MAXFLOAT // 旋转次数
        imgView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onTouch(){
        
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AudioDetails") as! AudioDetails
        vc.initDatas(id: AppService.shared().palyAudioId, title: AppService.shared().palyAudioTitle! as NSString, mp3Url: AppService.shared().palyAudioMp3Url! as NSString, mp3lrcUrl: AppService.shared().palyAudioMp3lrcUrl! as NSString)
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
}
