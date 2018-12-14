//
//  Share.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/19.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

enum ShareType{
    case AudioDetails
}

enum SelectType {
    case wxFriendCircle
    case wxFriend
    case QQ
    case sina
    case QQZone
}

import UIKit

class Share: UIView {

    @IBOutlet weak var bottomView: UIView!
    
    var shareType:ShareType!
    
    var shareTitle:String!
    var shareUrl = "http://www.en8848.com/app/meiri"
    
    var selectType:SelectType!
    
    var _des:String!
    
    func initDatas(){
        bottomView.frame.origin.y = screenSize.height
        UIView.animate(withDuration: 0.5) {
            self.bottomView.frame.origin.y = screenSize.height - 190
        }
        
    }
    
    func removed(){
        bottomView.frame.origin.y = screenSize.height - 190
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.frame.origin.y = screenSize.height
        }) { (complete:Bool) in
             self.removeFromSuperview()
        }
       
    }
    
    func shareToWX(){
        if(self.shareType == .AudioDetails){
            let webPageObject = WXWebpageObject()
            
            webPageObject.webpageUrl = shareUrl
            
            let message = WXMediaMessage()
            message.title = shareTitle
            message.description = self._des
            message.setThumbImage(UIImage(named: "Icon"))
            message.mediaObject = webPageObject
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = message
            
            if(self.selectType == .wxFriendCircle){
                req.scene = Int32(WXSceneSession.rawValue)
            }else if(self.selectType == .wxFriend){
                req.scene = Int32(WXSceneTimeline.rawValue)
            }
            
            WXApi.send(req)
            
        }
        
    }
    
    func shareToQQ(){
        if(self.shareType == .AudioDetails){
            
            let newsObj = QQApiNewsObject.object(with: URL(string: self.shareUrl), title: self.shareTitle, description: self._des, previewImageData: UIImage(named: "Icon")?.pngData())
            
            let req = SendMessageToQQReq(content: newsObj as? QQApiObject)
            
            if(self.selectType == .QQ){
                QQApiInterface.send(req)
            }else if(self.selectType == .QQZone){
                QQApiInterface.sendReq(toQZone: req)
            }
            
        }
    }
    
    @IBAction func onWechat(_ sender: Any) {
        self.selectType = .wxFriendCircle
        
        self.shareToWX()
        
    }
    
    @IBAction func onWechatFriend(_ sender: Any) {
        self.selectType = .wxFriend
        
        self.shareToWX()
    }
    
    @IBAction func onQQ(_ sender: Any) {
        
        self.selectType = .QQ
        
        self.shareToQQ()
    }
    
    @IBAction func onSina(_ sender: Any) {
        self.shareToSina()
    }
    
    func shareToSina(){
        
        if(self.shareType == .AudioDetails){
            let authRequest = WBAuthorizeRequest()
            authRequest.redirectURI = weiboURL
            authRequest.scope = "all"
            
            let request:WBSendMessageToWeiboRequest = WBSendMessageToWeiboRequest.request(withMessage: self.sinaMessage(), authInfo: authRequest, access_token: nil) as! WBSendMessageToWeiboRequest
            WeiboSDK.send(request)
        }
        
        
    }
    
    func sinaMessage() -> WBMessageObject{
        //分享文字和图片   多媒体文件和图片不能同时分享
        
        let message = WBMessageObject()
        //
        //    message.text = NSLocalizedString(@"www.baidu.com", nil);
        //    WBImageObject *image = [WBImageObject object];
        //    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"123456" ofType:@"jpg"]];
        //    message.imageObject = image;
        
        //分享多媒体文件
        let webpage = WBWebpageObject()
        webpage.objectID = "identifier1"
        webpage.title = self.shareTitle
        webpage.description = self._des
        webpage.thumbnailData = UIImage(named: "Icon")?.pngData()
        webpage.webpageUrl = self.shareUrl
        message.mediaObject = webpage
        return message
    }
    
    @IBAction func onQQZone(_ sender: Any) {
        
        self.selectType = .QQZone
        
        self.shareToQQ()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.removed()
    }
}
