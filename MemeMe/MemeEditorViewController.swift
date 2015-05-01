//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Twelker on Apr/26/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import UIKit
import MobileCoreServices

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Define the default text attributes for the TOP and BOTTOM fields in the Meme editor
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(), // White text
        NSBackgroundColorAttributeName : UIColor.clearColor(), // Makes the background of the text itself transparent
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topText        : UITextField!
    @IBOutlet weak var bottomText     : UITextField!
    @IBOutlet weak var makePhoto      : UIBarButtonItem!
    @IBOutlet weak var albumPhoto     : UIBarButtonItem!
    @IBOutlet weak var shareMeme      : UIBarButtonItem!
    @IBOutlet weak var cancel         : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Assign the default text attributes and some field-specific attributes to the TOP and BOTTOM fields in the Meme editor
        assignTextFieldAttributes(topText)
        assignTextFieldAttributes(bottomText)
    }
    
    func assignTextFieldAttributes(textField: UITextField) {
        textField.delegate = self                            // together with "class...., UITextFieldDelegate" this statement ensures that the UITextField
                                                             // methods such as "textFieldDidBeginEditing" will be invoked
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center     // Center align text
        textField.borderStyle = UITextBorderStyle.None       // Makes the container in which the text resides transparent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Only set MAKE PICTURE if this is supported, e.g. not by simulator
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            makePhoto.enabled = true
        } else {
            makePhoto.enabled = false
        }
        
        // Only set SHARE MEME function after selecting a picture
        if imagePickerView.image == nil {
            shareMeme.enabled = false
        } else {
            shareMeme.enabled = true
        }
        
        // Only set SENT MEMES ("Cancel") function after having saved at least one meme
        if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count == 0 {
            cancel.title = ""
            cancel.enabled = false
        } else {
            cancel.title = "Cancel"
            cancel.enabled = true
        }
        
        // Subscribe to keyboard notification in order to shift the view up or down (when needed) when keyboard appears/disappears
        self.subscribeToKeyboardNotifications()
    
        self.navigationController?.setToolbarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        // Brings up UIActivityViewController
        var image = generateMemedImage()
        
        let nextController = UIActivityViewController(activityItems: [image],
            applicationActivities: nil)
        // This is a block that will be executed after return from the activity view controller
        nextController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            //            println("completed \(s) \(ok) \(items) \(err)")
            if ok {
                self.saveMeme()
                
                self.navToNextVC()
            }
        }
        
        self.presentViewController(nextController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        navToNextVC()
    }
    
    func navToNextVC () {
        // Return to the TableViewController (via the navigation controller)
            let storyboard = self.storyboard
            let nextVC = storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            self.presentViewController(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func makePhoto(sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        if mediaType.isEqualToString(kUTTypeImage as String) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imagePickerView.image = image
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // Reset default value if not yet done
        if (textField == topText && textField.text == "TOP") {
            textField.text = ""
        }
        
        if (textField == bottomText && textField.text == "BOTTOM") {
            textField.text = ""
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
//        return false
        return true // Udacity code review
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // Move view up if the BOTTOM field is being edited
        if bottomText.isFirstResponder() {
//            self.view.frame.origin.y -= getKeyboardHeight(notification)
            self.view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // Move view down if the BOTTOM field is ending being edited
        if bottomText.isFirstResponder() {
//            self.view.frame.origin.y += getKeyboardHeight(notification)
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func saveMeme() {
        //Create the meme
//****************************************************************************************************************
//        SAVE THIS COMMENT FOR FUTURE USE
//        var meme = memeConstructor(topText: topText.text, bottomText: bottomText.text, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
//****************************************************************************************************************
        var meme = Meme(topText: topText.text, bottomText: bottomText.text, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
//        var meme: Meme()
//        meme.topText = topText.text
//        meme.bottomText = bottomText.text
//        meme.originalImage = imagePickerView.image
//        meme.memedImage = generateMemedImage()
        
        // Add memed image and other info to the memes array on the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage
    {
        // De-activate the upper and lower toolbar that should not be visible on the memed view
        // Upper toolbar has been assigned tag 1, lower toolbar tag 2
        self.view.viewWithTag(1)?.hidden = true
        self.view.viewWithTag(2)?.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let tempMemedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Activate previously de-activated toolbars
        self.view.viewWithTag(1)?.hidden = false
        self.view.viewWithTag(2)?.hidden = false
        
        return tempMemedImage
    }

}