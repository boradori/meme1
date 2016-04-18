//
//  SentMemeTableViewController.swift
//  Meme1
//
//  Created by Youngsun Paik on 4/17/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import Foundation
import UIKit

class SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(memes.count)
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableCell") as! CustomTableCell
        let meme = memes[indexPath.row]
        
        cell.topBottomText.text = "TOP: \(meme.topText.text!)" + " " + "Bottom: \(meme.bottomText.text!)"
        cell.memedImage.image = meme.memedImage
        
        return cell
        
        
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailVC
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}