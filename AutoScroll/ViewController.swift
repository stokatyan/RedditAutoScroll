//
//  ViewController.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/16/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        RedAPI.shared.refreshAccessToken { (succesful) in
            if (succesful) {
                RedAPI.shared.getHotListing(callback: { (json) in
                    if let posts = RedAPI.shared.getPosts(json) {
                        for post in posts {
                            post.rPrint()
                        }
                    } else {
                        print("no posts")
                    }
                })
            } else {
                UIApplication.shared.open(URL(string:RedAPI.shared.kAuthURL)!, options: [:], completionHandler: nil)
            }
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

