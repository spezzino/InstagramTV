//
//  Feed.swift
//  InstagramTV
//
//  Created by Stefano Pezzino on 11/27/16.
//  Copyright © 2016 spezzino. All rights reserved.
//

import UIKit

import Foundation



func fixJsonData (data: NSData) -> NSData {
    var dataString = String(data: data as Data, encoding: String.Encoding.utf8)!
    dataString = dataString.replacingOccurrences(of: "\\'", with: "'")
    return dataString.data(using: String.Encoding.utf8)! as NSData
    
}


class Feed :NSObject {
    
    let items: [FeedItem]
    let sourceURL: NSURL
    
    init (items newItems: [FeedItem], sourceURL newURL: NSURL) {
        self.items = newItems
        self.sourceURL = newURL
        super.init()
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(self.items, forKey: "feedItems")
        aCoder.encode(self.sourceURL, forKey: "feedSourceURL")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let storedItems = aDecoder.decodeObject(forKey: "feedItems") as? [FeedItem]
        let storedURL = aDecoder.decodeObject(forKey: "feedSourceURL") as? NSURL
        
        guard storedItems != nil && storedURL != nil  else {
            return nil
        }
        self.init(items: storedItems!, sourceURL: storedURL! )
        
    }
    
    convenience init? (data: NSData, sourceURL url: NSURL) {
        
        var newItems = [FeedItem]()
        
        let fixedData = fixJsonData(data: data)
        
        var jsonObject: Dictionary<String, AnyObject>?
        
        do {
            jsonObject = try JSONSerialization.jsonObject(with: fixedData as Data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String,AnyObject>
        } catch {
            
        }
        
        guard let feedRoot = jsonObject else {
            return nil
        }
        
        guard let items = feedRoot["items"] as? Array<AnyObject>  else {
            return nil
        }
        
        
        for item in items {
            
            guard let itemDict = item as? Dictionary<String,AnyObject> else {
                continue
            }
            guard let media = itemDict["images"] as? Dictionary<String, AnyObject> else {
                continue
            }
            
            guard let thumbnail = media["thumbnail"] as? Dictionary<String, AnyObject> else {
                continue
            }
            
            guard let thumbnailUrl = thumbnail["url"] as? String else {
                continue
            }
            
            guard let url = NSURL(string: thumbnailUrl) else {
                continue
            }
            
            guard let standardResolution = media["standard_resolution"] as? Dictionary<String, AnyObject> else {
                continue
            }
            
            guard let standardUrl = standardResolution["url"] as? String else {
                continue
            }
            
            guard let url2 = NSURL(string: standardUrl) else {
                continue
            }
            
            
            var captionText = "(no caption)"
            let caption = itemDict["caption"] as? Dictionary<String,AnyObject>
            if(caption != nil){
                captionText = caption?["text"] as! String
            }
            
            var likesCount = 0
            let likes = itemDict["likes"] as? Dictionary<String,AnyObject>
            if(likes != nil){
                likesCount = likes?["count"] as! Int
            }
            
            newItems.append(FeedItem(text: captionText, location: nil, thumbnailUrl: url, fullUrl: url2, likes: likesCount))
            
        }
        
        self.init(items: newItems, sourceURL: url)
    }
    
}
