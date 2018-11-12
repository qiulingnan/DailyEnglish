//
//  ImageUtil.swift
//  ExcellentLetter
//
//  Created by apple on 15/8/5.
//  Copyright (c) 2015年 gns. All rights reserved.
//

import UIKit

class ImageUtil: NSObject {

    
    class func getImageWithColor(color:UIColor) ->UIImage{

        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func createFolderInDocuments(path:String) {
        
        /// 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString
        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.appendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent(path)
        
        
        do {
            if(!FileManager.default.fileExists(atPath: filePath)) {
                try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            // report error
        }
        
    }
    
    class func saveImage(imageData:NSData, name:String) {
        
        ImageUtil.createFolderInDocuments(path: "Images")
        
        /// 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString
        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.appendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径
        let filePath = docPath.appendingPathComponent("Images/\(name)")
        // 4、将数据写入文件中
        imageData.write(toFile: filePath, atomically: true)
        
    }

    class func readImage(name:NSString) -> UIImage?{
        
        /// 1、获得沙盒的根路径
        let home = NSHomeDirectory() as NSString
        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let docPath = home.appendingPathComponent("Documents") as NSString
        /// 3、获取文本文件路径

        let filePath = docPath.appendingPathComponent("Images/\(name)")
        
        let image:UIImage! = UIImage(contentsOfFile: filePath)
        
        return image
        
    }
    
    /**
     按比例缩放图片
     
     - parameter image:     需要缩放的Image
     - parameter scaleSize: 缩放比例
     
     - returns: 缩放后的Image
     */
    class func scaleImageWithf(image:UIImage,scaleSize:CGSize) -> UIImage{
        
        let size = CGSize(width: image.size.width * scaleSize.width, height: image.size.height * scaleSize.height)
        
        UIGraphicsBeginImageContext(size)
        
        image.draw(in: CGRect(x:0, y:0, width: size.width, height:size.height))
        // 从当前context中创建一个改变大小后的图片
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        // 返回新的改变大小后的图片 
        return scaledImage!;
    }
    
    class func removeAll(){
        
//        /// 1、获得沙盒的根路径
//        let home = NSHomeDirectory() as NSString
//        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
//        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
//        
//        let filePath = docPath.stringByAppendingPathComponent("Images")
//        
//        do {
//            var arr = try NSArray(array: NSFileManager.defaultManager().contentsOfDirectoryAtPath(filePath))
//            
//            for var i=0;i<arr.count;++i{
//                let path = filePath.stringByAppendingPathComponent("/\(arr.objectAtIndex(i))")
//                
//                NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
//            }
//        } catch {
//            // report error
//        }
        
        
    }
    
    class func removeAtName(name:String){
//        /// 1、获得沙盒的根路径
//        let home = NSHomeDirectory() as NSString
//        /// 2、获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
//        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
//        
//        let filePath = docPath.stringByAppendingPathComponent("Images")
//        
//        let path = filePath.stringByAppendingPathComponent(name)
//        
//        NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
    }
}
