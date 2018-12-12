//
//  Essence.swift
//  DailyEnglish
//
//  Created by 邱岭男 on 2018/11/22.
//  Copyright © 2018年 邱岭男. All rights reserved.
//

import UIKit

class Essence: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var table: UITableView!
    
    var books:NSArray!
    
    var bookWidth:CGFloat!
    var bookHeight:CGFloat!
    
    var singleWidth:CGFloat!
    
    var offsetX:CGFloat = 30
    var offsetY:CGFloat = 36
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.bounces = false
        
        calculationHeight()
    }
    
    func calculationHeight(){
        
        singleWidth = (screenSize.width - offsetX) / 4
        bookWidth = singleWidth - offsetX
        bookHeight = bookWidth / 80 * 110
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let book = books.object(at: indexPath.row + 1) as! HomeNewsInfo
        
        let title = cell.viewWithTag(1) as! UILabel
        title.text = book.name! as String
        
        let bookView = cell.viewWithTag(2)! as UIView
        
        var i = 0
        
        for item in bookView.subviews {
            if(item.isKind(of: UIImageView.self)){
                item.removeFromSuperview()
            }
        }
        
        for item in book.content {
            
            let x = CGFloat((i % 4)) * singleWidth  + offsetX
            
            let y = CGFloat((i / 4)) * (bookHeight + 10) + offsetY
            
            let imageView = UIImageView(frame: CGRect(x: x, y: y, width: bookWidth, height: bookHeight))
            let url = HttpService.shared().picUrlHead + ((item as! HomeNewsContentInfo).pic as String)
            imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "bg_transparent") , options: .cacheMemoryOnly, completed: nil)
            
            imageView.tag = i + 1000
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(onBook))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
            bookView.addSubview(imageView)
            
            i += 1
            
        }
        
        return cell
    }
    
    @objc func onBook(tap:UITapGestureRecognizer){
        
        let imageView = tap.view as! UIImageView
        
        let cell = imageView.superview?.superview?.superview as! UITableViewCell
        let indexPath = self.table.indexPath(for: cell)! as NSIndexPath
        
        
        let book = books.object(at: indexPath.row + 1) as! HomeNewsInfo
        
        let sb = UIStoryboard(name:"Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "BookDetails") as! BookDetails
        vc.bookInfo = book.content.object(at: imageView.tag - 1000) as? HomeNewsContentInfo
        AppService.shared().navigate.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let book = books.object(at: indexPath.row + 1) as! HomeNewsInfo
        return CGFloat(((book.content.count - 1) / 4) + 1) * (bookHeight + 10) + offsetY + 20
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
