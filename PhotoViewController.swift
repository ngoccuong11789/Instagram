//
//  PhotoViewController.swift
//  Instagram
//
//  Created by mac on 3/9/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit
import AFNetworking
class PhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblView: UITableView!
    var instagramDatas: [NSDictionary]?
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.instagramDatas = responseDictionary["data"] as? [NSDictionary]
                        self.tblView.reloadData()
                    }
                }
        });
        task.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let photo = instagramDatas {
            return (instagramDatas?.count)!
        }else {
            return 0
        }
    }
        
        
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tblView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        let imageData = instagramDatas![indexPath.row]
        
        let posterPath = imageData.valueForKeyPath("images.low_resolution.url") as? String
        let posterUrl = NSURL(string: posterPath!)
        cell.instagramPhoto.setImageWithURL(posterUrl!)
        
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320
    }
    
}
