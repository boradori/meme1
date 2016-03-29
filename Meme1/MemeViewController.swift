//
//  ViewController.swift
//  Meme1
//
//  Created by Youngsun Paik on 3/21/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    let topFieldDelegate = TopTextFieldDelegate()
    let bottomFieldDelegate = BottomTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(topTextField, defaultText: "TOP")
        setupTextField(bottomTextField, defaultText: "BOTTOM")
        
        topTextField.delegate = topFieldDelegate
        bottomTextField.delegate = bottomFieldDelegate
        
        // Share button should be disabled until image is picked
        shareButton.enabled = false
    }
    
    // Setup textField function to make top and bottom textFields
    func setupTextField(textField: UITextField, defaultText: String) {
        textField.borderStyle = .None
        textField.textAlignment = .Center
        textField.defaultTextAttributes = memeTextAttributes
        textField.attributedPlaceholder = NSAttributedString(string: defaultText, attributes: memeTextAttributes)
    }
    
    override func viewWillAppear(animated: Bool) { // Hide and show
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) // Camera button is only enabled when source type has camera (actual device)
        subscribeToKeyboardNotifications() // NSNotificationCenter needs subscription to be used.
    }
    
    override func viewWillDisappear(animated: Bool) { // Hide and show
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications() // NSNotificationCenter needs to be unsubscribed when view disappears
    }

    // This is swift's embedded function
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage { // info is dictionary containing the original image
            imagePickerView.image = imagePicked
            imagePickerView.contentMode = .ScaleAspectFill // contentMode -> flag used to determine how a view lays out its content when its bounds change
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = false // Don't forget to disable share button
    }
    
    // Picking an image from album
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self // delegate
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary // SourceType is PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil) // Present!
        shareButton.enabled = true // Share button needs to be enabled after picking an image
    }
    
    // Picking an image from camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self // delegate
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera // SourceType is Camera
        presentViewController(imagePicker, animated: true, completion: nil) // Present!
        shareButton.enabled = true // Share button needs to be enabled after picking an image
    }
    
    // Share memedImage
    @IBAction func shareImage(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil) // UIActivityViewController
        
        controller.completionWithItemsHandler = { activity, success, items, error in
            if success { // when activityViewController completes with items
                self.save(memedImage) // calls save function to save the image
                self.dismissViewControllerAnimated(true, completion: nil) // and dismiss activityViewController
            }
        }
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        toolBar.hidden = true // toolBar needs to be hidden when generating memedImage
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size) // Alright this is the current context (like sketchbook paper)
    view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true) // Renders a snapshot of the complete view hierarchy as visible onscreen into the current context. (Paste everything on the screen to the sketchbook paper)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext() // The current image context (grab the snapshot)
        UIGraphicsEndImageContext() // Job done
        
        toolBar.hidden = false // Job's done. Show the toolBar again.
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: String(topTextField), bottomText: String(bottomTextField), image: imagePickerView.image!, memedImage: memedImage)
        // Append the meme to appDelegate's memes array - I saw this from https://discussions.udacity.com/t/share-activityviewcontroller/33609
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme) // memes is an array in AppDelegate.swift
        
    }
    
    // Text attributes for defaultTextAttributes in setupTextField function
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(), // black outline
        NSForegroundColorAttributeName: UIColor.whiteColor(), // fill with white
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    } // self adds itself to have the specified selector performed when a matching notification is posted.
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo // frame positioning and animation timing are stored in userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    

}