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
    
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(MemeDetailVC.editMeme))
        navigationItem.rightBarButtonItem = editButton

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController!.tabBar.hidden = false
    }
    
    
    func editMeme() {
        let controller: MemeViewController
        controller = storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        
        controller.meme = meme
        
//        controller.bottomTextField.text = meme.bottomText
//        controller.topTextField.text = meme.topText
//        controller.imagePickerView.image = meme.memedImage
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
}
