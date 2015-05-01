//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Twelker on Apr/28/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {

    // Define property on this viewcontroller
    var selectedMemedImage: UIImage!
    
    @IBOutlet var memedImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memedImage.image = selectedMemedImage
        
        self.memedImage.alpha = 0
        
        // Hide the tabbar containing "Table" and "Collection"
        self.tabBarController?.tabBar.hidden = true
        
        // Programmatically add "Action" system toolbar button to the detail view, in order to send the meme again and again
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareMeme:")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.3) {
            self.memedImage.alpha = 1
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unhide the toolbar containing "Table" and "Collection"
        self.tabBarController?.tabBar.hidden = false
        
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        
        // Brings up UIActivityViewController
        let nextController = UIActivityViewController(activityItems: [selectedMemedImage],
            applicationActivities: nil)
        // This is a block that will be executed after return from the activity view controller
        nextController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            //            println("completed \(s) \(ok) \(items) \(err)")
        }
        
        self.presentViewController(nextController, animated: true, completion: nil)
    }

    
}
