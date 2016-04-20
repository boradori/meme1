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
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableCell") as! CustomTableCell
        let meme = memes[indexPath.row]
        
        cell.topText.text = "TOP: \(meme.topText)"
        cell.bottomText.text = "BOTTOM: \(meme.bottomText)"
        cell.memedImage.contentMode = .ScaleAspectFit
        cell.memedImage.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailVC
        detailController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }

}