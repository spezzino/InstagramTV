//
//  AppDelegate.swift
//  InstagramTV
//
//  Created by Stefano Pezzino on 11/27/16.
//  Copyright © 2016 spezzino. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func feedFilePath() -> String {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let filePath = paths[0].appendingPathComponent("feedFile.plist")
        return filePath.path
    }
    
    func saveFeed(feed: Feed) -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(feed, toFile: feedFilePath())
        assert(success, "failed to write archive")
        return success
    }
    
    func readFeed(completion: (_ feed: Feed?) -> Void) {
        let path = feedFilePath()
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(withFile: path)
        completion(unarchivedObject as? Feed)
    }
    
    
    func loadOrUpdateFeed(url: NSURL, completion: @escaping (_ feed: Feed?) -> Void) {
        
        let lastUpdatedSetting = UserDefaults.standard.object(forKey: "lastUpdate") as? NSDate
        
        var shouldUpdate = true
        if let lastUpdated = lastUpdatedSetting, NSDate().timeIntervalSince(lastUpdated as Date) < 20 {
            shouldUpdate = false
        }
        if shouldUpdate {
            self.updateFeed(url: url, completion: completion)
        } else {
            self.readFeed { (feed) -> Void in
                if let foundSavedFeed = feed, foundSavedFeed.sourceURL.absoluteString == url.absoluteString {
                    print("loaded saved feed!")
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(foundSavedFeed)
                    })
                } else {
                    self.updateFeed(url: url, completion: completion)
                }
                
                
            }
        }
        
        
        
    }
    
    
    func updateFeed(url: NSURL, completion: @escaping (_ feed: Feed?) -> Void) {
        let request = NSURLRequest(url: url as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if error == nil && data != nil {
                let feed = Feed(data: data! as NSData, sourceURL: url)
                
                if let goodFeed = feed {
                    if self.saveFeed(feed: goodFeed) {
                        UserDefaults.standard.set(NSDate(), forKey: "lastUpdate")
                    }
                }
                
                print("loaded Remote feed!")
                
                OperationQueue.main.addOperation({ () -> Void in
                    completion(feed)
                })
            }
            
        }
        
        task.resume()
    }


}

