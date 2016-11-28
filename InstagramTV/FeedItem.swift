//
//  FeedItem.swift
//  InstagramTV
//
//  Created by Stefano Pezzino on 11/27/16.
//  Copyright © 2016 spezzino. All rights reserved.
//

import UIKit

class FeedItem :NSObject, NSCoding {
    let text: String!
    let location: String!
    let thumbnailUrl: NSURL
    let fullUrl: NSURL
    var likes: Int = 0
    
    init (text: String!, location: String!, thumbnailUrl: NSURL, fullUrl: NSURL, likes: Int) {
        self.text = text
        self.location = location
        self.thumbnailUrl = thumbnailUrl
        self.fullUrl = fullUrl
        self.likes = likes
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.text, forKey: "itemText")
        aCoder.encode(self.location, forKey: "itemLocation")
        aCoder.encode(self.thumbnailUrl, forKey: "itemThumbnailUrl")
        aCoder.encode(self.fullUrl, forKey: "itemFullUrl")
        aCoder.encode(self.likes, forKey: "itemLikes")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let storedText = aDecoder.decodeObject(forKey: "itemText") as? String
        let storedLocation = aDecoder.decodeObject(forKey: "itemLocation") as? String
        let thumbnailUrl = aDecoder.decodeObject(forKey: "itemThumbnailUrl") as? NSURL
        let fullUrl = aDecoder.decodeObject(forKey: "itemFullUrl") as? NSURL
        let storedLikes = aDecoder.decodeObject(forKey: "itemLikes") as? Int
        
        guard storedText != nil && storedLocation != nil && thumbnailUrl != nil && fullUrl != nil && storedLikes != nil else {
            return nil
        }
        self.init(text: storedText, location: storedLocation, thumbnailUrl: thumbnailUrl!, fullUrl: fullUrl!, likes: storedLikes!)
        
        
    }
    
    
}
