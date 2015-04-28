//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Twelker on Apr/28/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        // Do any additional setup after loading the view, typically from a nib.
        
        // If there are sent memes the sent memes view should be displayed, if not then the meme editor should be displayed
        
        if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count == 0 {
            let storyboard = self.storyboard
            let nextVC = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! UIViewController
            self.presentViewController(nextVC, animated: true, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as? MemeCollectionViewCell
        
        if cell != nil {
            // We now know that cell is not empty. Set the name and image
            cell!.nameLabel.text = memes[indexPath.row].topText
            cell!.memeImageView?.image = memes[indexPath.row].memedImage
            cell!.schemeLabel.text = memes[indexPath.row].bottomText
        }
        
        return cell!
    }
        
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Deselect the selected entry otherwise the background of the selected entry remains grey
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        // Next viewcontroller is the MemeDetailViewController
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetail")!
            as! MemeDetailViewController
        
        // Set the selectedMemedImage  property on the MemeDetailViewController
        detailController.selectedMemedImage =
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].memedImage
        
        // Push it on the nav stack
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    
    
}

