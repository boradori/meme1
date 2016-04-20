//
//  MemeViewController.swift
//  Meme1
//
//  Created by Youngsun Paik on 3/21/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var meme: Meme!
    
    // MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blackColor()
        
        setupTextField(topTextField, defaultText: "TOP")
        setupTextField(bottomTextField, defaultText: "BOTTOM")
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        // Share button should be disabled until image is picked
        shareButton.enabled = false

    }
    
    // Setup textField function to make top and bottom textFields
    func setupTextField(textField: UITextField, defaultText: String) {
        textField.borderStyle = .None
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .AllCharacters
        textField.textAlignment = .Center
        textField.attributedPlaceholder = NSAttributedString(string: defaultText, attributes: memeTextAttributes)
        
    }
    
    // Text attributes for defaultTextAttributes in setupTextField function
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(), // black outline
        NSForegroundColorAttributeName: UIColor.whiteColor(), // fill with white
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    
    // When textField gets activated, placeholder gets empty.
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.placeholder == "TOP" {
            textField.placeholder = ""
        } else if textField.placeholder == "BOTTOM" {
            textField.placeholder = ""
        } else {
            print("placeholder must have either TOP or BOTTOM")
        }
    }
    
    // Applies changes in textField (this applies to all textFields)
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText: NSString = textField.text!
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        textField.text = newText as String
        return false
    }
    
    // When pressing RETURN, keyboard resigns
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Hide and show
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications() // NSNotificationCenter needs subscription to be used.
    }

    
    // Hide and show
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications() // NSNotificationCenter needs to be unsubscribed when view disappears
    }
    
    // Hides status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // Tells the delegate that the user picked a still image or movie.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage { // info is dictionary containing the original image
            imagePickerView.image = imagePicked
            imagePickerView.contentMode = .ScaleAspectFit // contentMode -> flag used to determine how a view lays out its content when its bounds change
            dismissViewControllerAnimated(true, completion: nil) // when user finishing picking image, dismiss
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = false // Don't forget to disable share button
    }
    
    // Picking an image from album
    @IBAction func pickAnImage(sender: AnyObject) {
        pick(.PhotoLibrary) // UIImagePickerControllerSourceType.PhotoLibrary
    }
    
    // Picking an image from camera
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pick(.Camera) // UIImagePickerControllerSourceType.Camera
    }
    
    // Pick function
    func pick(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil) // present UIImagePickerController
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
        presentViewController(controller, animated: true, completion: nil) // present UIActivityViewController
    }
    

    @IBAction func cancelEditMode(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme) // memes is an array in AppDelegate.swift
    }

    
    // MARK: - Keyboard Functions
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = 0 // += getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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