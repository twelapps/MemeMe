//
//  ViewController.swift
//  MemeMe
//
//  Created by Twelker on Apr/26/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController {
    
    @IBOutlet weak var myTableView  : UITableView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated) // Give as parameter what the override func also received, here: animated.
        
        // Add "edit table entries" function
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "tableEditMode:")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        
        // If there are sent memes the sent memes view should be displayed, if not then the meme editor should be displayed
        if (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count == 0 {
            let storyboard = self.storyboard
            let nextVC = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! UIViewController
            self.presentViewController(nextVC, animated: true, completion: nil)
        } else {
            // Reset editing mode if the view is entered e.g. when it was left for collection view while in edit mode
            myTableView.setEditing(false, animated: true)
            myTableView.reloadData() // reloadInputViews()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Variable type is inferred
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        
        // We know that cell is not empty now so we use ! to force unwrapping
        cell!.imageView?.image = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].memedImage
        cell!.textLabel!.text  = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].topText
        
        // If the cell has a detail label, we will provide data for it.
        if let detailTextLabel = cell!.detailTextLabel {
            detailTextLabel.text = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].bottomText
        }
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Deselect the selected row otherwise the background of the selected row remains grey
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Next viewcontroller is the MemeDetailViewController
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetail")!
            as! MemeDetailViewController
        
        // Set the selectedMemedImage  property on the MemeDetailViewController
        detailController.selectedMemedImage =
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].memedImage
        
        // Push it onto the nav stack
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func tableEditMode (sender: UIBarButtonItem) {
        if myTableView.editing {
            // Change text of button to inform user of state
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "tableEditMode:")
            // Turn of editing mode
            myTableView.setEditing(false, animated: true)
        } else {
            // Change text of button to inform user of state
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "tableEditMode:")
            // Enter editing mode
            myTableView.setEditing(true, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // Remove from global array
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            // and remove from the view
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            tableView.reloadData()
        }
    }
}
