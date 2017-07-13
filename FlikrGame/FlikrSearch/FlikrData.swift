//
//  FlikrData.swift
//  FlikrSearch
//
//  Created by Ranjit Singh on 26/05/17.
//  Copyright © 2017 Flikr. All rights reserved.
//

import Foundation

class Flikr {
    
    let farm:Int
    let server:String
    let id:String
    let secret:String
    let header:String
    var isFlipped: Bool = false
    
    init(farm:Int, server:String, id:String, secret:String, header:String) {
        self.farm = farm
        self.server = server
        self.id = id
        self.secret = secret
        self.header = header
    }
    
    var imageURL: String {
        return "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}


extension Flikr: Equatable {
    
    public static func ==(lhs: Flikr, rhs: Flikr) -> Bool {
        return lhs.farm == rhs.farm && lhs.server == rhs.server && lhs.id == rhs.id && lhs.secret == rhs.secret
    }
    
}
