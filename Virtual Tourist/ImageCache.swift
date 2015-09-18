//
//  ImageCache.swift
//  Virtual Tourist
//
//  Created by Ioannis Tornazakis on 27/8/15.
//  Copyright (c) 2015 Ioannis Tornazakis. All rights reserved.
//

import UIKit

class ImageCache {
    
    // MARK: - Properties
    
    private var inMemoryCache = NSCache()
    
    // MARK: - Retreiving images
    
    func imageWithIdentifier(identifier:String?) -> UIImage? {
        
        // If the identifier is nil, or empty, return nil
        if identifier == nil || identifier! == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        var data: NSData?
        
        // First try the memory cache
        if let image = inMemoryCache.objectForKey(path) as? UIImage {
            return image
        }
        
        // Next Try the hard drive
        if let data = NSData(contentsOfFile: path) {
            let thisImage = UIImage(data: data)
            return UIImage(data: data)
        }
        
        // Otherwise return nil
        return nil
    }
    
    // MARK: - Saving images
  
    func storeImage(image:UIImage?, withIdentifier identifier:String) {
        
        let path = pathForIdentifier(identifier)
        
        // If the image is nil, remove images from the cache
        if image == nil {
            inMemoryCache.removeObjectForKey(path)
            NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
            return
        }
        
        // Otherwise, keep the image in memory
        inMemoryCache.setObject(image!, forKey: path)
        
        // And in the Documents directory
        let data = UIImagePNGRepresentation(image!)
        data.writeToFile(path, atomically: true)
        
    }
    
    // MARK: - Helper
    
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }

}