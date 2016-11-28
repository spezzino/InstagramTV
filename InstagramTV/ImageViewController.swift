//
//  ImageViewController.swift
//  InstagramTV
//
//  Created by Stefano Pezzino on 11/27/16.
//  Copyright © 2016 spezzino. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var feedItem: FeedItem!
    
    weak var dataTask: URLSessionDataTask?
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var text: UILabel!
    @IBOutlet var likes: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let request = NSURLRequest(url: feedItem.fullUrl as URL)
        
        self.dataTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    self.image.image = image
                }
            })
            
        }
        
        self.dataTask?.resume()
        
        self.text.text = feedItem.text
        self.likes.text = String(feedItem.likes)+" likes"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.dataTask?.cancel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
