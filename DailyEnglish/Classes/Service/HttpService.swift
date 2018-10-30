//
//  HttpSercive.swift
//  ExcellentLetter
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 gns. All rights reserved.
//

import UIKit

typealias Succeed = (URLSessionDataTask?,AnyObject?)->Void
typealias Failure = (URLSessionDataTask?,NSError?)->Void
typealias Refresh = ()->Void


class HttpService :NSObject{
    
    let urlHead:String = "http://common.api.en8848.com/"
    
    let session = AFHTTPSessionManager()
    
    static let httpService:HttpService = HttpService()
    
    var faildObj:AnyObject!
    
    class func shared() ->HttpService {
        return httpService
    }
    
    override init() {
//        session.responseSerializer = AFJSONResponseSerializer()
//        session.requestSerializer = AFJSONRequestSerializer()
        
    }
    
    deinit {
        AFNetworkReachabilityManager.shared().stopMonitoring()
    }
    
    //开启网络监测
    func startNetMonitor() {
        // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        // 检测网络连接的单例,网络变化时的回调方法
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status:AFNetworkReachabilityStatus) -> Void in
            
            if(status == AFNetworkReachabilityStatus.notReachable){
                AppService.shared().showTip(tip: "网络异常")
            }
        }
        
    }
    
    func resetRequestHead(){
        
        session.requestSerializer.clearAuthorizationHeader()
        session.requestSerializer = AFJSONRequestSerializer()
        
    }
    //整体接口的成功失败回调
    
    func succesed(task:URLSessionDataTask,responseObject:AnyObject!,succeed:Succeed,failed:Failure) {
        
        let obj = NetStatus.mj_object(withKeyValues: responseObject)!
        
        succeed(task,obj.data)
    }
    
    func failed(task:URLSessionDataTask!,error:NSError!,failed:Failure,refresh:Refresh?){
        failed(task, error)
//        if(self.faildObj != nil){
//            //* {"errCode":40110012,"message":"refreshToken已失效"}
//            //* {"errCode":40110013,"message":"账号异常"}
//            let model = FaildModel.mj_objectWithKeyValues(self.faildObj)
//            if(model != nil){
//
//                if(model.errCode == 40110011){//"accessToken已失效"
//
//                    let refreshToken = NSUserDefaults.standardUserDefaults().stringForKey(refreshToken_key)
//
//                    if(refreshToken != nil){
//                        self.post("tokens?client=ios", parameters: ["grantType":"refresh","refreshToken":"\(refreshToken!)"], headType: HeadType.HeadType_2, succeed: { (task:NSURLSessionDataTask!, obj:AnyObject!) in
//
//                            AppService.sharedAppService().isLogin = true
//
//                            let u = User.mj_objectWithKeyValues(obj)
//
//                            AppService.sharedAppService().resetLoginData(u)//保存到本地数据
//                            if(refresh != nil){
//                                refresh!()
//                            }
//
//
//                            }, failed: { (task:NSURLSessionDataTask!, error:NSError!) in
//
//                                failed(task, error)
//
//
//                        })
//                    }else{
//                        failed(task, error)
//                    }
//
//
//                }else if(model.errCode == 40110010){//登录冲突
//                    failed(task, error)
//                    AppService.sharedAppService().exitLogin()
//                }else{
//                    failed(task, error)
//                }
//
//            }else{
//                failed(task, error)
//            }
//
//            if(model.errCode == 40110012){
//                failed(task, error)
//                AppService.sharedAppService().exitLogin()
//
//            }else{
//
//                failed(task, error)
//            }
//
//            if(model.errCode == 40110013){
//                failed(task, error)
//                AppService.sharedAppService().exitLogin()
//
//            }else{
//
//                failed(task, error)
//            }
//
//            if(!model.message.isEqual("accessToken已失效")){
//
//                if(model.errCode == 40410000){
//                    AppService.sharedAppService().showTip("商品已下架或者已转移")
//                }else{
//                   AppService.sharedAppService().showTip(model.message as String)
//                }
//            }
//
//        }else{
//            failed(task, error)
//        }
        

        
        
    }
    
    func get(urlLast:String!,parameters:AnyObject?,succeed:@escaping Succeed,failed:@escaping Failure){

        session.get(urlHead + urlLast, parameters: parameters,   progress: { (Progress) in
            
        },success: { (task:URLSessionDataTask, responseObject:Any?) in
            
            self.succesed(task: task,responseObject:responseObject as AnyObject,succeed: succeed,failed: failed)
            
        }) { (task:URLSessionDataTask?, error:Error) in
            self.failed(task: task,error: error as NSError,failed: failed,refresh: nil)
        }
    }
    
    func post(urlLast:String!,parameters:AnyObject?,succeed:@escaping Succeed,failed:@escaping Failure){
     
        session.post(urlHead + urlLast, parameters: parameters, progress: { (Progress) in
            
        }, success: { (task:URLSessionDataTask, responseObject:Any?) in
            
            self.succesed(task: task,responseObject:responseObject as AnyObject,succeed: succeed,failed: failed)
            
        }) { (task:URLSessionDataTask?, error:Error) in
            
            self.failed(task: task,error: error as NSError,failed: failed,refresh: nil)
            
        }
        
        
    }

//    func get(urlLast:String!,parameters:AnyObject?,headType:HeadType?,succeed:Succeed,failed:Failure,refresh:Refresh){
//
//        if headType != nil {
//            resetRequestHead(headType!)
//        }
//
//        session.GET(urlHead + urlLast, parameters: parameters, progress: { (backProgress:NSProgress) -> Void in
//
//            }, success: { (task:NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
//
//                self.succesed(task,responseObject:responseObject,succeed: succeed,failed: failed)
//
//        }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
//
//            self.failed(task,error: error,failed: failed,refresh: refresh)
//        }
//
//    }
//

//  //1111
//    func post(urlLast:String!,parameters:AnyObject?,headType:HeadType,succeed:Succeed,failed:Failure,refresh:Refresh){
//
////        if headType != nil {
////            resetRequestHead(headType!)
////        }
//         resetRequestHead(headType)
//
//        session.POST(urlHead + urlLast, parameters: parameters, progress: { (backProgress:NSProgress) -> Void in
//
//            }, success: {
//                (task:NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
//
//                self.succesed(task,responseObject:responseObject,succeed: succeed,failed: failed)
//
//        }) {
//            (task:NSURLSessionDataTask?, error:NSError) -> Void in
//
//            self.failed(task,error: error,failed: failed,refresh: refresh)
//        }
//
//    }
//
//    func postAllUrl(url:String!,parameters:AnyObject?,headType:HeadType,imageData:NSData,name:String,mineType:String,succeed:Succeed,failed:Failure,refresh:Refresh){
////
////        if headType != nil {
////            resetRequestHead(headType!)
////        }
//        resetRequestHead(headType)
//
////        session.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as? Set<String>
//
//        session.POST(url, parameters: parameters, constructingBodyWithBlock: { (fromData:AFMultipartFormData) in
//
//            let formatter = NSDateFormatter()
//            formatter.dateFormat = "yyyyMMddHHmmss"
//            let str = formatter.stringFromDate(NSDate())
//            let fileName = "\(str).png"
//
//            fromData.appendPartWithFileData(imageData, name: name, fileName: fileName, mimeType: mineType)
//
//        }, progress: { (backProgress:NSProgress) in
//
//        }, success: { (task:NSURLSessionDataTask, responseObject:AnyObject?) in
//            self.succesed(task,responseObject:responseObject,succeed: succeed,failed: failed)
//        }) { (task:NSURLSessionDataTask?, error:NSError) in
//            self.failed(task,error: error,failed: failed,refresh: refresh)
//        }
//
//    }
//    // PUT
//    func put(urlLast:String!,parameters:AnyObject?,headType:HeadType,succeed:Succeed,failed:Failure){
//
////        if headType != nil {
////            resetRequestHead(headType!)
////        }
//        resetRequestHead(headType)
//
//        session.PUT(urlHead + urlLast, parameters: parameters, success: { (task:NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
//
//            self.succesed(task,responseObject:responseObject,succeed: succeed,failed: failed)
//
//        }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
//
//            self.failed(task,error: error,failed: failed,refresh: nil)
//        }
//    }
//
//    func put(urlLast:String!,parameters:AnyObject?,headType:HeadType?,succeed:Succeed,failed:Failure,refresh:Refresh){
//
//        if headType != nil {
//            resetRequestHead(headType!)
//        }
//
//        session.PUT(urlHead + urlLast, parameters: parameters, success: { (task:NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
//
//            self.succesed(task,responseObject:responseObject,succeed: succeed,failed: failed)
//
//        }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
//
//            self.failed(task,error: error,failed: failed,refresh: refresh)
//        }
//    }
//
//    func delete(urlLast:String!,parameters:AnyObject?,headType:HeadType?,succeed:Succeed,failed:Failure,refresh:Refresh){
//
//        if headType != nil {
//            resetRequestHead(headType!)
//        }
//
//        session.DELETE(urlHead + urlLast, parameters: parameters, success: { (task:NSURLSessionDataTask, responseObject:AnyObject?) -> Void in
//
//            self.succesed(task,responseObject:responseObject,succeed: succeed,failed: failed)
//
//        }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
//
//            self.failed(task,error: error,failed: failed,refresh: refresh)
//        }
//    }
//
//    func head(urlLast:String!,parameters:AnyObject?,headType:HeadType?,succeed:Succeed,failed:Failure,refresh:Refresh){
//
//        if headType != nil {
//            resetRequestHead(headType!)
//        }
//
//        session.HEAD(urlHead + urlLast, parameters: parameters,success: { (task:NSURLSessionDataTask) -> Void in
//
//                self.succesed(task,responseObject:nil,succeed: succeed,failed: failed)
//
//        }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
//
//            self.failed(task,error: error,failed: failed,refresh: refresh)
//        }
//
//    }
//
//    func head(urlLast:String!,parameters:AnyObject?,headType:HeadType?,succeed:Succeed,failed:Failure){
//
//        if headType != nil {
//            resetRequestHead(headType!)
//        }
//
//        session.HEAD(urlHead + urlLast, parameters: parameters,success: { (task:NSURLSessionDataTask) -> Void in
//
//            self.succesed(task,responseObject:nil,succeed: succeed,failed: failed)
//
//        }) { (task:NSURLSessionDataTask?, error:NSError) -> Void in
//
//            self.failed(task,error: error,failed: failed,refresh: nil)
//        }
//    }
//
}
