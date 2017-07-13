//
//  RequestSender.swift
//  FlikrSearch
//
//  Created by Ranjit Singh on 26/05/17.
//  Copyright © 2017 Flikr. All rights reserved.
//

import Foundation
import  UIKit

class RequestSender {
    
    class func sendRequest(flikrRequest:FlikrRequest, succes:@escaping ([Flikr])->Void, failure:@escaping (String)->Void) {
        var urlString = FlikrHandler.url.replacingOccurrences(of: "$text", with: flikrRequest.text)
        urlString = urlString.replacingOccurrences(of: "$page", with: String(FlikrRequest.page))
        let httpMethod = FlikrHandler.httpMethod
        
        print("urlString: - \(urlString)")
        print("httpMethod: - \(httpMethod)")
        print("Request Params: - \(flikrRequest.text) ---- \(FlikrRequest.page)")
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = httpMethod
        
        let defaultSession = URLSession(configuration: .default)
        let task = defaultSession.dataTask(with: request) { (responseData, urlResponse, error) in
            
            
            if let data = responseData {
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any?],
                        let photos = jsonData["photos"] as? [String:Any?],
                        let photoList = photos["photo"] as? Array<[String:Any?]> {
                        
                        print("httpMethod: - \(photoList)")
                        succes(FlikrHandler.parser(jsonData: photoList))
                        
                    } else {
                        failure((error?.localizedDescription)!)
                    }
                    
                } catch {
                    failure((error.localizedDescription))
                }
            } else {
                failure((error?.localizedDescription)!)
            }
        }
        
        task.resume()
    }
}

class FlikrRequest {
    static var page:Int = 0
    let text:String
    
    init(text:String) {
        self.text = text
        FlikrRequest.page += 1
    }
}

class FlikrResponse {   
    
    class func  getFlikrData(jsonData:[String:Any?]) -> Flikr? {
        
        guard
        let farm = jsonData["farm"] as? Int,
        let server = jsonData["server"] as? String,
        let id = jsonData["id"] as? String,
        let secret = jsonData["secret"] as? String,
        let header = jsonData["title"] as? String
        
        else { return nil }
        
        return Flikr(farm: farm, server: server, id: id, secret: secret, header: header)
    }
}

class FlikrHandler {
    
    static var url:String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=$text&page=$page"
    }
    
    static var httpMethod:String {
        return "GET"
    }
    
    class func parser(jsonData:Array<[String:Any?]>) -> [Flikr] {
        var flikrList:[Flikr] = []
        for _ in 0..<9 {
            let randomData = Int(arc4random()) % jsonData.count
            if let flikrData = FlikrResponse.getFlikrData(jsonData: jsonData[randomData]) {
                flikrList.append(flikrData)
            }
        }
        return flikrList
    }
}
