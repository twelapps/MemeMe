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
    var originalImage: UIImage // Import UIKit if you use UIImage type
    var memedImage: UIImage
    
    init (topText:String, bottomText:String, originalImage:UIImage, memedImage:UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
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
        let originalImageData = (decoder.decodeObjectForKey("originalImage") as? NSData)
       
        if originalImageData != nil {
            self.originalImage = UIImage(data: originalImageData!)!
        } else {
            self.originalImage = UIImage()
        }
        
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
        let originalImageData = UIImagePNGRepresentation(self.originalImage)
        coder.encodeObject(originalImageData, forKey: "originalImage")
        let memedImageData = UIImageJPEGRepresentation(self.memedImage, 1.0)
        coder.encodeObject(memedImageData, forKey: "memedImage")
    }
}