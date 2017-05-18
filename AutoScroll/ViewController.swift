//
//  ViewController.swift
//  AutoScroll
//
//  Created by Shant Tokatyan on 5/16/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let kAuthURL = "https://ssl.reddit.com/api/v1/authorize?client_id=sog6MOSPP1E2EQ&response_type=code&state=TEST&redirect_uri=autoscrollRed://blank&duration=permanent&scope=read"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let webView = UIWebView(frame: self.view.frame)
//        self.view.addSubview(webView)
//        webView.loadRequest(URLRequest(url: URL(string: "https://ssl.reddit.com/api/v1/authorize?client_id=sog6MOSPP1E2EQ&response_type=code&state=TEST&redirect_uri=autoscrollRed://blank&duration=permanent&scope=read")!))
        
        UIApplication.shared.open(URL(string:kAuthURL)!, options: [:], completionHandler: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

