//
//  ImageDownloader.swift
//  FlikrSearch
//
//  Created by Ranjit Singh on 06/06/17.
//  Copyright © 2017 Flikr. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloader {
    
    
    class func getDocumentPath(imageName:String) -> String {
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return "\(docDir)/\(imageName)"
    }
    
    class func getImage(image name:String, urlString: String, completionHandler:@escaping (UIImage?)->Void) {
        if let cachedImage = getCachedImage(imageName: name) {
            completionHandler(cachedImage)
        } else {
            self.downloadImage(image: name, urlString: urlString, completionHandler: { (image) in
                completionHandler(image)
            })
        }
    }
    
    class func getCachedImage(imageName:String) -> UIImage? {
        let filePath = getDocumentPath(imageName: imageName)
        if FileManager().fileExists(atPath: filePath) {
            do {
                return UIImage(data: try Data(contentsOf: URL(fileURLWithPath: filePath)))
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func downloadImage(image name:String, urlString:String, completionHandler:@escaping (UIImage?)->Void) {
        
        DispatchQueue.global().async {
            if let url = URL(string: urlString) {
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = data {
                        cacheImage(imageName: name, imageData: imageData)
                        completionHandler(UIImage(data: imageData))
                    }
                }
            }
        }
    }
    
    class func cacheImage(imageName:String, imageData:Data) {
        let filePath = getDocumentPath(imageName: imageName)
        do{
            try imageData.write(to: URL(fileURLWithPath: filePath))
        } catch {
            print("Unable to write at specific file path")
        }
        
    }
}
