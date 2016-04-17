//
//  MemeDetailVC.swift
//  Meme1
//
//  Created by Youngsun Paik on 4/17/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memedImage: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.topTextField.placeholder = self.meme.topText
        self.bottomTextField.placeholder = self.meme.bottomText
        self.memedImage.image = self.meme.memedImage
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
}