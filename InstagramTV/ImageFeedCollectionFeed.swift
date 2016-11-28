//
//  ImageFeedCollectionFeed.swift
//  InstagramTV
//
//  Created by Stefano Pezzino on 11/27/16.
//  Copyright © 2016 spezzino. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ImageCell"

class ImageFeedCollectionViewController: UICollectionViewController {
    
    var username: String!
    var urlString = "https://www.instagram.com/%s/media/"
    
    var feed: Feed?  {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(self.feed != nil){
            return
        }
        self.feed = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        urlString = urlString.replacingOccurrences(of: "%s", with: username)
        
        if let url = NSURL(string: urlString) {
            appDelegate.loadOrUpdateFeed(url: url, completion: { (feed) -> Void in
                self.feed = feed
            })
        }

    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.feed?.items.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        let item = self.feed!.items[indexPath.row]
        
        cell.title.text = item.text
        
        let request = NSURLRequest(url: item.thumbnailUrl as URL)
        
        cell.feedItem = item
        
        cell.dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    cell.imageView.image = image
                }
            })
            
        }
        
        
        
        cell.dataTask?.resume()
        
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImageCollectionViewCell {
            cell.dataTask?.cancel()
            cell.imageView.image = nil
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let dvc = segue.destination as! ImageViewController
    
            if let focusedCell = UIScreen.main.focusedView as? ImageCollectionViewCell {
                dvc.feedItem = focusedCell.feedItem
            }
        }

    
}
