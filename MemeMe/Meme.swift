//
//  Meme.swift
//  MemeMe
//
//  Created by Twelker on Apr/27/15.
//  Copyright (c) 2015 Twelker. All rights reserved.
//

import Foundation
import UIKit

class Meme : NSObject, NSCoding {
    var topText: String
    var bottomText: String
//1    var originalImage: UIImage // Import UIKit if you use UIImage type
    var memedImage: UIImage
        
//1    init (topText:String, bottomText:String, originalImage:UIImage, memedImage:UIImage) {
    init (topText:String, bottomText:String, memedImage:UIImage) {
        self.topText = topText
        self.bottomText = bottomText
//1        self.originalImage = originalImage
        self.memedImage = memedImage
    }


//****************************************************************************************************************
// SAVE THIS COMMENT FOR FUTURE USE:
// IF MEME WERE A STRUCT: ADD A CONSTRUCTOR, and invoke it in MemeEditorViewController
//func memeConstructor(#topText:String, #bottomText:String, #originalImage:UIImage, #memedImage:UIImage) -> Meme {
//    return Meme(topText:topText, bottomText:bottomText, originalImage:originalImage, memedImage:memedImage)
//}
//****************************************************************************************************************


    // MARK: NSCoding
    
    required init(coder decoder: NSCoder) {
        
        self.topText = decoder.decodeObjectForKey("topText") as! String
        self.bottomText = decoder.decodeObjectForKey("bottomText") as! String
//1        let originalImageData = (decoder.decodeObjectForKey("originalImage") as? NSData)
       
//1        if originalImageData != nil {
//1            self.originalImage = UIImage(data: originalImageData!)!
//1        } else {
//1            self.originalImage = UIImage()
//1        }
        
        let memedImageData = (decoder.decodeObjectForKey("memedImage") as? NSData)
        if memedImageData != nil {
            self.memedImage = UIImage(data: memedImageData!)!
        } else {
            self.memedImage = UIImage()
        }
        
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.topText, forKey: "topText")
        coder.encodeObject(self.bottomText, forKey: "bottomText")
//1        let originalImageData = UIImagePNGRepresentation(self.originalImage)
//1        let originalImageData = UIImageJPEGRepresentation(self.originalImage, 0.0)
//1        coder.encodeObject(originalImageData, forKey: "originalImage")
//1        let memedImageData = UIImageJPEGRepresentation(self.memedImage, 1.0)
        let memedImageData = UIImageJPEGRepresentation(self.memedImage, 0.0)
        coder.encodeObject(memedImageData, forKey: "memedImage")
    }
}