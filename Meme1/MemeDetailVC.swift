//
//  MemeDetailVC.swift
//  Meme1
//
//  Created by Youngsun Paik on 4/17/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailVC: UIViewController {
    
    @IBOutlet weak var memedImage: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.blackColor()
        tabBarController!.tabBar.hidden = true
        memedImage.contentMode = .ScaleAspectFit
        memedImage.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController!.tabBar.hidden = false
    }

}
