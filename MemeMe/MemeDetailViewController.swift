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
        
        // Hide the toolbar containing "Table" and "Collection"
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.3) {
            self.memedImage.alpha = 1
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // Unhide the toolbar containing "Table" and "Collection"
        self.tabBarController?.tabBar.hidden = false
        
    }
    
}
