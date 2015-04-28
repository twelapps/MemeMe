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
    
    var memes: [Meme]!
    var meme: Meme!

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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Variable type is inferred
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        
        // We know that cell is not empty now so we use ! to force unwrapping
        cell!.imageView?.image = memes[indexPath.row].memedImage
        cell!.textLabel!.text  = memes[indexPath.row].topText
        
        // If the cell has a detail label, we will provide data for it.
        if let detailTextLabel = cell!.detailTextLabel {
            detailTextLabel.text = memes[indexPath.row].bottomText
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

}

