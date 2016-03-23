//
//  ViewController.swift
//  Meme1
//
//  Created by Youngsun Paik on 3/21/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.text = "TOP"
        topTextField.textAlignment = .Center
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .Center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) // enables camera if camera is available.
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage { // info is dictionary containing the original image
            imagePickerView.image = imagePicked
            imagePickerView.contentMode = .ScaleAspectFill // contentMode -> flag used to determine how a view lays out its content when its bounds change
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        topTextField.text = ""
        bottomTextField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//                // Figure out what the new text will be, if we return true
//        var newText: NSString = textField.text!
//        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
//        
//                // hide the label if the newText will be an empty string
//        self.topTextField.hidden = (newText.length == 0)
//        self.bottomTextField.hidden = (newText.length == 0)
//        
//                // Write the length of newText into the label
//        self.topTextField.text = String(newText.length)
//        self.bottomTextField.text = String(newText.length)
//        
//                // returning true gives the text field permission to change its text
//        return true;
//    }

    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: 0.8
    ]
    
    
}