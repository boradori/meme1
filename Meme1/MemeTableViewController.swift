//
//  SentMemeTableViewController.swift
//  Meme1
//
//  Created by Youngsun Paik on 4/17/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell")
        
        let meme = memes[indexPath.row]
        
        let imageView = UIImageView(image: meme.image)
        cell?.backgroundView = imageView
        
        return cell!

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailVC
        detailVC.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
    
}