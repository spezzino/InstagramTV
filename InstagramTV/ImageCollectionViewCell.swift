//
//  ImageCollectionViewCell.swift
//  InstagramTV
//
//  Created by Stefano Pezzino on 11/27/16.
//  Copyright © 2016 spezzino. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var feedItem: FeedItem!
    
    var savedFrame: CGFloat!
    
    weak var dataTask: URLSessionDataTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        title.alpha = 0.0
        imageView.image = nil
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.alpha = 0.0
        self.savedFrame = self.title.frame.origin.y
        self.title.frame.origin.y = self.savedFrame - 100
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            if self.isFocused {
                self.title.alpha = 1.0
                self.title.frame.origin.y = self.savedFrame
            }
            else {
                self.title.alpha = 0.0
                self.title.frame.origin.y = self.savedFrame - 100
            }
        }, completion: nil)
    }
}
