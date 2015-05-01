//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Twelker on Apr/28/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController {
    
    @IBOutlet weak var myCollectionView  : UICollectionView!
    @IBOutlet weak var edit              : UIBarButtonItem!
    
//    var editMode: Bool = false
    let editMode   : String = "Done"
    let nonEditMode: String = "Edit"
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        // If there are sent memes the sent memes view should be displayed, if not then the meme editor should be displayed
        
        if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count == 0 {
            let storyboard = self.storyboard
            let nextVC = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! UIViewController
            self.presentViewController(nextVC, animated: true, completion: nil)
        } else {
            if self.navigationItem.leftBarButtonItem?.title == editMode {
                // Add "edit collection entries" function
                // Reset editing mode if the view is entered e.g. when it was left for table view while in edit mode
                self.navigationItem.leftBarButtonItem?.title = nonEditMode
                self.doNotShowHideDeleteImage(true)
            }
            myCollectionView.reloadData()
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as? MemeCollectionViewCell
        
        if cell != nil {
            // We now know that cell is not empty. Set the name and image
            cell!.nameLabel.text = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].topText
            cell!.memeImageView?.image = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].memedImage
            cell!.schemeLabel.text = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].bottomText
        }
        
        if self.navigationItem.leftBarButtonItem?.title == editMode {
            cell?.close.hidden = false
        } else {
            cell?.close.hidden = true
        }
        
        //Layer property in Objective C => "http://iostutorialstack.blogspot.in/2014/04/how-to-assign-custom-tag-or-value-to.html"
        cell?.close.layer.setValue(indexPath.row, forKey: "index")
        cell?.close.addTarget(self, action: "deleteMeme:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell!
    }

    func deleteMeme(sender:UIButton) {
        let i : Int = (sender.layer.valueForKey("index")) as! Int
        // Remove from global array
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(i)
        myCollectionView!.reloadData()
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
    
    @IBAction func collectionEditMode (sender: UIBarButtonItem) {
        
        if self.navigationItem.leftBarButtonItem?.title == editMode {
            
            // Change text of button to inform user of state
            // (I have not found a method to verify the type of system button so need a non-system button)
            self.navigationItem.leftBarButtonItem?.title = nonEditMode
            self.doNotShowHideDeleteImage(true)
            
            myCollectionView.reloadData()
            
        } else {
            
            // Change text of button to inform user of state
            self.navigationItem.leftBarButtonItem?.title = editMode
            self.doNotShowHideDeleteImage(false)
        }
    }
    
    func doNotShowHideDeleteImage (hide: Bool){
        
        //Looping through CollectionView Cells in Swift
        //http://stackoverflow.com/questions/25490380/looping-through-collectionview-cells-in-swift
        
        for item in myCollectionView.visibleCells() as! [MemeCollectionViewCell] {
            
            var indexpath : NSIndexPath = myCollectionView!.indexPathForCell(item as MemeCollectionViewCell)!
            var cell : MemeCollectionViewCell = myCollectionView!.cellForItemAtIndexPath(indexpath) as! MemeCollectionViewCell
                        
            //Close Button
            var close : UIButton = cell.viewWithTag(1) as! UIButton
            close.hidden = hide
        }

    }
    
}
