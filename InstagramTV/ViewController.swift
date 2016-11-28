//
//  ViewController.swift
//  InstagramTV
//
//  Created by Stefano Pezzino on 11/27/16.
//  Copyright © 2016 spezzino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClick() {
        self.performSegue(withIdentifier: "imageCollectionSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc: ImageFeedCollectionViewController = segue.destination as! ImageFeedCollectionViewController
        dvc.username = self.textField.text
    }


}

